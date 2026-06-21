local function telescope_image_preview()
  local supported_images = { "png", "jpg", "jpeg", "webp", "gif", "avif" }
  local from_entry = require "telescope.from_entry"
  local Path = require "plenary.path"
  local conf = require("telescope.config").values
  local Previewers = require "telescope.previewers"
  local previewers = require "telescope.previewers"

  local is_image_preview = false
  local image = nil
  local last_file_path = ""

  local function is_supported_image(filepath)
    local split_path = vim.split(filepath:lower(), ".", { plain = true })
    local extension = split_path[#split_path]
    return vim.tbl_contains(supported_images, extension)
  end

  local function image_geometry(winid)
    local width = vim.api.nvim_win_get_width(winid)
    local height = vim.api.nvim_win_get_height(winid)
    local scale = 0.8
    return {
      x = math.max(1, math.floor(width * (1 - scale) / 2)),
      y = math.max(1, math.floor(height * (1 - scale) / 2)),
      width = math.max(1, math.floor(width * scale)),
      height = math.max(1, math.floor(height * scale)),
    }
  end

  local function delete_image()
    local ok, image_api = pcall(require, "image")
    if ok then
      image_api.clear()
    elseif image then
      image:clear()
    end
    image = nil
    is_image_preview = false
  end

  local function create_image(filepath, winid, bufnr)
    local ok, image_api = pcall(require, "image")
    if not ok then
      return
    end

    image_api.clear()

    vim.bo[bufnr].modifiable = true
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "" })
    vim.bo[bufnr].modifiable = false
    vim.bo[bufnr].buftype = "nowrite"
    vim.bo[bufnr].filetype = "image_nvim"
    pcall(vim.api.nvim_set_option_value, "cursorline", false, { win = winid })
    pcall(vim.api.nvim_set_option_value, "number", false, { win = winid })
    pcall(vim.api.nvim_set_option_value, "relativenumber", false, { win = winid })
    pcall(vim.api.nvim_set_option_value, "signcolumn", "no", { win = winid })

    image = image_api.from_file(
      filepath,
      vim.tbl_extend("force", image_geometry(winid), {
        window = winid,
        buffer = bufnr,
        max_width_window_percentage = 100,
        max_height_window_percentage = 100,
      })
    )
    if not image then
      return
    end

    local current = image
    vim.schedule(function()
      if image == current and last_file_path == filepath and vim.api.nvim_win_is_valid(winid) then
        image_api.clear()
        current:render(image_geometry(winid))
      end
    end)

    is_image_preview = true
  end

  local function defaulter(f, default_opts)
    default_opts = default_opts or {}
    return {
      new = function(opts)
        if conf.preview == false and not opts.preview then
          return false
        end
        opts.preview = type(opts.preview) ~= "table" and {} or opts.preview
        if type(conf.preview) == "table" then
          for k, v in pairs(conf.preview) do
            opts.preview[k] = vim.F.if_nil(opts.preview[k], v)
          end
        end
        return f(opts)
      end,
      __call = function()
        local ok, err = pcall(f(default_opts))
        if not ok then
          error(debug.traceback(err))
        end
      end,
    }
  end

  local file_previewer = defaulter(function(opts)
    opts = opts or {}
    local cwd = opts.cwd or vim.uv.cwd()
    return Previewers.new_buffer_previewer {
      title = "File Preview",
      dyn_title = function(_, entry)
        return Path:new(from_entry.path(entry, true)):normalize(cwd)
      end,
      get_buffer_by_name = function(_, entry)
        return from_entry.path(entry, true)
      end,
      define_preview = function(self, entry, _)
        local path = from_entry.path(entry, true)
        if path == nil or path == "" then
          return
        end

        conf.buffer_previewer_maker(path, self.state.bufnr, {
          bufname = self.state.bufname,
          winid = self.state.winid,
          preview = opts.preview,
        })
      end,
      teardown = function()
        if is_image_preview then
          delete_image()
        end
      end,
    }
  end, {})

  local function buffer_previewer_maker(filepath, bufnr, opts)
    if is_image_preview and last_file_path ~= filepath then
      delete_image()
    end

    last_file_path = filepath

    if is_supported_image(filepath) then
      if image and is_image_preview then
        local ok, image_api = pcall(require, "image")
        if ok then
          image_api.clear()
        end
        image:render(image_geometry(opts.winid))
        return
      end
      create_image(filepath, opts.winid, bufnr)
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end

  return {
    buffer_previewer_maker = buffer_previewer_maker,
    file_previewer = file_previewer.new,
  }
end

return telescope_image_preview()
