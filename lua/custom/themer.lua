-- lua/custom/themer.lua (Sidebar Version)
local M = {}

-- The path where we will save the currently selected theme
local theme_cache_path = vim.fn.stdpath 'data' .. '/theme.lua'

--- Saves the selected theme name to the cache file.
--- @param theme string The name of the theme to save
local function save_theme(theme)
  local content = "return { theme = '" .. theme .. "' }"
  local file, err = io.open(theme_cache_path, 'w')
  if not file then
    print('Error saving theme:', err)
    return
  end
  file:write(content)
  file:close()
end

--- Creates a sidebar theme picker using a split window
function M.picker()
  local themes = vim.fn.getcompletion('', 'color')
  local original_theme = vim.g.colors_name or 'default'

  -- Save current window
  local original_win = vim.api.nvim_get_current_win()

  -- Create a vertical split on the left (30% width)
  vim.cmd 'topleft 30vnew'
  local picker_buf = vim.api.nvim_get_current_buf()
  local picker_win = vim.api.nvim_get_current_win()

  -- Set buffer options
  vim.api.nvim_buf_set_option(picker_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(picker_buf, 'swapfile', false)
  vim.api.nvim_buf_set_option(picker_buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(picker_buf, 'modifiable', true)

  -- Set window options
  vim.api.nvim_win_set_option(picker_win, 'number', true)
  vim.api.nvim_win_set_option(picker_win, 'relativenumber', false)
  vim.api.nvim_win_set_option(picker_win, 'cursorline', true)
  vim.api.nvim_win_set_option(picker_win, 'wrap', false)

  -- Set buffer name
  vim.api.nvim_buf_set_name(picker_buf, 'Theme Picker')

  -- Add header
  local lines = { '# Theme Picker', '# Use j/k to navigate, Enter to select, q to quit', '' }

  -- Add themes to the list
  for _, theme in ipairs(themes) do
    table.insert(lines, theme)
  end

  vim.api.nvim_buf_set_lines(picker_buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(picker_buf, 'modifiable', false)

  -- Set cursor to first theme (line 4, after header)
  vim.api.nvim_win_set_cursor(picker_win, { 4, 0 })

  -- Function to get current theme under cursor
  local function get_current_theme()
    local line_num = vim.api.nvim_win_get_cursor(picker_win)[1]
    if line_num > 3 then -- Skip header lines
      local line = vim.api.nvim_buf_get_lines(picker_buf, line_num - 1, line_num, false)[1]
      return line and line:match '%S+' -- Get first word (theme name)
    end
    return nil
  end

  -- Function to preview theme
  local function preview_theme()
    local theme = get_current_theme()
    if theme then
      pcall(vim.cmd.colorscheme, theme)
    end
  end

  -- Track if theme was selected (to avoid restoring on close)
  local theme_selected = false

  -- Function to select and save theme
  local function select_theme()
    local theme = get_current_theme()
    if theme then
      theme_selected = true -- Mark that theme was intentionally selected
      vim.cmd('colorscheme ' .. theme)
      save_theme(theme)
      vim.api.nvim_win_close(picker_win, true)
      -- Return focus to original window
      pcall(vim.api.nvim_set_current_win, original_win)
      print('Theme applied:', theme)
    end
  end

  -- Function to close and restore original theme
  local function close_picker()
    if not theme_selected then -- Only restore if theme wasn't intentionally selected
      pcall(vim.cmd.colorscheme, original_theme)
    end
    vim.api.nvim_win_close(picker_win, true)
    -- Return focus to original window
    pcall(vim.api.nvim_set_current_win, original_win)
  end

  -- Set up keymaps for the picker buffer
  local opts = { buffer = picker_buf, silent = true }

  -- Navigation with preview
  vim.keymap.set('n', 'j', function()
    local current_line = vim.api.nvim_win_get_cursor(picker_win)[1]
    local last_line = vim.api.nvim_buf_line_count(picker_buf)
    if current_line < last_line then
      vim.api.nvim_win_set_cursor(picker_win, { current_line + 1, 0 })
      preview_theme()
    end
  end, opts)

  vim.keymap.set('n', 'k', function()
    local current_line = vim.api.nvim_win_get_cursor(picker_win)[1]
    if current_line > 4 then -- Don't go above first theme
      vim.api.nvim_win_set_cursor(picker_win, { current_line - 1, 0 })
      preview_theme()
    end
  end, opts)

  -- Arrow keys
  vim.keymap.set('n', '<Down>', function()
    local current_line = vim.api.nvim_win_get_cursor(picker_win)[1]
    local last_line = vim.api.nvim_buf_line_count(picker_buf)
    if current_line < last_line then
      vim.api.nvim_win_set_cursor(picker_win, { current_line + 1, 0 })
      preview_theme()
    end
  end, opts)

  vim.keymap.set('n', '<Up>', function()
    local current_line = vim.api.nvim_win_get_cursor(picker_win)[1]
    if current_line > 4 then
      vim.api.nvim_win_set_cursor(picker_win, { current_line - 1, 0 })
      preview_theme()
    end
  end, opts)

  -- Selection
  vim.keymap.set('n', '<CR>', select_theme, opts)
  vim.keymap.set('n', '<Space>', select_theme, opts)

  -- Close picker
  vim.keymap.set('n', 'q', close_picker, opts)
  vim.keymap.set('n', '<Esc>', close_picker, opts)

  -- Auto-close when leaving the window
  vim.api.nvim_create_autocmd('WinLeave', {
    buffer = picker_buf,
    once = true,
    callback = close_picker,
  })

  -- Preview the initially selected theme
  preview_theme()
end

--- Loads the saved theme from the cache file on startup.
function M.load_theme()
  -- Check if the cache file exists first
  if vim.fn.filereadable(theme_cache_path) == 0 then
    -- File doesn't exist, apply default theme
    pcall(vim.cmd.colorscheme, 'tokyonight')
    return
  end

  -- pcall (protected call) safely executes the code
  local ok, theme_config = pcall(function()
    return dofile(theme_cache_path)
  end)

  -- Set your default theme here as a fallback
  local theme_to_load = 'tokyonight'

  if ok and theme_config and theme_config.theme then
    theme_to_load = theme_config.theme
    print('Loading saved theme:', theme_to_load) -- Debug message
  else
    print('Failed to load theme config, using default:', theme_to_load) -- Debug message
  end

  -- Try to apply the theme
  local theme_ok = pcall(vim.cmd.colorscheme, theme_to_load)
  if not theme_ok then
    print('Failed to apply theme:', theme_to_load, '- falling back to default')
    pcall(vim.cmd.colorscheme, 'tokyonight')
  end
end

return M
