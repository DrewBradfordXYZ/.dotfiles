local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Netrw file explorer
keymap('n', '<leader>f', vim.cmd.Ex)

-- System clipboard, separate from vim clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { noremap = true, silent = true, desc = 'System Clipboard: Paste after' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { noremap = true, silent = true, desc = 'System Clipboard: Paste before' })
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { noremap = true, silent = true, desc = 'System Clipboard: Yank characterwise' })
vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"+Y', { noremap = true, silent = true, desc = 'System Clipboard: Yank linewise' })

-- Keep the origionally copied text when pasting over other text
keymap('x', 'p', [["_dP]])

-- Quit and save
keymap('n', '<leader>q', ':q<CR>', { noremap = true, silent = true, desc = 'Close window' })
keymap('n', '<leader>z', ':w<CR>', { noremap = true, silent = true, desc = 'Save file' })

-- Go to next and pervious buffer
keymap('n', '<C-p>', ':bprevious<CR>', { noremap = true, silent = true, desc = 'Toggle previous buffer' })
keymap('n', '<C-n>', ':bnext<CR>', { noremap = true, silent = true, desc = 'Toggle next buffer' })

-- Create new window splits
keymap('n', '<leader>t', '<C-w>s', { desc = 'Split window horizontally' })
keymap('n', '<leader>v', '<C-w>v', { desc = 'Split window vertically' })
-- open a horizaontal split and enter terminal mode
keymap('n', '<leader>T', ':below 10sp | terminal<CR>', { noremap = true, silent = true, desc = 'Open terminal in horizontal split' })

-- Resize split horizontally and vertically
keymap('n', '<S-Up>', ':resize +2<CR>', { noremap = true, silent = true })
keymap('n', '<S-Down>', ':resize -2<CR>', { noremap = true, silent = true })
keymap('n', '<S-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true })
keymap('n', '<S-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true })

-- Center Screen
keymap('n', 'n', 'nzz', opts) -- search next
keymap('n', 'N', 'Nzz', opts) -- search previous
keymap('n', '*', '*zz', opts) -- search forward: word under the cursor
keymap('n', '#', '#zz', opts) -- search backward: word under the cursor
keymap('n', 'g*', 'g*zz', opts) -- search forward: partial word under cursor
keymap('n', 'g#', 'g#zz', opts) -- search backward: partial word under cursor
keymap('n', '<C-d>', '<C-d>zz', opts) -- scroll down a half page
keymap('n', '<C-u>', '<C-u>zz', opts) -- scroll up a hald page

-- Stay in indent mode
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)
