-- Base editor behavior and appearance.

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.numberwidth = 4

-- Wrapping
vim.opt.wrap = false
vim.opt.breakindent = true

-- Undo
vim.opt.undofile = true

-- Cursor and search
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Mouse
vim.opt.mouse = 'a'

-- Show mode / color
vim.opt.showmode = false
vim.opt.termguicolors = true

-- Sign column / diagnostics margin
vim.opt.signcolumn = 'yes'

-- Scrolling margin
vim.opt.scrolloff = 10

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Prompt confirmation
vim.opt.confirm = true

-- Tabs / indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Hidden characters
vim.opt.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview commands in a split
vim.opt.inccommand = 'split'

-- Characters shown in diffs
vim.opt.fillchars:append({ diff = '╱' })

-- Clipboard is read/written after the GUI is ready so it does not warn.
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- Diagnostics
vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,

    float = {
        border = 'rounded',
        source = 'if_many',
    },

    underline = {
        severity = vim.diagnostic.severity.ERROR,
    },

    virtual_text = {
        severity = vim.diagnostic.severity.ERROR,
    },

    signs = {
        severity = vim.diagnostic.severity.ERROR,
    },

    virtual_lines = false,
    jump = { float = true },
})

-- Highlight text when yanking (copying) it.
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
