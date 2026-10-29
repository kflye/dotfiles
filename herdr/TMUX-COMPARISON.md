# Herdr and tmux keybinding alignment

## Goal and current state

Choose a coherent keyboard layout for adopting Herdr, tmux, or both.
The existing tmux configuration is a reference, not established muscle memory:
tmux is not currently used regularly. Vim-style navigation is familiar, but
the specific multiplexer bindings below remain choices.

Alignment decisions were confirmed on 2026-10-21 and applied to both configs.
The following aliases were part of the initial Herdr setup and have now been
removed in favor of prefixed commands:

| Action | Default | Added alias |
| --- | --- | --- |
| Resize mode | Prefix, then `r` | `Alt+r` |
| Workspace navigation | Prefix, then `w` | `Alt+w` |
| Copy/scrollback mode | Prefix, then `[` | `Alt+/` |

The proposed `Alt+j/k` agent navigation was not added. No smart
Herdr-Neovim navigation plugin has been installed.

## Terminology

Prefix below means press `Ctrl+b`, release it, then press the listed key.

| Herdr | Closest everyday tmux equivalent |
| --- | --- |
| Workspace | Session: project container with tabs/windows and panes |
| Tab | Window: pane layout |
| Pane | Pane: a terminal process |
| Agent | A recognized process inside a pane; no built-in agent-status equivalent in tmux |
| Named session | Separate server/runtime namespace; not simply a tmux session |

These are workflow analogies, not identical lifecycle or persistence models.

## Shared bindings

Stock tmux here uses the 3.5a defaults as a stable reference, not development
branch defaults. The comparison tables in this and the next section record
the configurations BEFORE alignment; see "Chosen shared layout" for the
current bindings. Configured tmux behavior assumes its declared TPM plugins
are installed and loaded.

| Action | Herdr | Stock tmux | Repository tmux configuration |
| --- | --- | --- | --- |
| Prefix | `Ctrl+b` | `Ctrl+b` | Same |
| New tab/window | Prefix `c` | Prefix `c` | Same; pain-control inherits pane working directory |
| Next/previous tab/window | Prefix `n` / `p` | Prefix `n` / `p` | Same |
| Select numbered tab/window | Prefix `1`-`9` | Prefix `0`-`9` | Window numbering starts at 1 |
| Close pane | Prefix `x` | Prefix `x` | Same key; confirmation behavior may differ |
| Zoom pane | Prefix `z` | Prefix `z` | Same |
| Copy/scrollback mode | Prefix `[` | Prefix `[` | Same; vi mode with explicit `v` selection and `y` copy bindings |
| Show bindings | Prefix `?` | Prefix `?` | Same |
| Directional pane focus | Prefix `h/j/k/l` | Prefix arrows | Prefix `h/j/k/l` through pain-control |
| Split below | Prefix `-` | Prefix `"` | Prefix `-` or `"` through pain-control |

## Differences that need a decision

