local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "ts_ls", "pyright", "rust_analyzer", "eslint" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local inlayHintsConfig = {
  includeInlayEnumMemberValueHints = true,
  includeInlayFunctionLikeReturnTypeHints = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayParameterNameHints = "literals", -- 'none' | 'literals' | 'all';
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayVariableTypeHints = false,
}

lspconfig.ts_ls.setup {
  settings = {
    javascript = {
      inlayHints = inlayHintsConfig,
    },
    typescript = {
      inlayHints = inlayHintsConfig,
    },
  },
}

lspconfig.volar.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    vue = {
      hybridMode = false,
    },
    typescript = {
      tsdk = "/opt/homebrew/lib/node_modules/typescript/lib",
    },
  },
  flags = { debounce_text_changes = 150 },
  settings = {
    volar = { autoCompleteRefs = true },
  },
}

lspconfig.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    tailwindCSS = {
      lint = {
        cssConflict = "ignore",
      },
    },
  },
}

lspconfig.eslint.setup {}
