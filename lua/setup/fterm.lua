--          ╒═════════════════════════════════════════════════════════╕
--          │                       FTerm.nvim                        │
--          │         https://github.com/numToStr/FTerm.nvim          │
--          │                    Floating Terminal                    │
--          ╘═════════════════════════════════════════════════════════╛

local fterm = require('FTerm')
fterm.setup({
    cmd = 'pwsh',
})
vim.keymap.set('n', '<F12>', function() require('FTerm').toggle() end, { desc = 'Toggle floating terminal' })
vim.keymap.set('n', '<F5>', function()
    local ext = vim.fn.expand('%:e')
    local extension_map = {
        lua = 'lua %',
        ps1 = 'pwsh %',
        py = 'python %',
        js = 'node %',
    }
    local command = extension_map[ext]
    if command then
        fterm.run(command:gsub('%%', vim.fn.expand('%')))
    else
        print('No program set to run for this extension.')
    end
end, { desc = 'Run current file' })

