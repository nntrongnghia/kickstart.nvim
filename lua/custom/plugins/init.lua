-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'akinsho/toggleterm.nvim',
    version = '*', -- or a specific tag
    config = function()
      require('toggleterm').setup {
        size = 15,
        open_mapping = [[<C-\>]], -- Default mapping, can be removed if using custom keymaps
        shade_terminals = true,
        direction = 'horizontal', -- 'vertical' | 'horizontal' | 'tab' | 'float'
      }

      -- Keymaps
      vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = 'Toggle Terminal' })
      vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
      vim.keymap.set('n', '<leader>th', function()
        require('toggleterm').toggle(1, 15, vim.o.columns, 'horizontal')
      end, { desc = 'Horizontal Terminal' })

      vim.keymap.set('n', '<leader>tv', function()
        require('toggleterm').toggle(2, vim.o.lines, 40, 'vertical')
      end, { desc = 'Vertical Terminal' })

      vim.keymap.set('n', '<leader>tf', function()
        require('toggleterm').toggle(3, 15, 40, 'float')
      end, { desc = 'Floating Terminal' })
    end,
  },
}
