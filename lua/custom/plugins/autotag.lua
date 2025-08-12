return {
  {
    'windwp/nvim-ts-autotag',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'BufReadPre', 'BufNewFile' },
    ft = { 'html', 'xml', 'jsx', 'tsx', 'vue', 'svelte', 'php' }, -- chỉ load cho các file type cần thiết
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      }
    end,
  },
}
