return {
  'karb94/neoscroll.nvim',
  opts = {
    easing_function = 'quadratic',
  },
  config = function()
    neoscroll = require 'neoscroll'
    local keymap = {
      ['<Up>'] = function()
        neoscroll.ctrl_u { duration = 250 }
      end,
      ['<Down>'] = function()
        neoscroll.ctrl_d { duration = 250 }
      end,
    }
    local modes = { 'n', 'v', 'x' }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end,
}
