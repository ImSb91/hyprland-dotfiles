#!/usr/bin/env python3
"""Force every notification to auto-close after 2s.
Reads the org.freedesktop.Notifications method_return (which contains the
assigned notification id) from dbus-monitor and calls CloseNotification(id)
after 2 seconds -- overriding the sender's own expire_timeout (e.g. Vivaldi's
25s) that swaync would otherwise honor."""

import re
import subprocess
import threading
import time

EXPIRES = 2.0

RE_RETURN = re.compile(r"method return time=.*?serial=(\d+) reply_serial=(\d+)")
RE_UINT32 = re.compile(r"^\s*uint32 (\d+)$")

def close(nid):
    subprocess.run(
        ["gdbus", "call", "--session",
         "--dest", "org.freedesktop.Notifications",
         "--object-path", "/org/freedesktop/Notifications",
         "--method", "org.freedesktop.Notifications.CloseNotification", str(nid)],
        check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def run():
    p = subprocess.Popen(
        ["dbus-monitor", "type='method_return',sender=org.freedesktop.Notifications"],
        stdout=subprocess.PIPE, text=True, bufsize=1)
    expecting = False
    for line in p.stdout:
        m = RE_RETURN.search(line)
        if m:
            # method returns carry no member info; a Notify return is a uint32
            expecting = True
            continue
        if expecting:
            m = RE_UINT32.match(line)
            if m:
                threading.Timer(EXPIRES, close, args=[int(m.group(1))]).start()
            expecting = False

if __name__ == "__main__":
    while True:
        try:
            run()
        except Exception:
            time.sleep(1)