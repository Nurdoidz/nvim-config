--          ╒═════════════════════════════════════════════════════════╕
--          │                         Comment                         │
--          │        https://github.com/numToStr/Comment.nvim         │
--          │                     Toggle Comments                     │
--          ╘═════════════════════════════════════════════════════════╛

local comment = require('Comment.api')
vim.keymap.set({ 'n', 'v' }, '<C-_>', comment.toggle.linewise.current)
