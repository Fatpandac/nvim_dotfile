local overrides = require "custom.configs.overrides"

local plugins = {
  {
    "https://github.com/FelipeLema/cmp-async-path.git",
    name = "cmp-async-path",
  },
  {
    "mikavilpas/yazi.nvim",
    version = "v10.0.2",
    event = "VeryLazy",
    opts = {
      keymaps = {
        show_help = 'g?',
      },
    },
  },
  {
    "narutoxy/silicon.lua",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("silicon").setup {
        theme = "Visual Studio Dark+",
      }
    end,
  },
  {
    "VonHeikemen/fine-cmdline.nvim",
    event = "BufEnter",
    dependencies = {
      { "MunifTanjim/nui.nvim" },
    },
    config = function()
      require("fine-cmdline").setup {
        cmdline = {
          enable_keymaps = true,
          smart_history = true,
          prompt = ": ",
        },
      }
    end,
  },
  {
    "github/copilot.vim",
    event = "InsertEnter",
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "InsertEnter",
    opts = {
      current_line_blame = true,
    },
  },
  {
    "sontungexpt/url-open",
    event = "VeryLazy",
    cmd = "URLOpenUnderCursor",
    config = function()
      local status_ok, url_open = pcall(require, "url-open")
      if not status_ok then
        return
      end
      url_open.setup {
        deep_pattern = true,
      }
    end,
  },
  {
    "wakatime/vim-wakatime",
    event = "InsertEnter",
  },
  {
    "vim-scripts/BufOnly.vim",
    event = "InsertEnter",
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      -- format & linting
      {
        "nvimtools/none-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },
  -- override plugin configs
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, overrides.treesitter)
    end,
  },
  {
    "3rd/image.nvim",
    build = false,
    opts = {
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = false
        }
      }
    }
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
      },
      "Marskey/telescope-sg"
    },
    cmd = "Telescope",
    opts = overrides.telescope,
    config = function(_, opts)
      if vim.uv.fs_stat(vim.g.base46_cache .. "telescope") then
        dofile(vim.g.base46_cache .. "telescope")
      end
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      local cmp = require "cmp"
      local options = require "nvchad.configs.cmp"

      options.sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
      }

      options.mapping["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { "i", "s" })
      options.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" })

      return options
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },
}

return plugins
