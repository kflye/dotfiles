# Herdr shortcut research

Researched 2026-10-20 against official documentation and the installed
`herdr 0.9.5`. Online documentation is not version-pinned.

## Configuration and linking

Herdr uses TOML at `~/.config/herdr/config.toml` on Linux/macOS and
`%APPDATA%\herdr\config.toml` on Windows. `HERDR_CONFIG_PATH` overrides the
location. Only overrides need to be configured; omitted settings inherit
defaults. The stow package therefore keeps its canonical file at
`herdr/.config/herdr/config.toml`, with a PowerShell linker for Windows.

Sources: [configuration](https://herdr.dev/docs/configuration/);
installed `herdr --help` and `herdr --default-config`.

## Keybinding model

- Default command prefix: `Ctrl+b`. `prefix+h` means press the prefix,
  release it, then press `h`; `alt+r` is a direct chord.
- Actions accept either one binding string or an array of aliases.
  The initial setup used Alt aliases; these were removed during the explicit
  tmux-alignment decisions in [TMUX-COMPARISON.md](TMUX-COMPARISON.md).
- The documented surfaces include terminal, prefix, and navigate modes,
  plus resize and copy modes. Configuration does not expose arbitrary
  Zellij-style pane/tab/move mode tables.
- Navigate-mode `h/j/k/l` bindings are independent from prefixed pane-focus
  actions. Direct `Ctrl+h/j/k/l` pane-focus bindings would intercept those
  keys rather than reproduce the user's `vim-zellij-navigator` integration.
- Custom command bindings can launch shell commands, temporary panes, or
  command popups. These are not persistent floating-pane toggles or a
  declarative sequence of built-in actions.
- Alt delivery depends on the outer terminal. On macOS, Option may require
  configuring the terminal to send Alt rather than composed characters.

Sources: [keyboard](https://herdr.dev/docs/keyboard/),
[configuration](https://herdr.dev/docs/configuration/),
[configuration reference](https://herdr.dev/docs/config-reference/),
[concepts](https://herdr.dev/docs/concepts/);
local Zellij bindings at `zellij/.config/zellij/config.kdl`.

## Semantic matches

| Zellij habit | Herdr candidate | Decision |
| --- | --- | --- |
| `Alt+r`: resize mode | `resize_mode` | Use `prefix+r`; Alt alias removed. |
| `Alt+w`: session mode | `workspace_picker` | Use `prefix+w`; Alt alias removed. Approximate: workspaces are not named sessions. |
| `Alt+/`: scroll/search mode | `copy_mode` | Use `prefix+[`; Alt alias removed. Approximate: combines scrollback, search, and selection. |
| `Alt+s` / `Alt+t`: pane/tab modes | Individual prefixed actions | Retain Herdr's command-prefix workflow; no separate mode tables configured. |
| `Ctrl+h/j/k/l`: smart editor navigation | `focus_pane_*` | Do not bind directly: plain pane focus is not conditional editor integration. |
| `Alt+v`: move mode | Directional `swap_pane_*` actions | Available actions, not an equivalent mode. New direct shortcuts left unassigned. |
| `Alt+g`: lock input | No documented equivalent toggle | Left unassigned. Prefix gating is not a lock mode, especially with direct aliases. |
| `Alt+f`: floating panes | Zoom or command popup | Different semantics; left unassigned. |
| `Alt+q`: Quit | `detach` | Different lifecycle operation; use `prefix+d` for explicitly named detach. |
| `Alt+c` in scroll/search: bottom and exit | No documented configurable composite action | Left unassigned. |

Copy mode documents vi-style scrolling and selection, `/` / `?` search,
`n` / `N` repeat search, and `q` / Escape to exit.
Named Herdr sessions use separate server/runtime namespaces; choosing a
workspace is not switching such a session. Detach leaves the server and panes
running.

Sources: [keyboard](https://herdr.dev/docs/keyboard/),
[configuration reference](https://herdr.dev/docs/config-reference/),
[concepts](https://herdr.dev/docs/concepts/).

## Version checks and validation

The installed binary's `--default-config` omits `copy_mode` and `swap_pane_*`,
although the online reference documents them. Absence from that template
must not be treated as proof that a feature is unsupported.

The installed binary also exposes `herdr config check`. With
`HERDR_CONFIG_PATH` pointing to an isolated scratch config, it accepted
`copy_mode` and `swap_pane_left` and rejected an intentionally unknown
control key. It also accepted the repository config's alias arrays.
This verifies configuration recognition, not live keyboard delivery or
every interactive behavior.

Validate the canonical file without changing the active config:

```powershell
$env:HERDR_CONFIG_PATH = "$PWD\herdr\.config\herdr\config.toml"
herdr config check
```

Set that override only in a temporary shell or restore its previous value
after checking. After linking the real config, use
`herdr server reload-config` or restart Herdr; confirm live shortcuts with
`Ctrl+b`, then `?`.

Sources: installed `herdr config --help`, `herdr config check --help`,
`herdr config check` diagnostics, and `herdr --default-config`;
[configuration](https://herdr.dev/docs/configuration/).
