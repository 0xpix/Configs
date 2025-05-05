------------------------------------------
-- Global Configuration
------------------------------------------
-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- For conciseness
local opts = { noremap = true, silent = true } -- Options for keymaps

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

------------------------------------------
-- Navigation
------------------------------------------
-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Buffer navigation
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)

-- Allow moving the cursor through wrapped lines with j, k
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv') -- Keep search results centered
vim.keymap.set('n', 'N', 'Nzzzv')

------------------------------------------
-- File Operations
------------------------------------------
-- Save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- Quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

------------------------------------------
-- Editing
------------------------------------------
-- Delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Increment/decrement numbers
vim.keymap.set('n', '<leader>+', '<C-a>', opts)
vim.keymap.set('n', '<leader>-', '<C-x>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Move text up and down
vim.keymap.set('v', '<A-j>', ':m .+1<CR>==', opts)
vim.keymap.set('v', '<A-k>', ':m .-2<CR>==', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts) -- Paste over without losing current paste buffer

-- Replace word under cursor
vim.keymap.set('n', '<leader>j', '*``cgn', opts) -- Replace word under cursor

-- Explicitly yank to system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

------------------------------------------
-- Window and Buffer Management
------------------------------------------
-- Buffer operations
vim.keymap.set('n', '<leader>x', ':Bdelete!<CR>', opts) -- Close buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- New buffer

-- Window splitting
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- Split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- Split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- Make all split windows equal width and height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- Close current split window

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts) -- Resize window up
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts) -- Resize window down
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts) -- Resize window left
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts) -- Resize window right
-- NOTE: Disabled keymaps (kept for reference)
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- Open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- Close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) -- Next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) -- Previous tab

------------------------------------------
-- UI and Display
------------------------------------------
-- Clear highlights on search
vim.keymap.set('n', '<Esc>', ':noh<CR>', opts)

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

------------------------------------------
-- Diagnostics
------------------------------------------
-- Toggle diagnostics
local diagnostics_active = true
vim.keymap.set('n', '<leader>do', function()
  diagnostics_active = not diagnostics_active

  if diagnostics_active then
    vim.diagnostic.enable(0)
  else
    vim.diagnostic.disable(0)
  end
end, { desc = 'Toggle diagnostics' })

-- Navigate diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

------------------------------------------
-- Terminal
------------------------------------------
-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

------------------------------------------
-- Insert Mode
------------------------------------------
-- Exit insert mode quickly
vim.keymap.set('i', 'jk', '<ESC>', opts)
vim.keymap.set('i', 'kj', '<ESC>', opts)

------------------------------------------
-- Session Management
------------------------------------------
-- Save and load session
vim.keymap.set('n', '<leader>ss', ':mksession! .session.vim<CR>', { noremap = true, silent = false }) -- Save session
vim.keymap.set('n', '<leader>sl', ':source .session.vim<CR>', { noremap = true, silent = false }) -- Load session
