local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Netrw file explorer
keymap('n', '<leader>f', vim.cmd.Ex, { noremap = true, silent = true, desc = 'Open file explorer' })

-- Copy into system clipboard. Use C-v to paste like normal
keymap({ 'n', 'v' }, '<leader>y', [["+y]], { noremap = true, silent = true, desc = 'System Clipboard: Yank characterwise' })
keymap({ 'n', 'v' }, '<leader>Y', [["+Y,]], { noremap = true, silent = true, desc = 'System Clipboard: Yank linewise' })

keymap({ 'n', 'v' }, '<leader>d', [["_d]], { noremap = true, silent = true, desc = 'System Clipboard: Delete' })

-- Keep the origionally copied text when pasting over other text
keymap('x', 'p', [["_dP]])

-- Keep the cursor at the start of joined lines
keymap('n', 'J', 'mzJ`z', { noremap = true, silent = true, desc = 'Join lines' })

-- Quit and save
keymap('n', '<leader>x', ':q<CR>', { noremap = true, silent = true, desc = 'Quit window' })
keymap('n', '<leader>a', ':w<CR>', { noremap = true, silent = true, desc = 'Save file' })

-- Create new window splits
keymap('n', '<leader>t', '<C-w>s', { desc = 'Split window horizontally' })
keymap('n', '<leader>v', '<C-w>v', { desc = 'Split window vertically' })

-- Terminal split
keymap('n', '<leader>T', ':below 10sp | terminal<CR>', { noremap = true, silent = true, desc = 'Open terminal in horizontal split' })

-- Resize split horizontally and vertically
keymap('n', '<S-Up>', ':resize +2<CR>', { noremap = true, silent = true })
keymap('n', '<S-Down>', ':resize -2<CR>', { noremap = true, silent = true })
keymap('n', '<S-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true })
keymap('n', '<S-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true })

-- Center Screen
keymap('n', '<C-d>', '<C-d>zz', opts) -- scroll down a half page
keymap('n', '<C-u>', '<C-u>zz', opts) -- scroll up a hald page
keymap('n', 'n', 'nzz', opts) -- search next
keymap('n', 'N', 'Nzz', opts) -- search previous
keymap('n', '*', '*zz', opts) -- search forward: word under the cursor
keymap('n', '#', '#zz', opts) -- search backward: word under the cursor
keymap('n', 'g*', 'g*zz', opts) -- search forward: partial word under cursor
keymap('n', 'g#', 'g#zz', opts) -- search backward: partial word under cursor

-- Move lines up and down
keymap('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = 'Move line down' })
keymap('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = 'Move line up' })

-- Stay in indent mode
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Search and replace word under cursor
keymap('n', '<C-s>', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
