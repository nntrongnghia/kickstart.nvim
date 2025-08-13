return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'github/copilot.vim' },
      { 'nvim-lua/plenary.nvim' },
    },
    opts = {
      debug = false, -- Enable debugging
      -- See Configuration section for more options
    },
    config = function(_, opts)
      local chat = require 'CopilotChat'
      chat.setup(opts)

      -- Custom mappings
      vim.keymap.set('n', '<M-c>', '<cmd>CopilotChatToggle<cr>', { desc = 'Toggle CopilotChat' })
      vim.keymap.set('n', '<leader>cc', '<cmd>CopilotChat<cr>', { desc = 'CopilotChat - Open chat' })
      vim.keymap.set('v', '<leader>cc', ':CopilotChat<cr>', { desc = 'CopilotChat - Open chat with selection' })

      vim.keymap.set('n', '<leader>ce', '<cmd>CopilotChatExplain<cr>', { desc = 'CopilotChat - Explain code' })
      vim.keymap.set('n', '<leader>ct', '<cmd>CopilotChatTests<cr>', { desc = 'CopilotChat - Generate tests' })
      vim.keymap.set('n', '<leader>cf', '<cmd>CopilotChatFixDiagnostic<cr>', { desc = 'CopilotChat - Fix diagnostic' })

      -- Inline chat
      vim.keymap.set('n', '<leader>ci', function()
        local input = vim.fn.input 'Ask Copilot: '
        if input ~= '' then
          chat.ask(input, { selection = require('CopilotChat.select').buffer })
        end
      end, { desc = 'CopilotChat - Ask a question (inline)' })
      vim.keymap.set('v', '<leader>ci', function()
        chat.ask(vim.fn.input 'Ask Copilot: ', { selection = require('CopilotChat.select').visual })
      end, { desc = 'CopilotChat - Ask a question with selection (inline)' })
      vim.g.copilot_no_tab_map = true
      vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
    end,
  },
}
