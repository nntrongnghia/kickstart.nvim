return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      local toggleterm = require 'toggleterm'

      toggleterm.setup {
        size = 15,
        shade_terminals = true,
        direction = 'float', -- NVChad uses floating terminals by default
        open_mapping = nil, -- optional, we’ll also set explicit keymaps
        persist_size = true,
        persist_mode = true,
        float_opts = {
          border = 'rounded',
        },
      }

      -- Helper function to create independent terminal toggles
      local function create_terminal_toggle(id, direction, size_fn, desc)
        return function()
          local toggleterm_module = require 'toggleterm'
          local Terminal = require('toggleterm.terminal').Terminal
          -- Close all other terminals first
          for i = 1, 3 do
            if i ~= id then
              local terminals = require('toggleterm.terminal').get_all()
              for _, term in pairs(terminals) do
                if term.id == i and term:is_open() then
                  term:close()
                end
              end
            end
          end
          -- toggle the requested terminal
          local size = size_fn and size_fn() or nil
          toggleterm_module.toggle(id, size, nil, direction)
        end
      end

      -- ===== Terminal 1: Floating terminal (NVChad style) =====
      local toggle_float = create_terminal_toggle(1, 'float', nil, 'floating')
      vim.keymap.set('n', '<A-i>', function()
        toggle_float()
        vim.schedule(function()
          vim.cmd 'startinsert'
        end)
      end, { desc = 'Toggle floating terminal' })
      vim.keymap.set('t', '<A-i>', function()
        vim.cmd 'stopinsert'
        toggle_float()
      end, { desc = 'Toggle floating terminal' })

      -- ===== Terminal 2: Horizontal terminal =====
      local toggle_horizontal = create_terminal_toggle(2, 'horizontal', function()
        return 15
      end, 'horizontal')
      vim.keymap.set('n', '<A-h>', function()
        toggle_horizontal()
        vim.schedule(function()
          vim.cmd 'startinsert'
        end)
      end, { desc = 'Toggle horizontal terminal' })
      vim.keymap.set('t', '<A-h>', function()
        vim.cmd 'stopinsert'
        toggle_horizontal()
      end, { desc = 'Toggle horizontal terminal' })

      -- ===== Terminal 3: Vertical terminal =====
      local toggle_vertical = create_terminal_toggle(3, 'vertical', function()
        return 40
      end, 'vertical')
      vim.keymap.set('n', '<A-v>', function()
        toggle_vertical()
        vim.schedule(function()
          vim.cmd 'startinsert'
        end)
      end, { desc = 'Toggle vertical terminal' })
      vim.keymap.set('t', '<A-v>', function()
        vim.cmd 'stopinsert'
        toggle_vertical()
      end, { desc = 'Toggle vertical terminal' })
    end,
  },
}
