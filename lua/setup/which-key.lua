--          ╒═════════════════════════════════════════════════════════╕
--          │                        Which Key                        │
--          │         https://github.com/folke/which-key.nvim         │
--          │                   Key Bindings Popup                    │
--          ╘═════════════════════════════════════════════════════════╛

-- document existing key chains
require('which-key').register {
    ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
    ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
    ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
    ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
    ['<leader>H'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
    ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
    ['<leader>S'] = { name = '[S]ubstitute', _ = 'which_key_ignore' },
    ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
    ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
    ['<leader>f'] = { name = '[F]ile Explorer', _ = 'which_key_ignore' },
    ['<leader>T'] = { name = '[T]rouble', _ = 'which_key_ignore' },
    ['<leader>b'] = { name = 'Comment [B]ox', _ = 'which_key_ignore' },
}
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').register({
    ['<leader>'] = { 'VISUAL <leader>' },
    ['<leader>h'] = { 'Git [H]unk' },
    ['<leader>b'] = { 'Comment [B]ox' },
}, { mode = 'v' })
