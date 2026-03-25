local overrides = require "configs.overrides"

return {
  {
    import = "nvchad.blink.lazyspec",
  },
  {
    "saghen/blink.pairs",
    version = "*",
    dependencies = "saghen/blink.download",
    event = "InsertEnter",
    opts = {
      mappings = {
        enabled = true,
        cmdline = true,
      },
      highlights = {
        enabled = true,
        cmdline = true,
        matchparen = {
          enabled = true,
        },
      },
    },
  },
  {
    "mikavilpas/yazi.nvim",
    version = "v10.0.2",
    event = "VeryLazy",
    opts = {
      keymaps = {
        show_help = "g?",
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
      preview_config = {
        border = "rounded",
      },
    },
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
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = require "configs.conform",
  },
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
          enabled = false,
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "Marskey/telescope-sg",
    },
    cmd = "Telescope",
    opts = overrides.telescope,
    config = function(_, opts)
      if vim.uv.fs_stat(vim.g.base46_cache .. "telescope") then
        dofile(vim.g.base46_cache .. "telescope")
      end
      local telescope = require "telescope"
      telescope.setup(opts)

      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },
}
