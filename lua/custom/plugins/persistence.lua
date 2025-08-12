return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {
      -- Session directory - sessions will be saved per project
      dir = vim.fn.expand(vim.fn.stdpath 'data' .. '/sessions/'),

      -- Session options to save
      options = {
        'buffers',
        'curdir',
        'tabpages',
        'winsize',
        'help',
        'globals',
        'skiprtp',
        'folds',
      },

      -- Enable pre-save hook to clean up before saving
      pre_save = function()
        -- Close any floating windows, help windows, etc. before saving
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local config = vim.api.nvim_win_get_config(win)
          if config.relative ~= '' then
            vim.api.nvim_win_close(win, false)
          end
        end
      end,

      -- Save current session when exiting Neovim
      save_empty = false, -- don't save if there are no open file buffers
    },

    -- Set up keymaps for session management
    config = function(_, opts)
      require('persistence').setup(opts)

      -- Keymaps for session management
      local map = vim.keymap.set

      -- Restore the session for the current directory
      map('n', '<leader>qs', function()
        require('persistence').load()
      end, { desc = 'Restore session for current directory' })

      -- Restore the last session
      map('n', '<leader>ql', function()
        require('persistence').load { last = true }
      end, { desc = 'Restore last session' })

      -- Stop persistence (don't save current session on exit)
      map('n', '<leader>qd', function()
        require('persistence').stop()
      end, { desc = "Don't save current session" })

      -- Select a session to load
      map('n', '<leader>qS', function()
        require('persistence').select()
      end, { desc = 'Select session to restore' })
    end,
  },
}
