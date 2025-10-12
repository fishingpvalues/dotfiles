# Which-Key Mappings Audit Report

## Status: ✅ MOSTLY ACCURATE with some conflicts and missing mappings

---

## Issues Found

### 🔴 Critical Conflicts

#### 1. **`<leader>t` - Terminal vs Test Group Conflict**
**Problem:** Both toggleterm and neotest use `<leader>t` prefix

**Which-key shows:**
- Line 42: `{ "<leader>t", group = "terminal" }`
- Line 100: `{ "<leader>t", group = "test" }` ⚠️ **CONFLICT**

**Actual keymaps:**
- `<leader>tt` - toggleterm: horizontal terminal (toggleterm.lua:28)
- `<leader>tf` - toggleterm: floating terminal (toggleterm.lua:29)
- `<leader>tt` - neotest: Run File (neotest.lua:173) ⚠️ **OVERWRITE**
- `<leader>tT` - neotest: Run All Files
- `<leader>tr` - neotest: Run Nearest
- `<leader>tl` - neotest: Run Last
- `<leader>ts` - neotest: Toggle Summary
- `<leader>to` - neotest: Show Output
- `<leader>tO` - neotest: Toggle Output Panel
- `<leader>tS` - neotest: Stop
- `<leader>td` - neotest: Debug Nearest
- `<leader>tw` - neotest: Toggle Watch

**Resolution:** Neotest keymaps load AFTER toggleterm, so `<leader>tt` opens **neotest Run File**, not toggleterm horizontal terminal!

**Recommendation:** Change toggleterm to different prefix or use `<C-\>` only

---

#### 2. **`<leader>r` - Refactor vs Rust Group Conflict**
**Problem:** Both refactoring.nvim and rustaceanvim use `<leader>r` prefix

**Which-key shows:**
- Line 113: `{ "<leader>r", group = "refactor/rust" }` (acknowledges overlap)

**Conflicts:**
- `<leader>re` - Refactoring: Extract Function (visual mode) vs Rust: Explain Error (normal mode)
- `<leader>rc` - Refactoring: Debug Cleanup vs Rust: Open Cargo.toml
- `<leader>rp` - Refactoring: Debug Printf vs Rust: Parent Module
- `<leader>rr` - Refactoring: Select Refactor vs Rust: Runnables

**Resolution:** These conflict based on filetype and mode. In Rust files, Rust keymaps override. In other files, refactoring keymaps work.

**Recommendation:** This is acceptable as mode/filetype-specific, but could be clearer in which-key

---

### 🟡 Minor Issues

#### 3. **`<leader>hu` - Incorrect Description**
**Which-key shows:**
- Line 46: `{ "<leader>hu", desc = "Undo Stage Hunk" }`

**Actual keymap:**
- gitsigns.lua:46: `gitsigns.stage_hunk` (should be `undo_stage_hunk`)

**Status:** ⚠️ **INCORRECT** - This actually stages a hunk, not undo stage!

**Recommendation:** Fix gitsigns.lua:46 to use `gitsigns.undo_stage_hunk()`

---

#### 4. **Missing Go Coverage Keymaps**
**Which-key missing:**
- `<leader>gcv` - Load and show coverage (golang.lua:76)
- `<leader>gch` - Hide coverage (golang.lua:80)
- `<leader>gcs` - Coverage summary (golang.lua:84)
- `<leader>gdt` - Debug Go test (golang.lua:143)
- `<leader>gdl` - Debug last Go test (golang.lua:147)

**Recommendation:** Add to which-key

---

#### 5. **Missing Gitsigns Toggle Keymaps**
**Which-key missing:**
- `<leader>tb` - Toggle git blame line (gitsigns.lua:55)
- `<leader>tD` - Toggle git show deleted (gitsigns.lua:56)

**Note:** These would also conflict with `<leader>t` test group!

**Recommendation:** Move to `<leader>h` group or document in which-key

---

## ✅ Correct Mappings

### Terminal (toggleterm.nvim)
- ✅ `<C-\>` - Quick toggle (not in which-key, but documented in toggleterm.lua:8)
- ⚠️ `<leader>tt` - **OVERWRITTEN by neotest**
- ✅ `<leader>tf` - Toggle floating terminal

