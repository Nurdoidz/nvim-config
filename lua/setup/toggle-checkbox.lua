--          ╭─────────────────────────────────────────────────────────╮
--          │                     Toggle Checkbox                     │
--          │    https://github.com/opdavies/toggle-checkbox.nvim     │
--          │               Toggle Markdown Checkboxes                │
--          ╰─────────────────────────────────────────────────────────╯

vim.keymap.set('n', '<leader>tc', ':lua require("toggle-checkbox").toggle()<CR>', { desc = '[C]heckbox' })
