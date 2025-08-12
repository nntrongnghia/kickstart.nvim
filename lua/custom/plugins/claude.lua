-- Simple claudecode.nvim configuration without key mapping conflicts
local toggle_key = '<M-o>'
return {
  -- Required dependency
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {},
  },

  -- Simple claudecode setup
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },

    keys = {
      { toggle_key, '<cmd>ClaudeCodeFocus<cr>', desc = 'Claude Code', mode = { 'n', 'x' } },
      { toggle_key, '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude Code', mode = { 't' } },
    },

    opts = {
      -- Terminal configuration for floating window
      terminal = {
        provider = 'snacks',
        snacks_win_opts = {
          position = 'float',
          width = 0.85, -- 85% of screen width
          height = 0.85, -- 85% of screen height
          border = 'rounded',
          backdrop = 50, -- Dim background
          -- NO custom keys to avoid conflicts
          -- Use default snacks.nvim terminal keybindings
        },
      },
    },
  },
}
