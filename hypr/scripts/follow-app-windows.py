#!/usr/bin/env python3
"""Follow-app windows: when an app (keyed by window class) spawns extra
windows later (launcher, welcome, history, wine extras), silently move them
onto the workspace where the app's main window currently lives.

Only acts on windows opened within the first few minutes of the app, moves
silently (never switches your focused workspace), and updates the anchor as the
main window moves. Logs to ~/.local/state/follow-app.log
"""
import json, os, socket, subprocess, time, glob, sys

RUNTIME = os.environ.get("XDG_RUNTIME_DIR", "/run/user/%s" % os.getuid())
SIG = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE", "")
LOG = os.path.expanduser("~/.local/state/follow-app.log")
TIMEOUT = 300  # follow window-openers for this long after the main window

def log(msg):
    with open(LOG, "a") as f:
        f.write("%s %s\n" % (time.strftime("%H:%M:%S"), msg))

def sock_path():
    if SIG:
        p = "%s/hypr/%s/.socket2.sock" % (RUNTIME, SIG)
        if os.path.exists(p):
            return p
    cands = glob.glob("%s/hypr/*/.socket2.sock" % RUNTIME)
    return cands[0] if cands else None

def hypr(args):
    try:
        out = subprocess.run(["hyprctl", "-j"] + args, capture_output=True, text=True, timeout=5).stdout
        return json.loads(out)
    except Exception:
        return []

def window_info(addr):
    for c in hypr(["clients"]):
        if c.get("address") == addr:
            return c
    return None

def root_pid(pid):
    # nearest ancestor that is stable (not a transient shell): walk until a
    # process whose parent is not a descendant-relevant one is overkill here,
    # so we group by the pid of the *main visible window's* process instead.
    return pid

anchors = {}   # class -> {"ws": int, "t": float, "addr": str}

def handle_open(addr, cls, title):
    time.sleep(0.2)
    c = window_info(addr)
    if not c:
        return
    ws = (c.get("workspace") or {}).get("id")
    if ws is None:
        return
    now = time.time()
    a = anchors.get(cls)
    if not a:
        anchors[cls] = {"ws": ws, "t": now, "addr": addr}
        log("anchor %s -> ws %s" % (cls, ws))
        return
    if now - a["t"] > TIMEOUT:
        return
    if ws != a["ws"]:
        log("move %s '%s' ws %s -> %s" % (cls, title[:40], ws, a["ws"]))
        subprocess.run(["hyprctl", "dispatch", "movetoworkspacesilent", str(a["ws"]), ("address:%s" % addr)],
                       capture_output=True)

def handle_move(addr, ws):
    c = window_info(addr)
    if not c:
        return
    cls = c.get("class")
    if cls and anchors.get(cls) and anchors[cls]["addr"] == addr:
        anchors[cls]["ws"] = ws
        log("anchor %s updated -> ws %s" % (cls, ws))

def seed_anchors():
    now = time.time()
    for c in hypr(["clients"]):
        cls = c.get("class")
        addr = c.get("address")
        ws = (c.get("workspace") or {}).get("id")
        if not cls or cls in anchors or ws is None:
            continue
        anchors[cls] = {"ws": ws, "t": now, "addr": addr}
        log("seed %s -> ws %s" % (cls, ws))

def main():
    path = sock_path()
    if not path:
        log("ERROR: hyprland socket not found")
        return
    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    s.connect(path)
    s.sendall(b"subscribe windowopen\nwindowmove\nwindowclose\n")
    log("started, socket %s" % path)
    seed_anchors()
    buf = ""
    while True:
        data = s.recv(4096)
        if not data:
            break
        buf += data.decode("utf-8", "replace")
        while "\n" in buf:
            line, buf = buf.split("\n", 1)
            line = line.strip()
            if not line:
                continue
            kind, _, payload = line.partition(">>")
            try:
                if kind == "windowopen":
                    addr, cls, title = payload.split(",", 2)
                    handle_open(addr, cls, title)
                elif kind == "windowmove":
                    addr, ws = payload.split(",", 1)
                    try:
                        handle_move(addr, int(ws))
                    except ValueError:
                        pass
            except Exception as e:
                log("ERR %s: %s" % (line[:60], e))
    log("socket closed")

if __name__ == "__main__":
    main()