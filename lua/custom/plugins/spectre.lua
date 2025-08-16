-- lua/custom/plugins/spectre.lua

return {
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    -- Set up keymaps for Spectre
    vim.keymap.set('n', '<leader>S', '<cmd>Spectre<cr>', {
      desc = 'Open Spectre (Search & Replace)',
    })
    -- vim.keymap.set('n', '<leader>sw', '<cmd>SpectreWord<cr>', {
    --   desc = 'Search for current word under cursor',
    -- })
    -- vim.keymap.set('v', '<leader>s', '<cmd>SpectreV<cr>', {
    --   desc = 'Search for visually selected text',
    -- })
  end,
}
