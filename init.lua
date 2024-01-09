--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--          ╭─────────────────────────────────────────────────────────╮
--          │           Install `lazy.nvim` plugin manager            │
--          ╰─────────────────────────────────────────────────────────╯

--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
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

--          ╭─────────────────────────────────────────────────────────╮
--          │                    Configure Plugins                    │
--          ╰─────────────────────────────────────────────────────────╯

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
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

  {
    -- Autocompletion
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

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
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

  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'tokyonight',
--        component_separators = '|',
--        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
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

  {
    'codota/tabnine-nvim',
    build = 'pwsh.exe -file .\\dl_binaries.ps1'
  },

  {
    'nvim-lua/plenary.nvim'
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    requires = { {'nvim-lua/plenary.nvim'} }
  },

  -- {
  --   'DaikyXendo/nvim-material-icon'
  -- },

  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  {
    'dcampos/nvim-snippy',
  },

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },

  {
    'LudoPinelli/comment-box.nvim',
  },

  {
    'numToStr/Comment.nvim',
    lazy = false,
  },

  {
    'TimUntersberger/neofs'
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  {
    'nvim-treesitter/nvim-treesitter-context'
  },

  {
    'sontungexpt/stcursorword',
    event = 'VeryLazy',
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})

--          ╭─────────────────────────────────────────────────────────╮
--          │                     Setting Options                     │
--          ╰─────────────────────────────────────────────────────────╯

-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

vim.o.nu = true
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.o.colorcolumn = '80'
vim.o.smartindent = true
vim.o.cursorline = true
vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.o.textwidth = 80

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

