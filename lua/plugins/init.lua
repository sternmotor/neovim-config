--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/init.lua
-- Description: init plugins config

-- Built-in plugins
local builtin_plugins = {
  { "nvim-lua/plenary.nvim" },
  -- File explore
  -- nvim-tree.lua - A file explorer tree for neovim written in lua
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      opt = true
    },
    opts = function()
      require("plugins.configs.tree")
    end,
  },
  -- Formatter
  -- Lightweight yet powerful formatter plugin for Neovim
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { lua = { "stylua" } },
    },
  },
  -- Git integration for buffers
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    opts = function()
      require("plugins.configs.gitsigns")
    end,
  },
  -- Treesitter interface
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,     -- last release is way too old and doesn't work on Windows
    evevent = { "BufReadPost", "BufNewFile", "BufWritePost" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      require("plugins.configs.treesitter")
    end,
  },
  -- Telescope
  -- Find, Filter, Preview, Pick. All lua, all the time.
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
      }
    },
    cmd = "Telescope",
    config = function(_)
      require("telescope").setup()
      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require("telescope").load_extension("fzf")
      require("plugins.configs.telescope")
    end
  },
  -- Statusline
  -- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      -- require("plugins.configs.lualine-maxmx03")
      require("plugins.configs.lualine-slanted")
      -- require("plugins.configs.lualine")
    end
  },
  -- colorscheme
  {
    'maxmx03/solarized.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    ---@type solarized.config
    config = function(_, opts)
      -- vim.g.solarized_italic_comments = true
      -- vim.g.solarized_italic_keywords = true
      -- vim.g.solarized_italic_functions = true
      -- vim.g.solarized_italic_variables = false
      -- vim.g.solarized_contrast = true
      -- vim.g.solarized_borders = false
      -- vim.g.solarized_disable_background = false
      vim.o.termguicolors = true
      vim.o.background = 'light'
      require('solarized').setup(opts)
      vim.cmd.colorscheme 'solarized'
    end,
  },
  -- bufferline like https://github.com/maxmx03/solarized.nvim/blob/main/README.md
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    -- keys = {
    --   { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
    --   { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    -- },
    config = function()
      require("plugins.configs.bufferline")
    end,
  },

  -- LSP stuffs
  -- Portable package manager for Neovim that runs everywhere Neovim runs.
  -- Easily install and manage LSP servers, DAP servers, linters, and formatters.

  -- Debian install
  -- sudo apt-get install python3-venv
  -- export NVM_DIR="$HOME/.nvm"
  -- [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  -- nvm install node
  --
  -- sudo ln -s /home/g.mann/.nvm/versions/node/v23.8.0/bin/npm /usr/local/bin/npm
  -- sudo ln -s /home/g.mann/.nvm/versions/node/v23.8.0/bin/node /usr/local/bin/
  --
  -- :MasonInstall lua-language-server
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    config = function()
      require("plugins.configs.mason")
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup {
        automatic_installation = true,
        ensure_installed = {
          "ansiblels",
          "bashls",
          "docker_compose_language_service",
          "dockerls",
          "gopls",
          "jedi_language_server",
          "jinja_lsp",
          "jsonls",
          "markdown_oxide",
          "nginx_language_server",
          "shellcheck",
          "stylua",
          "snyk",
          "texlab",
          "textlsp",
          "yamlls",
        },
      }
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvimtools/none-ls-extras.nvim" },
    lazy = false,
    config = function()
      require("plugins.configs.null-ls")
    end
  },
  {
    "neovim/nvim-lspconfig",
    event = "VimEnter",
    config = function()
      require("plugins.configs.lspconfig")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require("plugins.configs.luasnip")
        end,
      },

      -- autopairing of (){}[] etc
      { "windwp/nvim-autopairs" },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "onsails/lspkind.nvim",
      },
    },
    opts = function()
      require("plugins.configs.cmp")
    end,
  },
  -- Colorizer
  {
    "norcalli/nvim-colorizer.lua",
    config = function(_)
      require("colorizer").setup()

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end
  },
  -- Keymappings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },
}


local exist, custom = pcall(require, "custom")
local custom_plugins = exist and type(custom) == "table" and custom.plugins or {}

-- Check if there is any custom plugins
-- local ok, custom_plugins = pcall(require, "plugins.custom")
require("lazy").setup({
  spec = { builtin_plugins, custom_plugins },
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",   -- lockfile generated after running update.
  defaults = {
    lazy = false,                                             -- should plugins be lazy-loaded?
    version = nil
    -- version = "*", -- enable this to try installing the latest stable versions of plugins
  },
  ui = {
    icons = {
      ft = "",
      lazy = "󰂠",
      loaded = "",
      not_loaded = ""
    }
  },
  install = {
    -- install missing plugins on startup
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "solarized" }
  },
  checker = {
    -- automatically check for plugin updates
    enabled = true,
    -- get a notification when new updates are found
    -- disable it as it's too annoying
    notify = false,
    -- check for updates every day
    frequency = 86400
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    -- get a notification when changes are found
    -- disable it as it's too annoying
    notify = false
  },
  performance = {
    cache = {
      enabled = true
    }
  },
  state = vim.fn.stdpath("state") .. "/lazy/state.json"   -- state info for checker and other things
})
