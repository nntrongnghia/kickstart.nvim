return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = 'VeryLazy',
    opts = {
      options = {
        mode = 'buffers',
        themable = true,
        numbers = 'none',
        close_command = 'bdelete! %d',
        right_mouse_command = 'bdelete! %d',
        left_mouse_command = 'buffer %d',
        middle_mouse_command = nil,
        indicator = {
          icon = '▎',
          style = 'icon',
        },
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 30,
        max_prefix_length = 30,
        tab_size = 21,
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match 'error' and ' ' or ' '
          return ' ' .. icon .. count
        end,
        custom_filter = function(buf_number, buf_numbers)
          if vim.bo[buf_number].filetype ~= 'qf' then
            return true
          end
        end,
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            text_align = 'left',
            separator = true,
          },
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            text_align = 'left',
            separator = true,
          },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = 'thin',
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' },
        },
        sort_by = 'insert_after_current',
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)

      -- Keymaps for buffer navigation (NvChad style)
      local map = vim.keymap.set

      -- Buffer navigation
      map('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
      map('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Previous buffer' })

      -- Buffer management
      map('n', '<leader>x', '<cmd>bdelete<cr>', { desc = 'Close buffer' })
      map('n', '<leader>X', '<cmd>BufferLineCloseOthers<cr>', { desc = 'Close other buffers' })

      -- Buffer picking
      map('n', '<leader>bp', '<cmd>BufferLinePick<cr>', { desc = 'Pick buffer' })
      map('n', '<leader>bc', '<cmd>BufferLinePickClose<cr>', { desc = 'Pick buffer to close' })

      -- Move buffers
      map('n', '<A-,>', '<cmd>BufferLineMovePrev<cr>', { desc = 'Move buffer left' })
      map('n', '<A-.>', '<cmd>BufferLineMoveNext<cr>', { desc = 'Move buffer right' })

      -- Go to buffer by number
      for i = 1, 9 do
        map('n', '<A-' .. i .. '>', '<cmd>BufferLineGoToBuffer ' .. i .. '<cr>', { desc = 'Go to buffer ' .. i })
      end

      -- Pin/unpin buffers
      map('n', '<leader>bP', '<cmd>BufferLineTogglePin<cr>', { desc = 'Pin/unpin buffer' })

      -- Sort buffers
      map('n', '<leader>be', '<cmd>BufferLineSortByExtension<cr>', { desc = 'Sort by extension' })
      map('n', '<leader>bd', '<cmd>BufferLineSortByDirectory<cr>', { desc = 'Sort by directory' })
    end,
  },

  -- Optional: Add a plugin to handle buffer deletion better (prevents layout issues)
  {
    'famiu/bufdelete.nvim',
    cmd = { 'Bdelete', 'Bwipeout' },
    keys = {
      { '<leader>bd', '<cmd>Bdelete<cr>', desc = 'Delete buffer (keep window)' },
    },
  },
}