--          ╭─────────────────────────────────────────────────────────╮
--          │                     General Keymaps                     │
--          ╰─────────────────────────────────────────────────────────╯

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set('n', '<leader>Sw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[S]ubstitute current [W]ord' })

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-f>', '<C-f>zz')
vim.keymap.set('n', '<C-b>', '<C-b>zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                   Configure Telescope                   │
--          ╰─────────────────────────────────────────────────────────╯

-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

--          ╭─────────────────────────────────────────────────────────╮
--          │                  Configure Tokyo Night                  │
--          ╰─────────────────────────────────────────────────────────╯

require('tokyonight').setup {
  transparent = true,
}
vim.cmd[[colorscheme tokyonight]]

--          ╭─────────────────────────────────────────────────────────╮
--          │                    Configure Tabnine                    │
--          ╰─────────────────────────────────────────────────────────╯

require('tabnine').setup {
  accept_keymap = '<C-\\>',
}

--          ╭─────────────────────────────────────────────────────────╮
--          │                      Configure Oil                      │
--          ╰─────────────────────────────────────────────────────────╯

require('oil').setup({
  columns = {
    { 'mtime', format = '%Y-%m-%d %H:%M:%S' },
    'size',
    'icon',
  },
  view_options = {
    show_hidden = true,
  },
})
local oil = require('oil')
vim.keymap.set('n', '<leader>fe', '<CMD>Oil<CR>', { desc = '[F]ile [E]xplorer' })
vim.keymap.set('n', '<leader>ff', function() oil.toggle_float(nil) end, { desc = '[F]ile Explorer [F]loat' })

--          ╭─────────────────────────────────────────────────────────╮
--          │                    Configure Snippy                     │
--          ╰─────────────────────────────────────────────────────────╯

require('snippy').setup({
  mappings = {
    is = {
      ['<Tab>'] = 'expand_or_advance',
      ['<S-Tab>'] = 'previous',
    },
  },
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                 Configure Todo Comments                 │
--          ╰─────────────────────────────────────────────────────────╯

local todo = require('todo-comments')
vim.keymap.set('n', '<leader>jc', function() todo.jump_next() end, { desc = '[J]ump to next Todo [C]omment' })
vim.keymap.set('n', '<leader>jC', function() todo.jump_prev() end, { desc = '[J]ump to previous Todo [C]omment' })

--          ╭─────────────────────────────────────────────────────────╮
--          │                  Configure Comment Box                  │
--          ╰─────────────────────────────────────────────────────────╯

local commentBoxConfig = {
  name = 'Comment [B]ox',
  b = {
    name = 'Comment [B]ox: [B]ox',
    l = {
      name = 'C[B]: [B]ox: [L]eft box',
      l = {
        name = 'C[B]: [B]ox: [L]eft box: [L]eft text',
        f = { '<Cmd>CBllbox1<CR>', '[F]ull' },
        p = { '<Cmd>CBllbox8<CR>', '[P]added' },
        v = { '<Cmd>CBllbox18<CR>', '[V]ertically enclosed' },
        h = { '<Cmd>CBllbox20<CR>', '[H]orizontally enclosed' },
      },
      c = {
        name = 'C[B]: [B]ox: [L]eft box: [C]enter text',
        f = { '<Cmd>CBlcbox1<CR>', '[F]ull' },
        p = { '<Cmd>CBlcbox8<CR>', '[P]added' },
        v = { '<Cmd>CBlcbox18<CR>', '[V]ertically enclosed' },
        h = { '<Cmd>CBlcbox20<CR>', '[H]orizontally enclosed' },
      },
      r = {
        name = 'C[B]: [B]ox: [L]eft box: [R]ight text',
        f = { '<Cmd>CBlrbox1<CR>', '[F]ull' },
        p = { '<Cmd>CBlrbox8<CR>', '[P]added' },
        v = { '<Cmd>CBlrbox18<CR>', '[V]ertically enclosed' },
        h = { '<Cmd>CBlrbox20<CR>', '[H]orizontally enclosed' },
      },
    },
    c = {
      name = 'C[B]: [B]ox: [C]enter box',
      l = {
        name = 'C[B]: [B]ox: [C]enter box: [L]eft text',
        f = { '<Cmd>CBclbox1<CR>', '[F]ull' },
        p = { '<Cmd>CBclbox8<CR>', '[P]added' },
        v = { '<Cmd>CBclbox18<CR>', '[V]ertically enclosed' },
        h = { '<Cmd>CBclbox20<CR>', '[H]orizontally enclosed' },
      },
      c = {
        name = 'C[B]: [B]ox: [C]enter box: [C]enter text',
        f = { '<Cmd>CBccbox1<CR>', '[F]ull' },
        p = { '<Cmd>CBccbox8<CR>', '[P]added' },
        v = { '<Cmd>CBccbox18<CR>', '[V]ertically enclosed' },
        h = { '<Cmd>CBccbox20<CR>', '[H]orizontally enclosed' },
      },
      r = {
        name = 'C[B]: [B]ox: [C]enter box: [R]ight text',
        f = { '<Cmd>CBcrbox1<CR>', '[F]ull' },
        p = { '<Cmd>CBcrbox8<CR>', '[P]added' },
        v = { '<Cmd>CBcrbox18<CR>', '[V]ertically enclosed' },
        h = { '<Cmd>CBcrbox20<CR>', '[H]orizontally enclosed' },
      },
    },
    r = {
      name = 'C[B]: [B]ox: [R]ight box',
      l = {
        name = 'C[B]: [B]ox: [R]ight box: [L]eft text',
        f = { '<Cmd>CBrlbox1<CR>', '[F]ull' },
        p = { '<Cmd>CBrlbox8<CR>', '[P]added' },
        v = { '<Cmd>CBrlbox18<CR>', '[V]ertically enclosed' },
        h = { '<Cmd>CBrlbox20<CR>', '[H]orizontally enclosed' },
      },
      c = {
        name = 'C[B]: [B]ox: [R]ight box: [C]enter text',
        f = { '<Cmd>CBrcbox1<CR>', '[F]ull' },
        p = { '<Cmd>CBrcbox8<CR>', '[P]added' },
        v = { '<Cmd>CBrcbox18<CR>', '[V]ertically enclosed' },
        h = { '<Cmd>CBrcbox20<CR>', '[H]orizontally enclosed' },
      },
      r = {
        name = 'C[B]: [B]ox: [R]ight box: [R]ight text',
        f = { '<Cmd>CBrrbox1<CR>', '[F]ull' },
        p = { '<Cmd>CBrrbox8<CR>', '[P]added' },
        v = { '<Cmd>CBrrbox18<CR>', '[V]ertically enclosed' },
        h = { '<Cmd>CBrrbox20<CR>', '[H]orizontally enclosed' },
      },
    },
  },
  l = {
    name = 'Comment [B]ox: [L]ine',
    l = {
      name = 'C[B]: [L]ine: [L]eft line',
      l = {
        name = 'C[B]: [L]ine: [L]eft line: [L]eft text',
        f = { '<Cmd>CBllline1<CR>', '[F]lat' },
        s = { '<Cmd>CBllline2<CR>', '[S]quare' },
        r = { '<Cmd>CBllline3<CR>', '[R]ound' },
        a = { '<Cmd>CBllline4<CR>', '[A]ngled' },
      },
      c = {
        name = 'C[B]: [L]ine: [L]eft line: [C]enter text',
        f = { '<Cmd>CBlcline1<CR>', '[F]lat' },
        s = { '<Cmd>CBlcline2<CR>', '[S]quare' },
        r = { '<Cmd>CBlcline3<CR>', '[R]ound' },
        a = { '<Cmd>CBlcline4<CR>', '[A]ngled' },
      },
      r = {
        name = 'C[B]: [L]ine: [L]eft line: [R]ight text',
        f = { '<Cmd>CBlrline1<CR>', '[F]lat' },
        s = { '<Cmd>CBlrline2<CR>', '[S]quare' },
        r = { '<Cmd>CBlrline3<CR>', '[R]ound' },
        a = { '<Cmd>CBlrline4<CR>', '[A]ngled' },
      },
    },
    c = {
      name = 'C[B]: [L]ine: [C]enter line',
      l = {
        name = 'C[B]: [L]ine: [C]enter line: [L]eft text',
        f = { '<Cmd>CBclline1<CR>', '[F]lat' },
        s = { '<Cmd>CBclline2<CR>', '[S]quare' },
        r = { '<Cmd>CBclline3<CR>', '[R]ound' },
        a = { '<Cmd>CBclline4<CR>', '[A]ngled' },
      },
      c = {
        name = 'C[B]: [L]ine: [C]enter line: [C]enter text',
        f = { '<Cmd>CBccline1<CR>', '[F]lat' },
        s = { '<Cmd>CBccline2<CR>', '[S]quare' },
        r = { '<Cmd>CBccline3<CR>', '[R]ound' },
        a = { '<Cmd>CBccline4<CR>', '[A]ngled' },
      },
      r = {
        name = 'C[B]: [L]ine: [C]enter line: [R]ight text',
        f = { '<Cmd>CBcrline1<CR>', '[F]lat' },
        s = { '<Cmd>CBcrline2<CR>', '[S]quare' },
        r = { '<Cmd>CBcrline3<CR>', '[R]ound' },
        a = { '<Cmd>CBcrline4<CR>', '[A]ngled' },
      },
    },
    r = {
      name = 'C[B]: [L]ine: [R]ight line',
      l = {
        name = 'C[B]: [L]ine: [R]ight line: [L]eft text',
        f = { '<Cmd>CBrlline1<CR>', '[F]lat' },
        s = { '<Cmd>CBrlline2<CR>', '[S]quare' },
        r = { '<Cmd>CBrlline3<CR>', '[R]ound' },
        a = { '<Cmd>CBrlline4<CR>', '[A]ngled' },
      },
      c = {
        name = 'C[B]: [L]ine: [R]ight line: [C]enter text',
        f = { '<Cmd>CBrcline1<CR>', '[F]lat' },
        s = { '<Cmd>CBrcline2<CR>', '[S]quare' },
        r = { '<Cmd>CBrcline3<CR>', '[R]ound' },
        a = { '<Cmd>CBrcline4<CR>', '[A]ngled' },
      },
      r = {
        name = 'C[B]: [L]ine: [R]ight line: [R]ight text',
        f = { '<Cmd>CBrrline1<CR>', '[F]lat' },
        s = { '<Cmd>CBrrline2<CR>', '[S]quare' },
        r = { '<Cmd>CBrrline3<CR>', '[R]ound' },
        a = { '<Cmd>CBrrline4<CR>', '[A]ngled' },
      },
    },
  },
  c = { '<Cmd>CBcatalog<CR>', 'Comment [B]ox: [C]atalog' },
  h = {
    name = 'Comment [B]ox: [H]orizontal rule',
    l = { '<Cmd>CBline<CR>', 'C[B]: [H]orizontal rule: [L]eft' },
    c = { '<Cmd>CBcline<CR>', 'C[B]: [H]orizontal rule: [C]enter' },
    r = { '<Cmd>CBrline<CR>', 'C[B]: [H]orizontal rule: [R]ight' },
  },
  r = { '<Cmd>CBd<CR>', 'Comment [B]ox: [R]emove' },
  y = { '<Cmd>CBy<CR>', 'Comment [B]ox: [Y]ank contents' },
}

require('which-key').register({
  ['<leader>b'] = commentBoxConfig,
})

--          ╭─────────────────────────────────────────────────────────╮
--          │                    Configure Trouble                    │
--          ╰─────────────────────────────────────────────────────────╯

local trouble = require('trouble')
vim.keymap.set('n', '<leader>xt', function() trouble.toggle() end, { desc = 'Trouble: [T]oggle' })
vim.keymap.set('n', '<leader>xo', function() trouble.open() end, { desc = 'Trouble: [O]pen' })
vim.keymap.set('n', '<leader>xc', function() trouble.close() end, { desc = 'Trouble: [C]lose' })
vim.keymap.set('n', '<leader>xn', function() trouble.next() end, { desc = 'Trouble: [N]ext' })
vim.keymap.set('n', '<leader>xp', function() trouble.previous() end, { desc = 'Trouble: [P]revious' })
vim.keymap.set('n', '<leader>xf', function() trouble.first() end, { desc = 'Trouble: [F]irst' })
vim.keymap.set('n', '<leader>xl', function() trouble.last() end, { desc = 'Trouble: [L]ast' })

--          ╭─────────────────────────────────────────────────────────╮
--          │                    Configure Harpoon                    │
--          ╰─────────────────────────────────────────────────────────╯

local harpoon = require('harpoon')
harpoon:setup()

vim.keymap.set('n', '<leader>da', function() harpoon:list():append() end, { desc = '[D]ocument [A]dd to harpoon' })
vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set('n', '<C-h>', function() harpoon:list():select(1) end)
vim.keymap.set('n', '<C-j>', function() harpoon:list():select(2) end)
vim.keymap.set('n', '<C-k>', function() harpoon:list():select(3) end)
vim.keymap.set('n', '<C-l>', function() harpoon:list():select(4) end)

--          ╭─────────────────────────────────────────────────────────╮
--          │                    Configure Comment                    │
--          ╰─────────────────────────────────────────────────────────╯

vim.keymap.set('n', '<C-_>', require('Comment.api').toggle.linewise.current)

require('stcursorword').setup()

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

--          ╭─────────────────────────────────────────────────────────╮
--          │                  Configure Treesitter                   │
--          ╰─────────────────────────────────────────────────────────╯

-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

--          ╭─────────────────────────────────────────────────────────╮
--          │                      Configure LSP                      │
--          ╰─────────────────────────────────────────────────────────╯

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>S'] = { name = '[S]ubstitute', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
  ['<leader>f'] = { name = '[F]ile Explorer', _ = 'which_key_ignore' },
  ['<leader>j'] = { name = '[J]ump to', _ = 'which_key_ignore' },
  ['<leader>x'] = { name = 'Trouble', _ = 'which_key_ignore' },
  ['<leader>b'] = { name = 'Comment [B]ox', _ = 'which_key_ignore' },
}
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').register({
  ['<leader>'] = { name = 'VISUAL <leader>' },
  ['<leader>h'] = { 'Git [H]unk' },
  ['<leader>b'] = commentBoxConfig,
}, { mode = 'v' })

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

--          ╭─────────────────────────────────────────────────────────╮
--          │                   Configure nvim-cmp                    │
--          ╰─────────────────────────────────────────────────────────╯

-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<C-;>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

-- local web_devicons_ok, web_devicons = pcall(require, 'nvim-web-devicons')
-- if not web_devicons_ok then
-- 	return
-- end
--
-- local material_icon_ok, material_icon = pcall(require, 'nvim-material-icon')
-- if not material_icon_ok then
-- 	return
-- end
--
-- web_devicons.setup({
-- 	override = material_icon.get_icons(),
-- })


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
