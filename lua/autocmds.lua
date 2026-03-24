require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd
local create_cmd = vim.api.nvim_create_user_command

autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

autocmd({ "BufEnter", "WinEnter" }, {
  pattern = "*",
  command = "set statusline=%{repeat('',winwidth('.'))}",
})

local function configured_lsp_names(names)
  local result = {}
  local seen = {}

  for _, name in ipairs(names) do
    if vim.lsp.config[name] ~= nil and not seen[name] then
      seen[name] = true
      table.insert(result, name)
    end
  end

  return result
end

local function active_configured_lsp_names()
  local names = {}

  for _, client in ipairs(vim.lsp.get_clients()) do
    table.insert(names, client.name)
  end

  return configured_lsp_names(names)
end

create_cmd("LspRestart", function(info)
  local client_names = #info.fargs > 0 and configured_lsp_names(info.fargs) or active_configured_lsp_names()

  for _, name in ipairs(client_names) do
    vim.lsp.enable(name, false)
    if info.bang then
      for _, client in ipairs(vim.lsp.get_clients { name = name }) do
        client:stop(true)
      end
    end
  end

  local timer = assert(vim.uv.new_timer())
  timer:start(500, 0, function()
    timer:stop()
    timer:close()
    vim.schedule(function()
      for _, name in ipairs(client_names) do
        vim.lsp.enable(name)
      end
    end)
  end)
end, {
  desc = "Restart configured language servers",
  nargs = "*",
  bang = true,
})

create_cmd("LspStop", function(info)
  local client_names = #info.fargs > 0 and configured_lsp_names(info.fargs) or active_configured_lsp_names()

  for _, name in ipairs(client_names) do
    vim.lsp.enable(name, false)
    if info.bang then
      for _, client in ipairs(vim.lsp.get_clients { name = name }) do
        client:stop(true)
      end
    end
  end
end, {
  desc = "Stop configured language servers",
  nargs = "*",
  bang = true,
})
