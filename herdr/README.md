# Herdr

Configuration for Herdr 0.9.5. Keeps the default `Ctrl+b` command prefix and
uses Gruvbox, matching the Zellij theme.

See [TMUX-COMPARISON.md](TMUX-COMPARISON.md) for the tmux comparison and
alignment choices. The existing tmux configuration is a reference, not assumed
muscle memory; the shared keymap below was explicitly chosen.

## Linking

From the dotfiles root on Linux/macOS, use `stow herdr` to link
`~/.config/herdr/config.toml`.

On Windows, run `.\setup_herdr.ps1` from the dotfiles root. This links the same
file to `%APPDATA%\herdr\config.toml`, following the repository's PowerShell
setup convention. Creating symlinks requires Developer Mode or elevation.
The script refuses to overwrite an existing regular config file; back it up
and move it aside first.

`HERDR_CONFIG_PATH`, if set, overrides Herdr's normal config location.
After linking, restart Herdr or run `herdr server reload-config`.

## Chosen shared keymap

Both Herdr and tmux keep `Ctrl+b`. Press and release it before the action
key below. Direct resize chords do not need the prefix.

| Action | Shortcut |
| --- | --- |
| Help / full shortcut list | `Ctrl+b`, then `?` |
| Focus left / down / up / right | `Ctrl+b`, then `h/j/k/l` |
| Split right / below | `Ctrl+b`, then `v` / `s` |
| Resize down / up / right / left | Direct `Ctrl+Alt+t/s/./,` |
| Close pane / zoom pane | `Ctrl+b`, then `x` / `z` |
| Cycle pane | `Ctrl+b`, then `o` |
| New tab | `Ctrl+b`, then `c` |
| Previous / next tab | `Ctrl+b`, then `p` / `n` |
| Select tab 1-9 | `Ctrl+b`, then `1`-`9` |
| Rename / close tab | `Ctrl+b`, then `,` / `&` |
| Rename workspace (tmux session) | `Ctrl+b`, then `$` |
| Detach, leaving the session running | `Ctrl+b`, then `d` |

Herdr-specific commands:

| Action | Shortcut |
| --- | --- |
| Workspace navigation | `Ctrl+b`, then `w` |
| Goto agents/terminals | `Ctrl+b`, then `g` |
| Visible notification target | `Ctrl+b`, then `Shift+o` |
| Settings | `Ctrl+b`, then `Shift+s` |
| Resize mode | `Ctrl+b`, then `r` |
| Open scrollback in an editor | `Ctrl+b`, then `e` |
| Scrollback/search/selection | `Ctrl+b`, then `[`; `/` searches inside copy mode |
| Toggle sidebar | `Ctrl+b`, then `b` |

The former `Alt+r`, `Alt+w`, and `Alt+/` aliases have been removed. Plain
editor Alt resize keys remain untouched; the extra Ctrl separates multiplexer
resize from editor resize. Directional resize moves a pane boundary, so it
does not exactly reproduce Vim's height/width growth for every pane position.

Directional swap bindings are deliberately unassigned. Direct `Ctrl+h/j/k/l`
smart Neovim navigation remains a goal, not an implemented Herdr integration:
use the prefixed fallback until native-Windows support is solved. The existing
tmux navigator integration is retained.

See [RESEARCH.md](RESEARCH.md) for upstream sources and capability details.
