--          ╒═════════════════════════════════════════════════════════╕
--          │                       Comment Box                       │
--          │     https://github.com/LudoPinelli/comment-box.nvim     │
--          │              Fancy Comment Boxes and Rules              │
--          ╘═════════════════════════════════════════════════════════╛

vim.keymap.set({ 'n', 'v' }, '<leader>bt', '<Cmd>CBlcbox8<CR>', { desc = '[T]op Header' })
vim.keymap.set({ 'n', 'v' }, '<leader>bh', '<Cmd>CBlcbox1<CR>', { desc = '[H]eader' })
vim.keymap.set({ 'n', 'v' }, '<leader>bH', '<Cmd>CBlcbox10<CR>', { desc = '[H]eader (ASCII)' })
vim.keymap.set({ 'n', 'v' }, '<leader>bs', '<Cmd>CBlcbox18<CR>', { desc = '[S]ub-Header' })
vim.keymap.set({ 'n', 'v' }, '<leader>br', '<Cmd>CBllline1<CR>==', { desc = 'Horizontal [R]ule' })
vim.keymap.set({ 'n', 'v' }, '<leader>bR', '<Cmd>CBllline15<CR>==', { desc = 'Horizontal [R]ule (ASCII)' })
vim.keymap.set({ 'n', 'v' }, '<leader>bl', '<Cmd>CBllline1<CR>==', { desc = '[L]ine' })
vim.keymap.set({ 'n', 'v' }, '<leader>bL', '<Cmd>CBllline15<CR>==', { desc = '[L]ine (ASCII)' })
vim.keymap.set({ 'n', 'v' }, '<leader>be', '<Cmd>CBlrline1<CR>==', { desc = '[E]nd Line' })
vim.keymap.set({ 'n', 'v' }, '<leader>bE', '<Cmd>CBlrline15<CR>==', { desc = '[E]nd Line (ASCII)' })
vim.keymap.set({ 'n', 'v' }, '<leader>bx', '<Cmd>CBd<CR>', { desc = 'Remove' })
vim.keymap.set({ 'n', 'v' }, '<leader>by', '<Cmd>CBy<CR>', { desc = '[Y]ank contents' })
require('comment-box').setup({
    doc_width = 100,
    box_width = 79,
    line_width = 79,
})
