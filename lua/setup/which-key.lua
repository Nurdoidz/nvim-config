--          ╒═════════════════════════════════════════════════════════╕
--          │                        Which Key                        │
--          │         https://github.com/folke/which-key.nvim         │
--          │                   Key Bindings Popup                    │
--          ╘═════════════════════════════════════════════════════════╛

-- document existing key chains
require('which-key').add({
    { "<leader>H", group = "[H]arpoon" },
    { "<leader>S", group = "[S]ubstitute" },
    { "<leader>T", group = "[T]rouble" },
    { "<leader>b", group = "Comment [B]ox" },
    { "<leader>c", group = "[C]ode" },
    { "<leader>d", group = "[D]ocument" },
    { "<leader>f", group = "[F]ile Explorer" },
    { "<leader>g", group = "[G]it" },
    { "<leader>h", group = "Git [H]unk" },
    { "<leader>m", group = "[M]arkdown" },
    { "<leader>s", group = "[S]earch" },
    { "<leader>t", group = "[T]oggle" },
    { "<leader>w", group = "[W]orkspace" },
})
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').add({
    {
        mode = { "v" },
        { "<leader>", group = "VISUAL <leader>" },
        { "<leader>b", desc = "Comment [B]ox" },
        { "<leader>h", desc = "Git [H]unk" },
    },
})
