--          ╒═════════════════════════════════════════════════════════╕
--          │                     Neovim Keymaps                      │
--          ╘═════════════════════════════════════════════════════════╛

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- ── Remap for dealing with word wrap ────────────────────────
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- ── Diagnostic keymaps ──────────────────────────────────────
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- ── System Clipboard ────────────────────────────────────────
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"*y', { desc = '[Y]ank to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"*Y', { desc = '[Y]ank to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"*p', { desc = '[P]aste from system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"*P', { desc = '[P]aste from system clipboard' })

-- ── Center the Screen ───────────────────────────────────────
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-f>', '<C-f>zz')
vim.keymap.set('n', '<C-b>', '<C-b>zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- ── Move Selected Lines ─────────────────────────────────────
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- ── Indent ──────────────────────────────────────────────────
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right' })

-- ── Substitute the Current Word ─────────────────────────────
vim.keymap.set('n', '<leader>Sw', [[:%s:\<<C-r><C-w>\>:<C-r><C-w>:gI<Left><Left><Left>]], { desc = '[S]ubstitute current [W]ord' })

-- ── Highlight on yank ───────────────────────────────────────
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

