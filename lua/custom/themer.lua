-- lua/custom/themer.lua (Fixed version)
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

--- The main function to create and open the theme picker.
function M.picker()
  local themes = vim.fn.getcompletion('', 'color')
  local original_theme = vim.g.colors_name or 'default'

  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Theme Picker',
      finder = require('telescope.finders').new_table {
        results = themes,
      },
      sorter = require('telescope.config').values.generic_sorter(),

      -- REMOVED on_select - this was causing the issue
      -- on_select is not the right callback for Enter key

      attach_mappings = function(prompt_bufnr, map)
        local actions = require 'telescope.actions'
        local state = require 'telescope.actions.state'

        -- This is our safe preview function
        local function preview_theme()
          local selection = state.get_selected_entry()
          if selection then
            pcall(vim.cmd.colorscheme, selection.value)
          end
        end

        -- We define a combined action: move the selection, then preview.
        local function move_and_preview(move_action)
          move_action(prompt_bufnr)
          preview_theme()
        end

        -- FIXED: Override the default Enter action
        local function select_theme()
          local selection = state.get_selected_entry()
          if selection then
            -- Apply and save the theme
            vim.cmd('colorscheme ' .. selection.value)
            save_theme(selection.value)
            -- Close the picker
            actions.close(prompt_bufnr)
          end
        end

        -- Map Enter key to our custom select function
        map('i', '<CR>', select_theme)
        map('n', '<CR>', select_theme)

        -- Map movement keys for live preview
        map('i', '<Down>', function()
          move_and_preview(actions.move_selection_next)
        end)
        map('i', '<Up>', function()
          move_and_preview(actions.move_selection_previous)
        end)
        map('i', '<C-j>', function()
          move_and_preview(actions.move_selection_next)
        end)
        map('i', '<C-k>', function()
          move_and_preview(actions.move_selection_previous)
        end)

        -- Override the default close action to restore original theme
        local function close_and_restore()
          pcall(vim.cmd.colorscheme, original_theme)
          actions.close(prompt_bufnr)
        end

        map('i', '<Esc>', close_and_restore)
        map('n', 'q', close_and_restore)
        map('i', '<C-c>', close_and_restore)

        return true
      end,
    })
    :find()
end

--- Loads the saved theme from the cache file on startup.
function M.load_theme()
  -- pcall (protected call) safely executes the code
  local ok, theme_config = pcall(function()
    return dofile(theme_cache_path)
  end)

  -- Set your default theme here as a fallback
  local theme_to_load = 'tokyonight'

  if ok and theme_config and theme_config.theme then
    theme_to_load = theme_config.theme
  end

  pcall(vim.cmd.colorscheme, theme_to_load)
end

return M
