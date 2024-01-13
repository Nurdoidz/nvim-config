--          ╒═════════════════════════════════════════════════════════╕
--          │                        Harpoon 2                        │
--          │  https://github.com/ThePrimeagen/harpoon/tree/harpoon2  │
--          │                     Quick Switcher                      │
--          ╘═════════════════════════════════════════════════════════╛

local harpoon = require('harpoon')
harpoon:setup()

vim.keymap.set('n', '<leader>Ha', function() harpoon:list():append() end, { desc = '[H]arpoon: [A]dd' })
vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon: Toggle quick menu' })

vim.keymap.set('n', '<C-h>', function() harpoon:list():select(1) end, { desc = 'Harpoon: Select 1'})
vim.keymap.set('n', '<C-j>', function() harpoon:list():select(2) end, { desc = 'Harpoon: Select 2'})
vim.keymap.set('n', '<C-k>', function() harpoon:list():select(3) end, { desc = 'Harpoon: Select 3'})
vim.keymap.set('n', '<C-l>', function() harpoon:list():select(4) end, { desc = 'Harpoon: Select 4'})
