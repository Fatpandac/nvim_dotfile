local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "pyright", "rust_analyzer", "eslint", "jsonls", "unocss" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.ts_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = os.getenv("HOME") .. "/.local/share/fnm/aliases/default/lib/node_modules/@vue/language-server",
        languages = { 'vue' },
      },
    },
  },
  filetypes = {
    "javascript",
    "typescript",
    "typescriptreact",
    "javascriptreact",
    "vue",
  },
}

lspconfig.volar.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    typescript = {
      tsdk = "/opt/homebrew/lib/node_modules/typescript/lib",
    },
  },
  flags = { debounce_text_changes = 150 },
}

lspconfig.eslint.setup {}
