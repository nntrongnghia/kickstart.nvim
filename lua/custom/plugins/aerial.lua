-- Add this to your kickstart.nvim init.lua file
-- This provides a symbol outline sidebar

return {
  'stevearc/aerial.nvim',
  opts = {},
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('aerial').setup {
      -- Priority list of preferred backends for aerial.
      backends = { 'treesitter', 'lsp', 'markdown', 'asciidoc', 'man' },

      layout = {
        -- These control the width of the aerial window.
        max_width = { 40, 0.2 },
        width = nil,
        min_width = 10,

        -- Key-value pairs of window-local options for aerial window (e.g. winhl)
        win_opts = {},

        -- Determines the default direction to open the aerial window. Can be 'prefer_right'
        -- or 'prefer_left'
        default_direction = 'prefer_right',

        -- Determines where the aerial window will be opened
        --   edge   - open aerial at the far right/left of the editor
        --   window - open aerial to the right/left of the current window
        placement = 'window',
      },

      -- Determines how the aerial window decides which buffer to display symbols for
      --   window - aerial window will display symbols for the buffer in the window from which it was opened
      --   global - aerial window will display symbols for the current active buffer
      attach_mode = 'window',

      -- List of enum values that configure when to auto-close the aerial window
      --   unfocus       - close aerial when you leave the original source window
      --   switch_buffer - close aerial when you change buffers in the source window
      --   unsupported   - close aerial when attaching to a buffer that has no symbol source
      close_automatic_events = {},

      -- Keymaps in aerial window
      keymaps = {
        ['?'] = 'actions.show_help',
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.jump',
        ['<2-LeftMouse>'] = 'actions.jump',
        ['<C-v>'] = 'actions.jump_vsplit',
        ['<C-s>'] = 'actions.jump_split',
        ['p'] = 'actions.scroll',
        ['<C-j>'] = 'actions.down_and_scroll',
        ['<C-k>'] = 'actions.up_and_scroll',
        ['{'] = 'actions.prev',
        ['}'] = 'actions.next',
        ['[['] = 'actions.prev_up',
        [']]'] = 'actions.next_up',
        ['q'] = 'actions.close',
        ['o'] = 'actions.tree_toggle',
        ['za'] = 'actions.tree_toggle',
        ['O'] = 'actions.tree_toggle_recursive',
        ['zA'] = 'actions.tree_toggle_recursive',
        ['l'] = 'actions.tree_open',
        ['zo'] = 'actions.tree_open',
        ['L'] = 'actions.tree_open_recursive',
        ['zO'] = 'actions.tree_open_recursive',
        ['h'] = 'actions.tree_close',
        ['zc'] = 'actions.tree_close',
        ['H'] = 'actions.tree_close_recursive',
        ['zC'] = 'actions.tree_close_recursive',
        ['zr'] = 'actions.tree_increase_fold_level',
        ['zR'] = 'actions.tree_open_all',
        ['zm'] = 'actions.tree_decrease_fold_level',
        ['zM'] = 'actions.tree_close_all',
        ['zx'] = 'actions.tree_sync_folds',
        ['zX'] = 'actions.tree_sync_folds',
      },

      -- When true, don't load aerial until a command is run or function is called
      lazy_load = true,

      -- Disable aerial on files with this many lines
      disable_max_lines = 10000,

      -- Disable aerial on files this size or larger (in bytes)
      disable_max_size = 2000000, -- Default 2MB

      -- A list of all symbols to display. Set to false to display all symbols.
      filter_kind = {
        'Class',
        'Constructor',
        'Enum',
        'Function',
        'Interface',
        'Module',
        'Method',
        'Struct',
        'Variable',
        'Constant',
        'Property',
        'Field',
      },
    }

    -- Set keymaps for aerial
    vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>', { desc = 'Toggle Aerial (Symbol Outline)' })
    vim.keymap.set('n', '<leader>A', '<cmd>AerialNavToggle<CR>', { desc = 'Toggle Aerial Navigation' })

    -- Optional: Set up autocommands to automatically open aerial for certain filetypes
    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = { "python", "lua", "javascript", "typescript", "rust", "go" },
    --   callback = function()
    --     vim.cmd("AerialOpen")
    --   end,
    -- })
  end,
}
