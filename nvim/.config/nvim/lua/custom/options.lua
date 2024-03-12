-- Set relative numbered lines
vim.o.relativenumber = true

-- Set the number of spaces a tab character represents in the file.
-- This affects movement in normal mode and the appearance of tabs.
vim.o.tabstop = 4

-- Set the number of spaces for each step of (auto)indentation.
-- Also, control the behavior of the Tab key in insert mode and visual mode.
-- This works in conjunction with 'expandtab'.
vim.o.shiftwidth = 4

-- Set the number of spaces a <Tab> in the file counts for when performing
-- editing operations like inserting or deleting text.
-- This provides flexibility for consistent indentation in mixed indentation styles.
vim.o.softtabstop = 4

-- Expand <Tab> to spaces, ensuring consistent indentation.
-- This works in conjunction with 'shiftwidth'.
vim.o.expandtab = true

-- Set side-scroll offset to 8 columns
vim.o.sidescrolloff = 8

-- Netrw modifications
vim.g.netrw_banner = 0 -- Disable banner
vim.g.netrw_liststyle = 3 -- Tree view