### Explorer
- ✅ `<leader>ee` - Toggle file explorer
- ✅ `<leader>fe` - Find file in explorer

### Session
- ✅ `<leader>qs` - Restore session for current dir
- ✅ `<leader>ql` - Restore last session
- ✅ `<leader>qd` - Don't save session

### Code/LSP
- ✅ `<leader>ca` - LSP Code Action
- ✅ `<leader>rn` - LSP Rename
- ✅ `<leader>o` - LSP Outline
- ✅ `<leader>fd` - LSP Finder
- ✅ `<leader>sd` - Show Line Diagnostics
- ✅ `K` - LSP Hover Doc

### Debug (DAP)
- ✅ `<F5>` - Debug: Start/Continue
- ✅ `<F1>` - Debug: Step Into
- ✅ `<F2>` - Debug: Step Over
- ✅ `<F3>` - Debug: Step Out
- ✅ `<F7>` - Debug: Toggle DAP UI
- ✅ `<leader>b` - Debug: Toggle Breakpoint
- ✅ `<leader>B` - Debug: Set Conditional Breakpoint
- ✅ `<leader>db` - Persistent: Toggle Breakpoint
- ✅ `<leader>dB` - Persistent: Set Conditional Breakpoint
- ✅ `<leader>dc` - Persistent: Clear All Breakpoints

### Other
- ✅ `<leader>S` - Open Spectre
- ✅ `<leader>fy` - Yazi: Open at current file
- ✅ `<C-Up>` - Yazi: Toggle file manager
- ✅ `\\` - Neo-tree: Reveal/Close
- ✅ `zR` - UFO: Open all folds
- ✅ `zM` - UFO: Close all folds

### Golang
- ✅ `<leader>gt` - Go: Run tests
- ✅ `<leader>gT` - Go: Run test file
- ✅ `<leader>gc` - Go: Test coverage
- ✅ `<leader>gd` - Go: Debug test
- ✅ `<leader>gb` - Go: Build
- ✅ `<leader>gr` - Go: Run
- ✅ `<leader>gi` - Go: Install deps
- ✅ `<leader>gm` - Go: Tidy modules
- ✅ `<leader>gf` - Go: Format
- ✅ `<leader>gl` - Go: Lint
- ✅ `<leader>gv` - Go: Vet

### Flash.nvim
- ✅ `s` - Flash: Jump
- ✅ `S` - Flash: Treesitter
- ✅ `r` - Flash: Remote (operator mode)
- ✅ `R` - Flash: Treesitter Search

### Neotest
- ✅ `<leader>tt` - Test: Run File (overwrites toggleterm!)
- ✅ `<leader>tT` - Test: Run All Files
- ✅ `<leader>tr` - Test: Run Nearest
- ✅ `<leader>tl` - Test: Run Last
- ✅ `<leader>ts` - Test: Toggle Summary
- ✅ `<leader>to` - Test: Show Output
- ✅ `<leader>tO` - Test: Toggle Output Panel
- ✅ `<leader>tS` - Test: Stop
- ✅ `<leader>td` - Test: Debug Nearest
- ✅ `<leader>tw` - Test: Toggle Watch

### Refactoring.nvim
- ✅ `<leader>re` - Refactor: Extract Function (visual)
- ✅ `<leader>rf` - Refactor: Extract Function To File (visual)
- ✅ `<leader>rv` - Refactor: Extract Variable (visual)
- ✅ `<leader>rI` - Refactor: Inline Function
- ✅ `<leader>ri` - Refactor: Inline Variable
- ✅ `<leader>rb` - Refactor: Extract Block
- ✅ `<leader>rbf` - Refactor: Extract Block To File
- ✅ `<leader>rr` - Refactor: Select Refactor
- ✅ `<leader>rc` - Refactor: Debug Cleanup
- ✅ `<leader>rp` - Refactor: Debug Printf

