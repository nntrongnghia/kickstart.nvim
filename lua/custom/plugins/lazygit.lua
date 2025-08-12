-- ===== STEP 1: INSTALL LAZYGIT CLI =====
--[[
First, install LazyGit on your system:

# macOS (Homebrew)
brew install lazygit

# Ubuntu/Debian
sudo apt install lazygit

# Arch Linux
sudo pacman -S lazygit

# Windows (Chocolatey)
choco install lazygit

# Windows (Scoop)
scoop install lazygit

# Or download from: https://github.com/jesseduffield/lazygit/releases
]]

-- ===== STEP 2: NEOVIM PLUGIN CONFIGURATION =====

-- Add this to your kickstart.nvim init.lua or custom/plugins/lazygit.lua
return {
  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },

    -- Lazy load on command and keymap
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },

    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
      { '<leader>gf', '<cmd>LazyGitCurrentFile<cr>', desc = 'LazyGit Current File' },
      { '<leader>gF', '<cmd>LazyGitFilterCurrentFile<cr>', desc = 'LazyGit Filter Current File' },
    },

    config = function()
      -- LazyGit configuration
      vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
      vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
      vim.g.lazygit_floating_window_corner_chars = { '╭', '╮', '╰', '╯' } -- customize corner chars
      vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
      vim.g.lazygit_use_neovim_remote = 1 -- for neovim-remote support
      vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is used if set

      -- Optional: Set custom config file path
      -- vim.g.lazygit_config_file_path = vim.fn.expand('~/.config/lazygit/config.yml')

      -- Create additional commands
      vim.api.nvim_create_user_command('LazyGitCurrentFile', function()
        vim.cmd 'LazyGitFilter'
      end, { desc = 'LazyGit for current file' })

      -- Function to open LazyGit in a specific directory
      vim.api.nvim_create_user_command('LazyGitDir', function()
        local dir = vim.fn.input('LazyGit directory: ', vim.fn.getcwd(), 'dir')
        if dir ~= '' then
          vim.cmd('cd ' .. dir)
          vim.cmd 'LazyGit'
        end
      end, { desc = 'LazyGit in specific directory' })
    end,
  },
}

