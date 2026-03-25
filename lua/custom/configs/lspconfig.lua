local util = require "lspconfig.util"
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

local function get_tsdk(root_dir)
  local local_ts = root_dir and util.path.join(root_dir, "node_modules", "typescript", "lib")
  if local_ts and vim.uv.fs_stat(local_ts) then
    return local_ts
  end

  return "/opt/homebrew/lib/node_modules/typescript/lib"
end

local function ts_root_dir(bufnr, on_dir)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname:match("/node_modules/") then
    return
  end

  local root = vim.fs.root(bufnr, { "tsconfig.json", "jsconfig.json", "package.json", ".git" })
  on_dir(root)
end

local function open_mf_type_definition()
  local bufnr = vim.api.nvim_get_current_buf()
  local root = vim.fs.root(bufnr, { "tsconfig.json", "jsconfig.json", "package.json", ".git" })
  if not root then
    return false
  end

  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  for start_col, mod in line:gmatch("()import%('([^']+)'%)") do
    local mod_start = start_col + #"import('"
    local mod_end = mod_start + #mod - 1

    if col >= mod_start and col <= mod_end then
      local candidates = {
        util.path.join(root, "node_modules", "@mf-types", mod .. ".d.ts"),
        util.path.join(root, "node_modules", "@mf-types", mod, "index.d.ts"),
        util.path.join(root, "node_modules", mod .. ".d.ts"),
        util.path.join(root, "node_modules", mod, "index.d.ts"),
      }

      for _, candidate in ipairs(candidates) do
        if vim.uv.fs_stat(candidate) then
          vim.cmd.edit(vim.fn.fnameescape(candidate))
          return true
        end
      end
    end
  end

  return false
end

local function jump_to_first_location(methods)
  local bufnr = vim.api.nvim_get_current_buf()
  local params = vim.lsp.util.make_position_params(0, "utf-8")

  for _, method in ipairs(methods) do
    local clients = vim.lsp.get_clients { bufnr = bufnr, method = method }

    if #clients > 0 then
      local responses = vim.lsp.buf_request_sync(bufnr, method, params, 1000)

      for client_id, response in pairs(responses or {}) do
        local result = response and response.result

        if result and not vim.tbl_isempty(result) then
          local client = vim.lsp.get_client_by_id(client_id)
          vim.lsp.util.show_document(
            vim.islist(result) and result[1] or result,
            client and client.offset_encoding or "utf-8",
            { reuse_win = true, focus = true }
          )
          return true
        end
      end
    end
  end

  return false
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }
    local ft = vim.bo[args.buf].filetype
    local is_ts_like = ft == "javascript"
      or ft == "javascriptreact"
      or ft == "typescript"
      or ft == "typescriptreact"

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

    if is_ts_like then
      map("n", "gd", function()
        if not jump_to_first_location {
          "textDocument/definition",
          "textDocument/declaration",
          "textDocument/typeDefinition",
        } and not open_mf_type_definition() then
          vim.notify("No locations found", vim.log.levels.WARN)
        end
      end, opts)
    end
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

-- if you just want default config for the servers then put them in a table
local servers = {
  "html", "cssls", "pyright", "rust_analyzer",
  "eslint", "jsonls", "unocss", "gopls", "tailwindcss"
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

vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  root_dir = ts_root_dir,
  single_file_support = false,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  init_options = {
    hostInfo = "neovim",
  },
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options = new_config.init_options or {}
    new_config.init_options.typescript = {
      tsdk = get_tsdk(new_root_dir),
    }
  end,
})
vim.lsp.enable "ts_ls"

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