### Rustaceanvim
- ✅ `<leader>rh` - Rust: Hover Actions
- ✅ `<leader>ra` - Rust: Code Action
- ✅ `<leader>re` - Rust: Explain Error (conflicts with refactoring in Rust files)
- ✅ `<leader>rd` - Rust: Render Diagnostic
- ✅ `<leader>rc` - Rust: Open Cargo.toml (conflicts with refactoring in Rust files)
- ✅ `<leader>rp` - Rust: Parent Module (conflicts with refactoring in Rust files)
- ✅ `<leader>rj` - Rust: Join Lines
- ✅ `<leader>rs` - Rust: Structural Search Replace
- ✅ `<leader>rg` - Rust: View Crate Graph
- ✅ `<leader>rm` - Rust: Expand Macro
- ✅ `<leader>rK` - Rust: Move Item Up
- ✅ `<leader>rJ` - Rust: Move Item Down
- ✅ `<leader>rr` - Rust: Runnables (conflicts with refactoring in Rust files)
- ✅ `<leader>rD` - Rust: Debuggables
- ✅ `<leader>rt` - Rust: Testables

### Gitsigns
- ✅ `<leader>hs` - Git: Stage Hunk
- ✅ `<leader>hr` - Git: Reset Hunk
- ✅ `<leader>hS` - Git: Stage Buffer
- ⚠️ `<leader>hu` - **INCORRECT** (should be undo_stage_hunk)
- ✅ `<leader>hR` - Git: Reset Buffer
- ✅ `<leader>hp` - Git: Preview Hunk
- ✅ `<leader>hb` - Git: Blame Line
- ✅ `<leader>hd` - Git: Diff This
- ✅ `<leader>hD` - Git: Diff This ~
- ✅ `]c` - Git: Next Hunk
- ✅ `[c` - Git: Prev Hunk

---

## Summary

### Critical Issues (Must Fix): 2
1. `<leader>tt` conflict between toggleterm and neotest
2. `<leader>hu` incorrect implementation in gitsigns

### Minor Issues (Should Fix): 3
1. `<leader>r` conflict between refactoring and rust (acceptable, but document better)
2. Missing Go coverage keymaps in which-key
3. Missing gitsigns toggle keymaps in which-key (also have conflicts)

### Overall Accuracy: ~92%
- Total registered mappings: ~80
- Correct: ~74
- Incorrect: 1
- Conflicts: 2
- Missing: 5

---

## Recommended Fixes

### 1. Fix the `<leader>tt` Conflict

**Option A: Move toggleterm to different prefix**
```lua
-- In toggleterm.lua
vim.keymap.set("n", "<leader>Tt", ":ToggleTerm direction=horizontal<CR>",
  { desc = "Toggle horizontal terminal" })
vim.keymap.set("n", "<leader>Tf", ":ToggleTerm direction=float<CR>",
  { desc = "Toggle floating terminal" })
```

**Option B: Use only `<C-\>` for toggleterm**
Remove `<leader>tt` and `<leader>tf` from toggleterm, document only `<C-\>`

### 2. Fix `<leader>hu` in gitsigns

```lua
-- In gitsigns.lua:46, change from:
map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })

-- To:
map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
```

### 3. Add Missing Keymaps to which-key

```lua
-- Add to which_key_fix.lua after line 91:
{ "<leader>gcv", desc = "Go: Load coverage" },
{ "<leader>gch", desc = "Go: Hide coverage" },
{ "<leader>gcs", desc = "Go: Coverage summary" },
{ "<leader>gdt", desc = "Go: Debug test" },
{ "<leader>gdl", desc = "Go: Debug last test" },
```

### 4. Move gitsigns toggles to `<leader>h` group

```lua
-- In gitsigns.lua, change from <leader>tb and <leader>tD to:
map('n', '<leader>htb', gitsigns.toggle_current_line_blame,
  { desc = 'Toggle git blame line' })
map('n', '<leader>htd', gitsigns.preview_hunk_inline,
  { desc = 'Toggle git show deleted' })
```

Then add to which-key:
```lua
{ "<leader>htb", desc = "Git: Toggle Blame" },
{ "<leader>htd", desc = "Git: Toggle Deleted" },
```
