-- Leader keymaps for navigation, diagnostics, toggles, buffers, and CSV viewing.

-- Clear a highlight search.
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Remind the user to stick with hjkl for movement.
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Exit terminal mode with a double Escape.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Move between tabs.
vim.keymap.set('n', '<A-h>', '<cmd>tabprevious<CR>', { desc = 'Go to previous tab' })
vim.keymap.set('n', '<A-l>', '<cmd>tabnext<CR>', { desc = 'Go to next tab' })

-- Toggle relative line numbers.
vim.keymap.set('n', '<leader>r', function()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
    vim.notify('Relative number: ' .. (vim.opt.relativenumber:get() and 'ON' or 'OFF'))
end, { desc = 'Toggle relative number' })

-- Toggle text wrap.
vim.keymap.set('n', '<leader>fw', function()
    vim.opt.wrap = not vim.opt.wrap:get()
    vim.notify('Wrap: ' .. (vim.opt.wrap:get() and 'ON' or 'OFF'))
end, { desc = 'Toggle text wrap' })

-- Format and delete the current buffer.
vim.keymap.set('n', '<leader>bf', function()
    vim.lsp.buf.format()
end, { desc = 'Format buffer custom' })

vim.keymap.set('n', '<leader>bd', '<cmd>bd<CR>', { desc = 'Delete current buffer' })

-- Show diagnostics of the current buffer.
vim.keymap.set('n', '<leader>d', function()
    vim.diagnostic.open_float(nil, { scope = 'buffer', border = 'rounded' })
end, { desc = 'Show all diagnostics of current buffer' })

-- Open the diagnostic location list.
vim.keymap.set('n', '<leader>q', function()
    vim.diagnostic.setloclist()
end, { desc = 'Open diagnostic loclist' })

-- CsvView plugin
vim.keymap.set(
    'n',
    '<leader>cv',
    '<cmd>CsvViewEnable display_mode=border<CR>',
    { desc = 'Enable CsvView with border display' }
)
vim.keymap.set('n', '<leader>cx', '<cmd>CsvViewToggle display_mode=border<CR>', { desc = 'Toggle CsvView' })