--[[
===== LAZYGIT CONFIGURATION FILE =====

Create ~/.config/lazygit/config.yml for advanced LazyGit settings:

gui:
  # Scroll behavior
  scrollHeight: 2
  scrollPastBottom: true
  mouseEvents: true
  skipDiscardChangeWarning: false
  skipStashWarning: false
  showFileTree: true
  showListFooter: true
  showRandomTip: true
  showCommandLog: true
  showBottomLine: true
  showPanelJumps: true
  showBranchCommitHash: false
  sidePanelWidth: 0.3333
  expandFocusedSidePanel: false
  mainPanelSplitMode: flexible
  enlargedSideViewLocation: left
  language: auto
  timeFormat: 02 Jan 06 15:04 MST
  shortTimeFormat: 15:04
  theme:
    activeBorderColor:
      - white
      - bold
    inactiveBorderColor:
      - green
    optionsTextColor:
      - blue
    selectedLineBgColor:
      - blue
    selectedRangeBgColor:
      - blue
    cherryPickedCommitBgColor:
      - cyan
    cherryPickedCommitFgColor:
      - blue
    unstagedChangesColor:
      - red
    defaultFgColor:
      - default
  commitLength:
    show: true
  authorColors: {}
  branchColors: {}
  skipHookPrefix: WIP
  skipRewordInEditorWarning: false
  border: rounded

git:
  paging:
    colorArg: always
    pager: delta --dark --paging=never
  commit:
    signOff: false
  merging:
    manualCommit: false
    args: ''
  log:
    order: topo-order
    showGraph: when-maximised
    showWholeGraph: false
  skipHookPrefix: WIP
  autoFetch: true
  autoRefresh: true
  branchLogCmd: git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --
  allBranchesLogCmd: git log --graph --all --color=always --abbrev-commit --decorate --date=relative --pretty=medium
  overrideGpg: false
  disableForcePushing: false
  parseEmoji: false
  diffContextSize: 3

update:
  method: prompt
  days: 14

refresher:
  refreshInterval: 10
  fetchInterval: 60

confirmOnQuit: false

quitOnTopLevelReturn: false

disableStartupPopups: false

notARepository: prompt

promptToReturnFromSubprocess: true

keybinding:
  universal:
    quit: q
    quit-alt1: <c-c>
    return: <esc>
    quitWithoutChangingDirectory: Q
    togglePanel: <tab>
    prevItem: <up>
    nextItem: <down>
    prevItem-alt: k
    nextItem-alt: j
    prevPage: ','
    nextPage: .
    gotoTop: <
    gotoBottom: '>'
    scrollLeft: H
    scrollRight: L
    prevBlock: '<left>'
    nextBlock: '<right>'
    prevBlock-alt: h
    nextBlock-alt: l
    jumpToBlock:
      - "1"
      - "2"
      - "3"
      - "4"
      - "5"
    nextMatch: "n"
    prevMatch: "N"
    optionMenu: x
    optionMenu-alt1: '?'
    select: <space>
    goInto: <enter>
    openRecentRepos: <c-r>
    confirm: <enter>
    confirm-alt1: 'y'
    remove: d
    new: "n"
    edit: e
    openFile: o
    scrollUpMain: <pgup>
    scrollDownMain: <pgdown>
    scrollUpMain-alt1: K
    scrollDownMain-alt1: J
    scrollUpMain-alt2: <c-u>
    scrollDownMain-alt2: <c-d>
    executeCustomCommand: ':'
    createRebaseOptionsMenu: m
    pushFiles: P
    pullFiles: p
    refresh: R
    createPatchOptionsMenu: <c-p>
    nextTab: ']'
    prevTab: '['
    nextScreenMode: +
    prevScreenMode: _
    undo: z
    redo: <c-z>
    filteringMenu: <c-s>
    diffingMenu: W
    diffingMenu-alt: <c-e>
    copyToClipboard: <c-o>
    submitEditorText: <enter>
    extrasMenu: '@'
    toggleWhitespaceInDiffView: <c-w>
  status:
    checkForUpdate: u
    recentRepos: <enter>
  files:
    commitChanges: c
    commitChangesWithoutHook: w
    amendLastCommit: A
    commitChangesWithEditor: C
    ignoreFile: i
    refreshFiles: r
    stashAllChanges: s
    viewStashOptions: S
    toggleStagedAll: a
    viewResetOptions: D
    fetch: f
    toggleTreeView: '`'
    openMergeTool: M
    openStatusFilter: <c-b>
  branches:
    createPullRequest: o
    viewPullRequestOptions: O
    checkoutBranchByName: c
    forceCheckoutBranch: F
    rebaseBranch: r
    renameBranch: R
    mergeIntoCurrentBranch: M
    viewGitFlowOptions: i
    fastForward: f
    createTag: T
    pushTag: P
    setUpstream: u
    fetchRemote: f
  commits:
    squashDown: s
    renameCommit: r
    renameCommitWithEditor: R
    viewResetOptions: g
    markCommitAsFixup: f
    createFixupCommit: F
    squashAboveCommits: S
    moveDownCommit: <c-j>
    moveUpCommit: <c-k>
    amendToCommit: A
    pickCommit: p
    revertCommit: t
    cherryPickCopy: c
    cherryPickCopyRange: C
    pasteCommits: v
    tagCommit: T
    checkoutCommit: <space>
    resetCherryPick: <c-R>
    copyCommitMessageToClipboard: <c-y>
    openLogMenu: <c-l>
    viewBisectOptions: b
  stash:
    popStash: g
    renameStash: r
  commitFiles:
    checkoutCommitFile: c
  main:
    toggleDragSelect: v
    toggleDragSelect-alt: V
    toggleSelectHunk: a
    pickBothHunks: b
  submodules:
    init: i
    update: u
    bulkMenu: b
]]

