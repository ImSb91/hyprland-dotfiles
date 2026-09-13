# compress.yazi

> @since 26.0.0

Small functional plugin that packs the selected files (or the hovered file if
nothing is selected) into a `zip` archive.

## Usage

```toml
# keymap.toml
[mgr]
keymap = [
  { on = "B", run = "plugin compress", desc = "Compress selected files into a zip" },
]
```

After pressing the key it asks for the archive name (defaults to the stem of a
single selected file, otherwise the current directory name), then runs:

```
zip -r NAME.zip <selected paths>
```

Requires the `zip` (Info-ZIP) binary on `PATH`.

## Notes

- If no files are selected, the hovered file is used instead.
- A `.zip` extension is appended automatically if omitted.
- The input box opens already in insert mode with a pre-filled default name
  (stem of a single file, otherwise the current directory name) — type to
  append, or clear it first (e.g. `Ctrl-u`) to start from scratch.