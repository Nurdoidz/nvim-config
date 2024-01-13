--          ╒═════════════════════════════════════════════════════════╕
--          │                           Oil                           │
--          │          https://github.com/stevearc/oil.nvim           │
--          │                      File Explorer                      │
--          ╘═════════════════════════════════════════════════════════╛

local oil = require('oil')
oil.setup({
    columns = {
        { 'mtime', format = '%Y-%m-%d %H:%M:%S' },
        'size',
        'icon',
    },
    keymaps = {
        ['<C-s>'] = false,
        ['<C-h>'] = false,
        ['<C-t>'] = false,
        ['<C-l>'] = false,
        ['`'] = false,
        ['~'] = false,
    }
})
vim.keymap.set('n', '<leader>fe', '<CMD>Oil<CR>', { desc = '[F]ile [E]xplorer' })
vim.keymap.set('n', '<leader>ff', function() oil.toggle_float(nil) end, { desc = '[F]ile Explorer [F]loat' })