--[[
===== USAGE GUIDE =====

## BASIC WORKFLOW

1. **Open LazyGit**: Press <leader>gg or :LazyGit
2. **Navigate**: Use hjkl or arrow keys
3. **Stage files**: Press <space> to stage/unstage files
4. **Commit**: Press 'c' to commit staged changes
5. **Push**: Press 'P' to push commits
6. **Pull**: Press 'p' to pull changes

## MAIN PANELS

- **Files Panel**: Shows working directory changes
- **Branches Panel**: Shows local and remote branches  
- **Commits Panel**: Shows commit history
- **Stash Panel**: Shows stashed changes

## ESSENTIAL KEYBINDINGS

### Navigation
- Tab: Switch between panels
- hjkl: Navigate within panels
- Enter: Go into selected item
- Esc: Go back/exit

### File Operations
- Space: Stage/unstage file
- a: Stage/unstage all files
- c: Commit staged files
- A: Amend last commit
- d: Discard changes

### Branch Operations
- c: Checkout branch
- n: Create new branch
- M: Merge branch
- r: Rebase branch
- d: Delete branch

### Commit Operations
- Enter: View commit details
- s: Squash commit
- r: Rename commit
- d: Drop commit
- p: Pick commit (during rebase)

## ADVANCED FEATURES

### Interactive Rebase
1. Navigate to commits panel
2. Select base commit
3. Press 'r' for rebase
4. Use s/r/d to squash/rename/drop commits

### Branch Management
1. Navigate to branches panel
2. Press 'n' to create new branch
3. Press 'c' to checkout branch
4. Press 'M' to merge into current branch

### Stash Management
1. Navigate to stash panel
2. Press 's' in files panel to stash changes
3. Press 'g' to pop stash
4. Press 'd' to drop stash

### File History
1. Select file in files panel
2. Press Enter to see file changes
3. Navigate through hunks with hjkl
4. Stage individual hunks with Space

## INTEGRATION WITH NEOVIM

### File Editing
- LazyGit can open files in your Neovim instance
- Uses neovim-remote if available
- Changes are reflected immediately

### Buffer Refresh
- Buffers auto-refresh when LazyGit closes
- Gitsigns integration updates automatically
- No manual refresh needed

### Custom Commands
- :LazyGit - Open LazyGit
- :LazyGitCurrentFile - LazyGit filtered to current file
- :LazyGitDir - LazyGit in specific directory
- :LazyGitConfig - Open LazyGit config

## TIPS & TRICKS

### 1. Quick Staging
- Use 'a' to stage all files quickly
- Use Space on individual files for selective staging

### 2. Commit Messages
- Use 'c' for quick commit
- Use 'C' to open commit in editor for longer messages

### 3. Branch Switching
- Type '/' in branches panel to filter branches
- Use 'c' for quick checkout

### 4. Conflict Resolution
- LazyGit shows merge conflicts clearly
- Navigate to conflicted files
- Use external merge tool or edit manually

### 5. History Exploration
- Use commits panel to explore history
- Press Enter on commits to see changes
- Use '/' to search commits

### 6. Remote Operations
- Press 'f' to fetch from remote
- Press 'p' to pull changes
- Press 'P' to push commits
- Navigate to remote branches for upstream operations

### 7. Stash Workflow
- Stash changes before switching branches
- Use descriptive stash names
- Pop stashes when ready to continue work

## TROUBLESHOOTING

### LazyGit not opening
- Check if lazygit is installed: `lazygit --version`
- Check Neovim config for plugin loading
- Try :LazyGit command manually

### Files not refreshing
- Check if gitsigns is installed and configured
- Restart Neovim if buffers seem out of sync
- Use :checktime to manually refresh buffers

### Floating window issues
- Adjust scaling factor in config
- Try different terminal emulators
- Check transparency settings
]]
