# Neovim Keymaps Summary

All keymaps are registered in which-key. Press `<Space>` (leader) to see available commands.

## Navigation

### Flash.nvim (Enhanced Motion)
- `s` - Flash jump (normal, visual, operator-pending)
- `S` - Flash treesitter selection
- `r` - Remote flash (operator-pending)
- `R` - Treesitter search (operator-pending, visual)
- `<C-s>` - Toggle flash search (command mode)

## Testing (Neotest)

Prefix: `<leader>t`
- `<leader>tt` - Run test file
- `<leader>tT` - Run all test files
- `<leader>tr` - Run nearest test
- `<leader>tl` - Run last test
- `<leader>ts` - Toggle test summary
- `<leader>to` - Show test output
- `<leader>tO` - Toggle output panel
- `<leader>tS` - Stop tests
- `<leader>td` - Debug nearest test
- `<leader>tw` - Toggle watch mode

## Refactoring & Rust

Prefix: `<leader>r` (shared between refactoring and Rust)

### Refactoring.nvim
- `<leader>re` - Extract function (visual)
- `<leader>rf` - Extract function to file (visual)
- `<leader>rv` - Extract variable (visual)
- `<leader>rI` - Inline function
- `<leader>ri` - Inline variable
- `<leader>rb` - Extract block
- `<leader>rbf` - Extract block to file
- `<leader>rr` - Select refactor (opens menu)
- `<leader>rc` - Debug cleanup
- `<leader>rp` - Debug printf

### Rustaceanvim (Rust files only)
- `<leader>rh` - Hover actions
- `<leader>ra` - Code action
- `<leader>re` - Explain error
- `<leader>rd` - Render diagnostic
- `<leader>rc` - Open Cargo.toml
- `<leader>rp` - Parent module
- `<leader>rj` - Join lines
- `<leader>rs` - Structural search replace
- `<leader>rg` - View crate graph
- `<leader>rm` - Expand macro
- `<leader>rK` - Move item up
- `<leader>rJ` - Move item down
- `<leader>rr` - Runnables
- `<leader>rD` - Debuggables
- `<leader>rt` - Testables

## Git (Gitsigns)

Prefix: `<leader>h`
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hS` - Stage buffer
- `<leader>hu` - Undo stage hunk
- `<leader>hR` - Reset buffer
- `<leader>hp` - Preview hunk
- `<leader>hb` - Blame line
- `<leader>hd` - Diff this
- `<leader>hD` - Diff this ~
- `]c` - Next git hunk
- `[c` - Previous git hunk
- `<leader>tb` - Toggle blame line
- `<leader>tD` - Toggle deleted preview

## Go Development

Prefix: `<leader>g`
- `<leader>gt` - Run tests
- `<leader>gT` - Run test file
- `<leader>gc` - Test coverage
- `<leader>gd` - Debug test
- `<leader>gb` - Build
- `<leader>gr` - Run current file
- `<leader>gi` - Install dependencies
- `<leader>gm` - Tidy modules
- `<leader>gf` - Format file
- `<leader>gl` - Run golangci-lint
- `<leader>gv` - Go vet

## LSP & Code

- `gD` - Go to declaration
- `gd` - Go to definition
- `gi` - Go to implementation
- `gr` - Go to references
- `K` - Hover documentation
- `<C-k>` - Signature help
- `<leader>ca` - Code action
- `<leader>rn` - Rename symbol
- `<leader>D` - Type definition

## Search (Telescope)

Prefix: `<leader>s`
- `<leader>sh` - Search help
- `<leader>sk` - Search keymaps
- `<leader>sf` - Search files
- `<leader>ss` - Select telescope
- `<leader>sw` - Search word
- `<leader>sg` - Live grep
- `<leader>sd` - Search diagnostics
- `<leader>sr` - Resume search
- `<leader>s.` - Recent files
- `<leader><leader>` - Find buffers
- `<leader>/` - Fuzzy search in buffer
- `<leader>s/` - Live grep in open files
- `<leader>sn` - Search Neovim config files

## Debugging

- `<F5>` - Start/Continue
- `<F1>` - Step into
- `<F2>` - Step over
- `<F3>` - Step out
- `<F7>` - Toggle DAP UI
- `<leader>b` - Toggle breakpoint
- `<leader>B` - Conditional breakpoint
- `<leader>db` - Persistent: Toggle breakpoint
- `<leader>dB` - Persistent: Conditional breakpoint
- `<leader>dc` - Persistent: Clear all breakpoints

## File Management

- `\\` - Neo-tree: Toggle
- `<C-Up>` - Yazi: Toggle file manager
- `<leader>fy` - Yazi: Open at current file

## Utilities

- `<leader>n` - Toggle line numbers
- `<leader>w` - Toggle word wrap
- `<leader>q` - Open diagnostic quickfix list
- `<leader>S` - Spectre (search/replace)
- `zR` - UFO: Open all folds
- `zM` - UFO: Close all folds

## Completion (Blink.cmp)

- Auto-triggered in insert mode
- Includes LSP, path, snippets, buffer, and **ripgrep** (project-wide words)
- Ripgrep triggers after 3+ characters
- Uses git grep in git repos for faster results

## Which-Key

- Press `<Space>` to see all leader keymaps
- Press any prefix (like `<leader>t`, `<leader>g`, etc.) and wait to see submenu
- All keymaps are discoverable through which-key!

## Terminal

Prefix: `<leader>t` (conflicts with test - check your config)
- `<leader>tt` - Toggle horizontal terminal
- `<leader>tf` - Toggle floating terminal

---

**Note:** Some keymaps may conflict (e.g., `<leader>t` for both testing and terminal).
Adjust in your config if needed. Use `:WhichKey` to explore all available keymaps interactively.
