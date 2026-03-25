require("nvchad.configs.lspconfig").defaults()

local map = vim.keymap.set
local hover_handler = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
  max_width = math.floor(vim.o.columns * 0.6),
  max_height = math.floor(vim.o.lines * 0.5),
})
local signature_handler = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
  max_width = math.floor(vim.o.columns * 0.6),
  max_height = math.floor(vim.o.lines * 0.4),
})

local function ts_root_dir(bufnr, on_dir)
  local root = vim.fs.root(bufnr, { "tsconfig.json", "jsconfig.json", "package.json", ".git" })
  on_dir(root)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }

    map("n", "K", function()
      vim.lsp.buf.hover { border = "rounded", max_width = math.floor(vim.o.columns * 0.6) }
    end, opts)
    map("n", "gi", vim.lsp.buf.implementation, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "<leader>ls", function()
      vim.lsp.buf.signature_help { border = "rounded", max_width = math.floor(vim.o.columns * 0.6) }
    end, opts)
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    map("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    map("n", "<leader>lf", function()
      vim.diagnostic.open_float { border = "rounded" }
    end, opts)
    map("n", "[d", function()
      vim.diagnostic.jump { count = -1, float = true }
    end, opts)
    map("n", "]d", function()
      vim.diagnostic.jump { count = 1, float = true }
    end, opts)
    map("n", "gd", vim.lsp.buf.definition, opts)
  end,
})

vim.lsp.handlers["textDocument/hover"] = hover_handler
vim.lsp.handlers["textDocument/signatureHelp"] = signature_handler

vim.diagnostic.config {
  virtual_text = {
    source = "if_many",
    format = function(diagnostic)
      if diagnostic.source then
        return string.format("[%s] %s", diagnostic.source, diagnostic.message)
      end

      return diagnostic.message
    end,
  },
  float = {
    source = true,
    border = "rounded",
  },
}

local servers = {
  "html", "cssls", "pyright", "rust_analyzer",
  "eslint", "jsonls", "unocss", "gopls", "tailwindcss",
}

for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end

vim.lsp.config("ts_go", {
  cmd = {
    "tsgo",
    "--lsp",
    "--stdio",
  },
  root_dir = ts_root_dir,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
})

vim.lsp.enable "ts_go"

vim.lsp.config("volar", {
  init_options = {
    typescript = {
      tsdk = "/opt/homebrew/lib/node_modules/typescript/lib",
    },
  },
})
vim.lsp.enable "volar"

vim.lsp.config("cssmodules_ls", {
  filetypes = {
    "javascript",
    "typescript",
    "typescriptreact",
    "javascriptreact",
    "vue",
  },
  init_options = {
    camelCase = true,
  },
})
vim.lsp.enable "cssmodules_ls"
