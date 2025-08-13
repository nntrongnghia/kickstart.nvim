-- Clean configuration for navic + navbuddy with winbar only
-- Does not interfere with lualine configuration

return {
  -- nvim-navic for breadcrumbs in winbar
  {
    'SmiteshP/nvim-navic',
    dependencies = 'neovim/nvim-lspconfig',
    config = function()
      local navic = require 'nvim-navic'

      navic.setup {
        icons = {
          File = '󰈙 ',
          Module = ' ',
          Namespace = '󰌗 ',
          Package = ' ',
          Class = '󰌗 ',
          Method = '󰆧 ',
          Property = ' ',
          Field = ' ',
          Constructor = ' ',
          Enum = '󰕘 ',
          Interface = '󰕘 ',
          Function = '󰊕 ',
          Variable = '󰆧 ',
          Constant = '󰏿 ',
          String = '󰀬 ',
          Number = '󰎠 ',
          Boolean = '◩ ',
          Array = '󰅪 ',
          Object = '󰅩 ',
          Key = '󰌋 ',
          Null = '󰟢 ',
          EnumMember = ' ',
          Struct = '󰌗 ',
          Event = ' ',
          Operator = '󰆕 ',
          TypeParameter = '󰊄 ',
        },
        lsp = {
          auto_attach = true,
          preference = nil,
        },
        highlight = true,
        separator = ' > ',
        depth_limit = 0,
        depth_limit_indicator = '..',
        safe_output = true,
        lazy_update_context = false,
        click = false,
      }

      -- Set up winbar with file path + navic breadcrumbs
      local function get_winbar()
        local modified = vim.bo.modified and ' ●' or ''
        local navic_location = ''

        if navic.is_available() then
          navic_location = navic.get_location()
        end

        -- Only show breadcrumbs if available, with modified indicator
        if navic_location ~= '' then
          return string.format(' %s%s', modified, navic_location)
        else
          return modified ~= '' and ' ' .. modified or nil
        end
      end

      -- Create autocommand to update winbar
      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorMoved', 'CursorMovedI' }, {
        callback = function()
          if vim.bo.filetype ~= '' and vim.bo.buftype == '' then
            vim.wo.winbar = get_winbar()
          else
            vim.wo.winbar = nil
          end
        end,
      })
    end,
  },

  -- nvim-navbuddy for interactive symbol navigation
  {
    'SmiteshP/nvim-navbuddy',
    dependencies = {
      'SmiteshP/nvim-navic',
      'MunifTanjim/nui.nvim',
    },
    keys = {
      { '<leader>nv', '<cmd>Navbuddy<cr>', desc = 'Open Navbuddy' },
    },
    config = function()
      local navbuddy = require 'nvim-navbuddy'
      local actions = require 'nvim-navbuddy.actions'

      navbuddy.setup {
        window = {
          border = 'single',
          size = '60%',
          position = '50%',
          scrolloff = nil,
          sections = {
            left = {
              size = '20%',
              border = nil,
            },
            mid = {
              size = '40%',
              border = nil,
            },
            right = {
              size = '10%',
              border = nil,
            },
          },
        },
        node_markers = {
          enabled = true,
          icons = {
            leaf = '  ',
            leaf_selected = ' → ',
            branch = ' ',
          },
        },
        icons = {
          File = '󰈙 ',
          Module = ' ',
          Namespace = '󰌗 ',
          Package = ' ',
          Class = '󰌗 ',
          Method = '󰆧 ',
          Property = ' ',
          Field = ' ',
          Constructor = ' ',
          Enum = '󰕘',
          Interface = '󰕘',
          Function = '󰊕 ',
          Variable = '󰆧 ',
          Constant = '󰏿 ',
          String = '󰀬 ',
          Number = '󰎠 ',
          Boolean = '◩ ',
          Array = '󰅪 ',
          Object = '󰅩 ',
          Key = '󰌋 ',
          Null = '󰟢 ',
          EnumMember = ' ',
          Struct = '󰌗 ',
          Event = ' ',
          Operator = '󰆕 ',
          TypeParameter = '󰊄 ',
        },
        use_default_mappings = true,
        mappings = {
          ['<esc>'] = actions.close(),
          ['q'] = actions.close(),
          ['j'] = actions.next_sibling(),
          ['k'] = actions.previous_sibling(),
          ['h'] = actions.parent(),
          ['l'] = actions.children(),
          ['0'] = actions.root(),
          ['v'] = actions.visual_name(),
          ['V'] = actions.visual_scope(),
          ['y'] = actions.yank_name(),
          ['Y'] = actions.yank_scope(),
          ['i'] = actions.insert_name(),
          ['I'] = actions.insert_scope(),
          ['a'] = actions.append_name(),
          ['A'] = actions.append_scope(),
          ['r'] = actions.rename(),
          ['d'] = actions.delete(),
          ['f'] = actions.fold_create(),
          ['F'] = actions.fold_delete(),
          ['c'] = actions.comment(),
          ['<enter>'] = actions.select(),
          ['o'] = actions.select(),
          ['J'] = actions.move_down(),
          ['K'] = actions.move_up(),
          ['s'] = actions.toggle_preview(),
          ['<C-v>'] = actions.vsplit(),
          ['<C-s>'] = actions.hsplit(),
          ['t'] = actions.telescope {
            layout_config = {
              height = 0.60,
              width = 0.60,
              prompt_position = 'top',
              preview_width = 0.50,
            },
            layout_strategy = 'horizontal',
          },
          ['g?'] = actions.help(),
        },
        lsp = {
          auto_attach = true,
          preference = nil,
        },
        source_buffer = {
          follow_node = true,
          highlight = true,
          reorient = 'smart',
          scrolloff = nil,
        },
        custom_hl_group = 'Visual',
      }
    end,
  },
}
