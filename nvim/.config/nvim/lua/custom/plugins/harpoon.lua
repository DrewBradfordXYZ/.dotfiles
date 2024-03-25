return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },

  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():append()
    end, { desc = 'Harpoon: Add current file' })

    vim.keymap.set('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set('n', '<C-a>', function()
      harpoon:list():select(1)
    end)
    vim.keymap.set('n', '<C-s>', function()
      harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<C-g>', function()
      harpoon:list():select(3)
    end)
    vim.keymap.set('n', '<C-n>', function()
      harpoon:list():select(4)
    end)
    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<C-S-h>', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<C-S-l>', function()
      harpoon:list():next()
    end) -- I had to disable this keybind in Wezterm
  end,
}