| Action | Herdr | Stock tmux | Repository tmux configuration |
| --- | --- | --- | --- |
| Split right | Prefix `v` | Prefix `%` | Prefix `|` or `%`; `\` makes a full-height split |
| Cycle panes | Prefix `Tab` | Prefix `o` | Prefix `o` |
| Detach client | Prefix `q` | Prefix `d` | Prefix `d` |
| Display pane numbers | No matching default listed | Prefix `q` | Prefix `q` |
| Rename tab/window | Prefix `Shift+t` | Prefix `,` | Prefix `,` |
| Close tab/window | Prefix `Shift+x` | Prefix `&` | Prefix `&` |
| Resize panes | Prefix `r` enters resize mode | Prefix `Ctrl+arrows` or `Alt+arrows` | Prefix `Shift+h/j/k/l` through pain-control |
| Swap panes | Prefix `Shift+h/j/k/l` directionally | Prefix `{` / `}` swaps previous/next | Same stock swap keys; uppercase H/J/K/L resize instead |
| Project picker | Prefix `w`: workspace navigation | Prefix `s`: sessions; `w`: window tree | Same stock picker keys |
| Settings | Prefix `s` | Prefix `s` selects sessions | Same as stock |
| Goto agent/terminal | Prefix `g` | No agent-aware equivalent | No agent-aware equivalent |
| Smart Neovim/pane navigation | Not configured | Requires integration | Direct `Ctrl+h/j/k/l` through vim-tmux-navigator |
| Move tab/window backward/forward | Configurable `move_tab_previous/next`, unbound | No matching default pair | Prefix `<` / `>` through pain-control |

The most consequential same-key/different-action conflicts are:

- Prefix `Shift+h/j/k/l`: Herdr swaps panes; configured tmux resizes them.
- Prefix `q`: Herdr detaches; tmux displays pane numbers.
- Prefix `s`: Herdr opens settings; tmux selects sessions.
- Prefix `r`: Herdr enters resize mode; stock tmux redraws the client.
- Prefix `l`: Herdr focuses right; stock tmux selects the last window.
  Pain-control changes tmux's `l` to focus right.

With vim-tmux-navigator defaults, Prefix `Ctrl+l` sends clear-screen,
overriding pain-control's binding for that particular chord. Prefix plain `l`
still focuses right.

## Vim navigation and platform limits

Prefixed `h/j/k/l` pane focus is already shared between Herdr and the
configured tmux. This does not require stealing direct editor Ctrl keys.

Direct `Ctrl+h/j/k/l` smart navigation is a separate integration decision:
it must navigate Neovim splits first, then cross into multiplexer panes at an
editor edge. Binding Herdr's plain pane-focus actions directly would bypass
that editor behavior.

Community Herdr integrations exist, but the inspected versions of
`aimdevlee/herdr-nvim-nav` and `devxplay/herdr.nvim` have Unix-specific code
and are not native-Windows solutions as written. A supported integration or
port is needed before claiming parity on native Windows.

## Herdr-specific agent workflow

Prefix `g` opens Goto. Outside its search field, `b/w/i/d` filters blocked,
working, idle, or done agents; `a` restores all terminals. Select with `j/k`
or arrows, then Enter. Prefix `o` focuses the visible notification's target.

`previous_agent`, `next_agent`, and indexed `focus_agent` are configurable
but unbound by default. Agent navigation should remain distinct from
directional pane focus. Tmux activity/bell alerts are not equivalent to
Herdr's agent-state classification.

## Chosen shared layout

These choices were elicited rather than inferred from the tmux configuration.
Both repository configs were changed; editor configs were only inspected,
not edited.

| Action | Shared binding |
| --- | --- |
| Prefix | `Ctrl+b` |
| Pane focus | Prefix `h/j/k/l` |
| Split right/below | Prefix `v` / `s` |
| Resize down/up/right/left | Direct `Ctrl+Alt+t/s/./,` |
| Detach | Prefix `d` |
| Rename tab/window | Prefix `,` |
| Rename workspace/session | Prefix `$` |
| Close tab/window | Prefix `&` |
| Cycle panes | Prefix `o` |
| New tab/window | Prefix `c` |
| Previous/next tab/window | Prefix `p` / `n` |
| Close/zoom pane | Prefix `x` / `z` |
| Copy mode | Prefix `[` |

Herdr Settings moved from Prefix `s` to Prefix `Shift+s`, because `s` now
splits below. Its notification target moved from Prefix `o` to Prefix
`Shift+o`, because `o` now cycles panes. Overridden Herdr bindings are replaced,
not retained as aliases.

Rename workspace moved from Herdr's Prefix `Shift+w` to Prefix `$`, matching
tmux's rename-session binding. Tmux's `status-keys vi` is applied after TPM
initialization so tmux-sensible cannot override prompt editing to Emacs mode.

The initial Herdr `Alt+r`, `Alt+w`, and `Alt+/` aliases were removed.
Herdr's default directional swap bindings are disabled. Tmux's pain-control
uppercase `H/J/K/L` resize bindings were removed so this family remains
unassigned rather than meaning different operations in the two tools.
Tmux's existing `{` / `}` pane swaps and pain-control's other split aliases
remain available. Overrides run after TPM initialization so plugins do not
replace the selected bindings.

### Editor pattern behind the resize choice

Both `ideavim/.ideavimrc` and `nvim/.config/nvim/lua/flye/remap.lua` use
`Ctrl+h/j/k/l` for window focus and `Alt+t/s/./,` for window sizing.
Neovim uses those Alt keys to increase/decrease height and width; IdeaVim uses
stretch-to-edge actions. They share keys, not identical boundary semantics.
The selected multiplexer resize family adds Ctrl and leaves editor Alt keys
alone. Multiplexer directional resizing also depends on the pane's position,
so it is not a promise of identical Vim grow/shrink behavior.

Neither editor config defined `|/-` split-creation remaps. IdeaVim uses
`Ctrl+w v/s` for move-to-right/below tab-group actions; Neovim retains Vim's
built-in split commands. After inspecting these, the explicit choice was
Prefix `v/s`, not the initially suggested visual separators.

### Still open

- Smart direct `Ctrl+h/j/k/l` navigation is desired. Keep prefixed fallbacks
  until a native-Windows Herdr integration is available. Existing tmux smart
  navigation is retained.
- Directional pane-swap shortcuts remain unassigned.
- Direct agent-list shortcuts remain undecided and unconfigured.
- Project-picker bindings retain each tool's defaults; Herdr workspaces,
  agents, and notifications are not forced into tmux's session model.

## Editor zoom versus multiplexer zoom

Use `Ctrl+w`, then `z` for editor zoom in Neovim and IdeaVim; keep
`Ctrl+b`, then `z` for terminal-pane zoom in Herdr and tmux. The distinct
prefixes let both layers work when Neovim runs inside a multiplexer.

Neovim reuses the existing Snacks dependency's `Snacks.zen.zoom()` toggle,
which displays the current buffer in a full-size floating view without
replacing the underlying split layout. Toggle again to return to that layout.
IdeaVim invokes `MaximizeEditorInSplit`: maximize the editor split, then
normalize split proportions on the next invocation. The IDE action does not
restore arbitrary prior proportions. This is separate from the existing
IdeaVim `Space w z` Zen-mode shortcut.

Sources: [Snacks zoom](https://github.com/folke/snacks.nvim/blob/main/docs/zen.md),
[IDE split-maximize action](https://github.com/JetBrains/intellij-community/blob/master/platform/platform-impl/src/com/intellij/ide/actions/MaximizeEditorInSplitAction.kt).

## Sources

- Local configs: `herdr/.config/herdr/config.toml`, `tmux/.tmux.conf`.
- [Herdr keyboard documentation](https://herdr.dev/docs/keyboard/).
- [Herdr configuration reference](https://herdr.dev/docs/config-reference/).
- [Herdr concepts](https://herdr.dev/docs/concepts/).
- [Tmux 3.5a default keybindings](https://github.com/tmux/tmux/blob/3.5a/key-bindings.c).
- [tmux-pain-control implementation](https://github.com/tmux-plugins/tmux-pain-control/blob/master/pain_control.tmux).
- [vim-tmux-navigator implementation](https://github.com/christoomey/vim-tmux-navigator/blob/master/vim-tmux-navigator.tmux).
- [aimdevlee navigator C helper](https://github.com/aimdevlee/herdr-nvim-nav/blob/main/herdr-nvim-nav.c)
  and [Lua component](https://github.com/aimdevlee/herdr-nvim-nav/blob/main/lua/herdr-nvim-nav/init.lua).
- [devxplay Unix-only helper import](https://github.com/devxplay/herdr.nvim/blob/deed8496356aab90e1cc364dac4f95d898fa6067/src/main.rs#L7).
