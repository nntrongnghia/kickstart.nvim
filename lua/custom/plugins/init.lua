-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    config = true,
  },
}
