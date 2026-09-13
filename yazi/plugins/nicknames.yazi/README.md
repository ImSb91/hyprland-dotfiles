# nicknames.yazi

> @since 26.0.0

Gives folders nickname labels in the file list, without renaming them — built
for navigating Steam's `compatdata` numbered folders, but works for any folder.

```
214980  ........  ⟦Skyrim⟧  -  Sep 13 05:42
312900  ........  ⟦Doom⟧   -  Sep 13 05:42
```

## Usage

```lua
-- init.lua
require("nicknames"):setup()
```

```toml
# keymap.toml
{ on = "E", run = "plugin nicknames -- add",    desc = "Edit nickname" },
{ on = "T", run = "plugin nicknames -- toggle", desc = "Toggle nicknames" },
```

- `E` — add/edit the nickname of the hovered folder. Empty value removes it.
- `T` — cycle display modes: `off` / `on` / `on + [real name]`.
- Nicknames are saved to `~/.config/yazi/nicknames.lua` (keyed by both full
  path and folder name), so they survive restarts and transfer to other dirs.

## Notes

- Only the *label* changes; the folder itself is never touched.
- Nicknames render just before the size/date area of each row.
- The data file is plain Lua, so it can also be edited by hand: