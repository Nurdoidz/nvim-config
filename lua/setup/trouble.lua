--          ╒═════════════════════════════════════════════════════════╕
--          │                         Trouble                         │
--          │          https://github.com/folke/trouble.nvim          │
--          │         List for Diagnostics, References, etc.          │
--          ╘═════════════════════════════════════════════════════════╛

local trouble = require('trouble')
vim.keymap.set('n', '<leader>Tt', function() trouble.toggle() end, { desc = '[T]rouble: [T]oggle' })
vim.keymap.set('n', '<leader>To', function() trouble.open() end, { desc = '[T]rouble: [O]pen' })
vim.keymap.set('n', '<leader>Tc', function() trouble.close() end, { desc = '[T]rouble: [C]lose' })
vim.keymap.set('n', '<leader>Tn', function() trouble.next() end, { desc = '[T]rouble: [N]ext' })
vim.keymap.set('n', '<leader>Tp', function() trouble.previous() end, { desc = '[T]rouble: [P]revious' })
vim.keymap.set('n', '<leader>Tf', function() trouble.first() end, { desc = '[T]rouble: [F]irst' })
vim.keymap.set('n', '<leader>Tl', function() trouble.last() end, { desc = '[T]rouble: [L]ast' })

