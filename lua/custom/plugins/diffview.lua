-- DiffView Plugin Configuration for Kickstart.nvim
-- Add this to your init.lua plugins section or create a separate file

return {
  -- DiffView - Advanced Git diff viewer
  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },

    -- Lazy load on commands and keymaps
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
      'DiffviewRefresh',
      'DiffviewFileHistory',
    },

    keys = {
      -- Main DiffView commands
      { '<leader>dvo', '<cmd>DiffviewOpen<cr>', desc = 'DiffView: Open' },
      { '<leader>dvc', '<cmd>DiffviewClose<cr>', desc = 'DiffView: Close' },
      { '<leader>dvt', '<cmd>DiffviewToggleFiles<cr>', desc = 'DiffView: Toggle Files Panel' },
      { '<leader>dvf', '<cmd>DiffviewFocusFiles<cr>', desc = 'DiffView: Focus Files Panel' },
      { '<leader>dvr', '<cmd>DiffviewRefresh<cr>', desc = 'DiffView: Refresh' },

      -- File History
      { '<leader>dvh', '<cmd>DiffviewFileHistory<cr>', desc = 'DiffView: File History (All)' },
      { '<leader>dvH', '<cmd>DiffviewFileHistory %<cr>', desc = 'DiffView: Current File History' },

      -- Branch comparisons
      { '<leader>dvm', '<cmd>DiffviewOpen main<cr>', desc = 'DiffView: Compare with main' },
      { '<leader>dvM', '<cmd>DiffviewOpen origin/main<cr>', desc = 'DiffView: Compare with origin/main' },
      { '<leader>dvd', '<cmd>DiffviewOpen HEAD~1<cr>', desc = 'DiffView: Compare with HEAD~1' },

      -- Visual mode - file history for selection
      { '<leader>dvh', ":'<,'>DiffviewFileHistory<cr>", mode = 'v', desc = 'DiffView: File History (Range)' },
    },

    config = function()
      require('diffview').setup {
        -- Diff binaries
        diff_binaries = false,

        -- Enhanced diff highlighting
        enhanced_diff_hl = false,

        -- Git command configuration
        git_cmd = { 'git' },

        -- Use icons (requires nvim-web-devicons)
        use_icons = true,

        -- Show help hints
        show_help_hints = true,

        -- Watch index for changes
        watch_index = true,

        -- Icons configuration
        icons = {
          folder_closed = '󰉋',
          folder_open = '󰝰',
        },

        -- Signs configuration
        signs = {
          fold_closed = '󰅂',
          fold_open = '󰅀',
          done = '󰄬',
        },

        -- View configuration
        view = {
          -- Configure the layout and behavior of different types of views.
          default = {
            -- Config for changed files, and staged files in diff views.
            layout = 'diff2_horizontal',
            winbar_info = false, -- See ':h diffview-config-view.x.winbar_info'
          },
          merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            layout = 'diff3_horizontal',
            disable_diagnostics = true, -- Temporarily disable diagnostics in a conflicted file
            winbar_info = true,
          },
          file_history = {
            -- Config for changed files in file history views.
            layout = 'diff2_horizontal',
            winbar_info = false,
          },
        },

        -- File panel configuration
        file_panel = {
          listing_style = 'tree', -- One of 'list' or 'tree'
          tree_options = { -- Only applies when listing_style is 'tree'
            flatten_dirs = true, -- Flatten dirs that only contain one single dir
            folder_statuses = 'only_folded', -- One of 'never', 'only_folded' or 'always'.
          },
          win_config = { -- See ':h diffview-config-win_config'
            position = 'left',
            width = 35,
            win_opts = {},
          },
        },

        -- File history panel configuration
        file_history_panel = {
          log_options = { -- See ':h diffview-config-log_options'
            git = {
              single_file = {
                follow = false, -- Follow renames (only for single file)
                all = false, -- Include all refs under 'refs/' including HEAD
                merges = false, -- List only merge commits
                no_merges = false, -- List no merge commits
                reverse = false, -- List commits in reverse order
              },
              multi_file = {
                follow = false, -- Follow renames (only for single file)
                all = false, -- Include all refs under 'refs/' including HEAD
                merges = false, -- List only merge commits
                no_merges = false, -- List no merge commits
                reverse = false, -- List commits in reverse order
              },
            },
          },
          win_config = { -- See ':h diffview-config-win_config'
            position = 'bottom',
            height = 16,
            win_opts = {},
          },
        },

        -- Commit log panel configuration
        commit_log_panel = {
          win_config = { -- See ':h diffview-config-win_config'
            win_opts = {},
          },
        },

        -- Default arguments
        default_args = {
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },

        -- Key mappings inside DiffView
        keymaps = {
          disable_defaults = false, -- Disable the default keymaps
          view = {
            -- The `view` bindings are active in the diff buffers, only when the current
            -- tabpage is a Diffview.
            {
              'n',
              '<tab>',
              require('diffview.actions').select_next_entry,
              { desc = 'Open the diff for the next file' },
            },
            {
              'n',
              '<s-tab>',
              require('diffview.actions').select_prev_entry,
              { desc = 'Open the diff for the previous file' },
            },
            {
              'n',
              'gf',
              require('diffview.actions').goto_file_edit,
              { desc = 'Open the file in the previous tabpage' },
            },
            {
              'n',
              '<C-w><C-f>',
              require('diffview.actions').goto_file_split,
              { desc = 'Open the file in a new split' },
            },
            {
              'n',
              '<C-w>gf',
              require('diffview.actions').goto_file_tab,
              { desc = 'Open the file in a new tabpage' },
            },
            {
              'n',
              '<leader>e',
              require('diffview.actions').focus_files,
              { desc = 'Bring focus to the file panel' },
            },
            {
              'n',
              '<leader>b',
              require('diffview.actions').toggle_files,
              { desc = 'Toggle the file panel.' },
            },
            {
              'n',
              'g<C-x>',
              require('diffview.actions').cycle_layout,
              { desc = 'Cycle through available layouts.' },
            },
            {
              'n',
              '[x',
              require('diffview.actions').prev_conflict,
              { desc = 'In the merge-tool: jump to the previous conflict' },
            },
            {
              'n',
              ']x',
              require('diffview.actions').next_conflict,
              { desc = 'In the merge-tool: jump to the next conflict' },
            },
          },
          file_panel = {
            {
              'n',
              'j',
              require('diffview.actions').next_entry,
              { desc = 'Bring the cursor to the next file entry' },
            },
            {
              'n',
              '<down>',
              require('diffview.actions').next_entry,
              { desc = 'Bring the cursor to the next file entry' },
            },
            {
              'n',
              'k',
              require('diffview.actions').prev_entry,
              { desc = 'Bring the cursor to the previous file entry.' },
            },
            {
              'n',
              '<up>',
              require('diffview.actions').prev_entry,
              { desc = 'Bring the cursor to the previous file entry.' },
            },
            {
              'n',
              '<cr>',
              require('diffview.actions').select_entry,
              { desc = 'Open the diff for the selected entry.' },
            },
            {
              'n',
              'o',
              require('diffview.actions').select_entry,
              { desc = 'Open the diff for the selected entry.' },
            },
            {
              'n',
              'l',
              require('diffview.actions').select_entry,
              { desc = 'Open the diff for the selected entry.' },
            },
            {
              'n',
              '<2-LeftMouse>',
              require('diffview.actions').select_entry,
              { desc = 'Open the diff for the selected entry.' },
            },
            {
              'n',
              '-',
              require('diffview.actions').toggle_stage_entry,
              { desc = 'Stage / unstage the selected entry.' },
            },
            {
              'n',
              'S',
              require('diffview.actions').stage_all,
              { desc = 'Stage all entries.' },
            },
            {
              'n',
              'U',
              require('diffview.actions').unstage_all,
              { desc = 'Unstage all entries.' },
            },
            {
              'n',
              'X',
              require('diffview.actions').restore_entry,
              { desc = 'Restore entry to the state on the left side.' },
            },
            {
              'n',
              'L',
              require('diffview.actions').open_commit_log,
              { desc = 'Open the commit log panel.' },
            },
            {
              'n',
              'zo',
              require('diffview.actions').open_fold,
              { desc = 'Expand fold' },
            },
            {
              'n',
              'h',
              require('diffview.actions').close_fold,
              { desc = 'Collapse fold' },
            },
            {
              'n',
              'zc',
              require('diffview.actions').close_fold,
              { desc = 'Collapse fold' },
            },
            {
              'n',
              'za',
              require('diffview.actions').toggle_fold,
              { desc = 'Toggle fold' },
            },
            {
              'n',
              'zR',
              require('diffview.actions').open_all_folds,
              { desc = 'Expand all folds' },
            },
            {
              'n',
              'zM',
              require('diffview.actions').close_all_folds,
              { desc = 'Collapse all folds' },
            },
            {
              'n',
              '<c-b>',
              require('diffview.actions').scroll_view(-0.25),
              { desc = 'Scroll the view up' },
            },
            {
              'n',
              '<c-f>',
              require('diffview.actions').scroll_view(0.25),
              { desc = 'Scroll the view down' },
            },
            {
              'n',
              '<tab>',
              require('diffview.actions').select_next_entry,
              { desc = 'Open the diff for the next file' },
            },
            {
              'n',
              '<s-tab>',
              require('diffview.actions').select_prev_entry,
              { desc = 'Open the diff for the previous file' },
            },
            {
              'n',
              'gf',
              require('diffview.actions').goto_file_edit,
              { desc = 'Open the file in the previous tabpage' },
            },
            {
              'n',
              '<C-w><C-f>',
              require('diffview.actions').goto_file_split,
              { desc = 'Open the file in a new split' },
            },
            {
              'n',
              '<C-w>gf',
              require('diffview.actions').goto_file_tab,
              { desc = 'Open the file in a new tabpage' },
            },
            {
              'n',
              'i',
              require('diffview.actions').listing_style,
              { desc = 'Toggle between list and tree views' },
            },
            {
              'n',
              'f',
              require('diffview.actions').toggle_flatten_dirs,
              { desc = 'Flatten empty subdirectories in tree listing style.' },
            },
            {
              'n',
              'R',
              require('diffview.actions').refresh_files,
              { desc = 'Update stats and entries in the file list.' },
            },
            {
              'n',
              '<leader>e',
              require('diffview.actions').focus_files,
              { desc = 'Bring focus to the file panel' },
            },
            {
              'n',
              '<leader>b',
              require('diffview.actions').toggle_files,
              { desc = 'Toggle the file panel' },
            },
            {
              'n',
              'g<C-x>',
              require('diffview.actions').cycle_layout,
              { desc = 'Cycle available layouts' },
            },
            {
              'n',
              '[x',
              require('diffview.actions').prev_conflict,
              { desc = 'Go to the previous conflict' },
            },
            {
              'n',
              ']x',
              require('diffview.actions').next_conflict,
              { desc = 'Go to the next conflict' },
            },
          },
          file_history_panel = {
            {
              'n',
              'g!',
              require('diffview.actions').options,
              { desc = 'Open the option panel' },
            },
            {
              'n',
              '<C-A-d>',
              require('diffview.actions').open_in_diffview,
              { desc = 'Open the entry under the cursor in a diffview' },
            },
            {
              'n',
              'y',
              require('diffview.actions').copy_hash,
              { desc = 'Copy the commit hash of the entry under the cursor' },
            },
            {
              'n',
              'L',
              require('diffview.actions').open_commit_log,
              { desc = 'Show commit details' },
            },
            {
              'n',
              'zR',
              require('diffview.actions').open_all_folds,
              { desc = 'Expand all folds' },
            },
            {
              'n',
              'zM',
              require('diffview.actions').close_all_folds,
              { desc = 'Collapse all folds' },
            },
            {
              'n',
              'j',
              require('diffview.actions').next_entry,
              { desc = 'Bring the cursor to the next file entry' },
            },
            {
              'n',
              '<down>',
              require('diffview.actions').next_entry,
              { desc = 'Bring the cursor to the next file entry' },
            },
            {
              'n',
              'k',
              require('diffview.actions').prev_entry,
              { desc = 'Bring the cursor to the previous file entry.' },
            },
            {
              'n',
              '<up>',
              require('diffview.actions').prev_entry,
              { desc = 'Bring the cursor to the previous file entry.' },
            },
            {
              'n',
              '<cr>',
              require('diffview.actions').select_entry,
              { desc = 'Open the diff for the selected entry.' },
            },
            {
              'n',
              'o',
              require('diffview.actions').select_entry,
              { desc = 'Open the diff for the selected entry.' },
            },
            {
              'n',
              '<2-LeftMouse>',
              require('diffview.actions').select_entry,
              { desc = 'Open the diff for the selected entry.' },
            },
            {
              'n',
              '<c-b>',
              require('diffview.actions').scroll_view(-0.25),
              { desc = 'Scroll the view up' },
            },
            {
              'n',
              '<c-f>',
              require('diffview.actions').scroll_view(0.25),
              { desc = 'Scroll the view down' },
            },
            {
              'n',
              '<tab>',
              require('diffview.actions').select_next_entry,
              { desc = 'Open the diff for the next file' },
            },
            {
              'n',
              '<s-tab>',
              require('diffview.actions').select_prev_entry,
              { desc = 'Open the diff for the previous file' },
            },
            {
              'n',
              'gf',
              require('diffview.actions').goto_file_edit,
              { desc = 'Open the file in the previous tabpage' },
            },
            {
              'n',
              '<C-w><C-f>',
              require('diffview.actions').goto_file_split,
              { desc = 'Open the file in a new split' },
            },
            {
              'n',
              '<C-w>gf',
              require('diffview.actions').goto_file_tab,
              { desc = 'Open the file in a new tabpage' },
            },
            {
              'n',
              '<leader>e',
              require('diffview.actions').focus_files,
              { desc = 'Bring focus to the file panel' },
            },
            {
              'n',
              '<leader>b',
              require('diffview.actions').toggle_files,
              { desc = 'Toggle the file panel.' },
            },
            {
              'n',
              'g<C-x>',
              require('diffview.actions').cycle_layout,
              { desc = 'Cycle available layouts.' },
            },
          },
          option_panel = {
            {
              'n',
              '<tab>',
              require('diffview.actions').select_entry,
              { desc = 'Change the current option' },
            },
            {
              'n',
              'q',
              require('diffview.actions').close,
              { desc = 'Close the panel' },
            },
            {
              'n',
              '<esc>',
              require('diffview.actions').close,
              { desc = 'Close the panel' },
            },
          },
          help_panel = {
            {
              'n',
              'q',
              require('diffview.actions').close,
              { desc = 'Close help menu' },
            },
            {
              'n',
              '<esc>',
              require('diffview.actions').close,
              { desc = 'Close help menu' },
            },
          },
        },
      }

      -- Create additional user commands
      vim.api.nvim_create_user_command('DiffviewCompare', function(opts)
        local branch = opts.args ~= '' and opts.args or 'main'
        vim.cmd('DiffviewOpen ' .. branch)
      end, {
        nargs = '?',
        complete = function()
          -- Simple git branch completion
          local handle = io.popen 'git branch --format="%(refname:short)" 2>/dev/null'
          if handle then
            local branches = {}
            for line in handle:lines() do
              table.insert(branches, line)
            end
            handle:close()
            return branches
          end
          return { 'main', 'master', 'develop' }
        end,
        desc = 'Compare with branch (default: main)',
      })

      -- Convenient command for comparing with origin
      vim.api.nvim_create_user_command('DiffviewOrigin', function(opts)
        local branch = opts.args ~= '' and opts.args or 'main'
        vim.cmd('DiffviewOpen origin/' .. branch)
      end, {
        nargs = '?',
        desc = 'Compare with origin branch (default: origin/main)',
      })
    end,
  },
}
