--          ╒═════════════════════════════════════════════════════════╕
--          │                          Lazy                           │
--          │           https://github.com/folke/lazy.nvim            │
--          │                     PLugin Manager                      │
--          ╘═════════════════════════════════════════════════════════╛

-- ── Install lazy.nvim ─────────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

-- ─( Configure Plugins )──────────────────────────────────────
require('lazy').setup({

    -- ── Git Wrapper ─────────────────────────────────────────────
    'tpope/vim-fugitive',
    -- ── Github Extension for Fugitive ───────────────────────────
    'tpope/vim-rhubarb',
    -- ── Detect tabstop and shiftwidth Automatically ─────────────
    'tpope/vim-sleuth',

    -- ── LSP ─────────────────────────────────────────────────────
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim', opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
    },

    -- ── Autocompletion ──────────────────────────────────────────
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',

            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
        },
    },

    -- ── Git signs in the gutter ─────────────────────────────────
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add          = { text = '│' },
                change       = { text = '│' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map({ 'n', 'v' }, ']c', function()
                    if vim.wo.diff then
                        return ']c'
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, desc = 'Jump to next hunk' })

                map({ 'n', 'v' }, '[c', function()
                    if vim.wo.diff then
                        return '[c'
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, desc = 'Jump to previous hunk' })

                -- Actions
                -- visual mode
                map('v', '<leader>hs', function()
                    gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = 'stage git hunk' })
                map('v', '<leader>hr', function()
                    gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = 'reset git hunk' })
                -- normal mode
                map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
                map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
                map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
                map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
                map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
                map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
                map('n', '<leader>hb', function()
                    gs.blame_line { full = false }
                end, { desc = 'git blame line' })
                map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
                map('n', '<leader>hD', function()
                    gs.diffthis '~'
                end, { desc = 'git diff against last commit' })

                -- Toggles
                map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
                map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
            end,
        },
    },

    -- ── Keymap Popup ────────────────────────────────────────────
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    },

    -- ── Color Theme ─────────────────────────────────────────────
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        opts = {},
    },

    'rktjmp/lush.nvim',

    -- ── Statusline ──────────────────────────────────────────────
    {
        'nvim-lualine/lualine.nvim',
        opts = {
            options = {
                icons_enabled = true,
                theme = 'tokyonight',
                --        component_separators = '|',
                --        section_separators = '',
            },
        },
    },

    -- ── Text Alignment ────────────────────────────────────────
    { 'echasnovski/mini.align', version = false },

    -- ── Indention Guides, Even on Blank Lines ───────────────────
    -- {
    --     'lukas-reineke/indent-blankline.nvim',
    --     -- Enable `lukas-reineke/indent-blankline.nvim`
    --     -- See `:help ibl`
    --     main = 'ibl',
    --     opts = {},
    -- },

    -- ── Fuzzy Finder (files, lsp, etc) ──────────────────────────
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
    },

    -- ── Lua Library ─────────────────────────────────────────────
    'nvim-lua/plenary.nvim',

    -- ── Quick Switcher ──────────────────────────────────────────
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        requires = { {'nvim-lua/plenary.nvim'} }
    },

    -- ── File Explorer ───────────────────────────────────────────
    {
        'stevearc/oil.nvim',
        opts = {},
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },

    -- ── List for Diagnostics, References, etc. ──────────────────
    {
        'folke/trouble.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {},
    },

    -- ── Todo Comment Highlight ──────────────────────────────────
    {
        'folke/todo-comments.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {},
    },

    -- ── Fancy Comment Boxes and Horizontal Rules ────────────────
    'LudoPinelli/comment-box.nvim',

    -- ── Toggle Comments ─────────────────────────────────────────
    {
        'numToStr/Comment.nvim',
        opts = {},
        lazy = false,
    },

    -- ── Highlight Hex/RGB/etc. Colors ───────────────────────────
    {
        'norcalli/nvim-colorizer.lua',
        opts = {},
        lazy = false,
    },

    -- ── Preview Markdown in the Web Browser ─────────────────────
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },

    -- ── Floating Terminal ───────────────────────────────────────
    'numToStr/FTerm.nvim',

    -- ── Highlight, Edit, and Navigate Node ──────────────────────
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },

    -- ── Show Code Context ───────────────────────────────────────
    'nvim-treesitter/nvim-treesitter-context',

    -- ── Highlight the Word Under the Cursor ─────────────────────
    {
        'sontungexpt/stcursorword',
        opts = {},
        event = 'VeryLazy',
    },

    -- ── Fancy Notification Manager ──────────────────────────────
    'rcarriga/nvim-notify',

    -- ── Toggle Markdown Checkboxes ─────────────────────────
    'opdavies/toggle-checkbox.nvim',

    -- ── Ayame Theme ───────────────────────────────────────────────────────────────
    {
        dir = '~/repo/ayame.nvim',
        name = 'ayame',
    },

    -- ── Custom Theme ──────────────────────────────────────────────────────────────
    {
        "Djancyp/custom-theme.nvim",
        config = function()
            require("custom-theme").setup()
        end,
    },

    -- ── Automatic Session Manager ─────────────────────────────────────────────────
    {
        'rmagatti/auto-session',
        lazy = false,

        ---enables autocomplete for opts
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
            -- log_level = 'debug',
        }
    },

    -- ── Colorizer/Color Picker ────────────────────────────────────────────────────
    'uga-rosa/ccc.nvim',

}, {})
