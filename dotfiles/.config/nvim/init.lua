-- Vim option config
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Java: use Homebrew OpenJDK for all Java tooling started by Neovim (jdtls, javac, ...)
local java_home = '/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home'
if vim.fn.isdirectory(java_home) == 1 then
    vim.env.JAVA_HOME = java_home
    vim.env.PATH = java_home .. '/bin:' .. vim.env.PATH
end

-- OCaml: make the opam switch binaries available to Neovim (ocamllsp, ocamlopt, dune, ...)
local opam_bin = vim.fn.expand('~/.opam/default/bin')
if vim.fn.isdirectory(opam_bin) == 1 then
    vim.env.PATH = opam_bin .. ':' .. vim.env.PATH
end

vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.numberwidth = 4
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.fillchars:append({ diff = '╱' })

vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- Diagnostic settings
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

vim.keymap.set('n', '<leader>d', function()
    vim.diagnostic.open_float(nil, { scope = 'buffer', border = 'rounded' })
end, { desc = 'Show all diagnostics of current buffer' })

vim.keymap.set('n', '<leader>q', function()
    vim.diagnostic.setloclist()
end, { desc = 'Open diagnostic loclist' })

-- Navigation settings
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<A-h>', '<cmd>tabprevious<CR>', { desc = 'Go to previous tab' })
vim.keymap.set('n', '<A-l>', '<cmd>tabnext<CR>', { desc = 'Go to next tab' })
vim.keymap.set('n', '<leader>r', function()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
    vim.notify('Relative number: ' .. (vim.opt.relativenumber:get() and 'ON' or 'OFF'))
end, { desc = 'Toggle relative number' })

-- Wrap text
vim.keymap.set('n', '<leader>fw', function()
    vim.opt.wrap = not vim.opt.wrap:get()
    vim.notify('Wrap: ' .. (vim.opt.wrap:get() and 'ON' or 'OFF'))
end, { desc = 'Toggle text wrap' })

-- Yank text highlight
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Buffer settings
vim.keymap.set('n', '<leader>bf', function()
    vim.lsp.buf.format()
end, { desc = 'Format buffer custom' })

vim.keymap.set('n', '<leader>bd', '<cmd>bd<CR>', { desc = 'Delete current buffer' })

-- Compile current buffer with the given command
local function compile_buffer(name, exts, build_cmd)
    local src = vim.api.nvim_buf_get_name(0)
    if src == '' then
        vim.notify('Save the buffer before compiling', vim.log.levels.WARN)
        return
    end

    local ext = vim.fn.fnamemodify(src, ':e')
    if not vim.tbl_contains(exts, ext) then
        vim.notify(name .. ' cannot compile .' .. ext .. ' files', vim.log.levels.WARN)
        return
    end

    vim.cmd.write()
    local cmd, out = build_cmd(src)

    vim.system(cmd, { text = true }, function(result)
        vim.schedule(function()
            if result.code == 0 then
                local msg = 'Compiled ' .. vim.fn.fnamemodify(src, ':t')
                if out then
                    msg = msg .. ' -> ' .. vim.fn.fnamemodify(out, ':t')
                end
                vim.notify(msg, vim.log.levels.INFO)
            else
                vim.notify(result.stderr ~= '' and result.stderr or 'Compilation failed', vim.log.levels.ERROR)
            end
        end)
    end)
end

-- g++ for C/C++ (main.cpp -> main)
vim.keymap.set('n', '<leader>cc', function()
    compile_buffer('g++', { 'c', 'cc', 'cpp', 'cxx' }, function(src)
        local out = vim.fn.fnamemodify(src, ':r')
        return { 'g++', src, '-o', out }, out
    end)
end, { desc = 'Compile current C/C++ file with g++' })

-- javac for Java (Main.java -> Main.class)
vim.keymap.set('n', '<leader>cj', function()
    compile_buffer('javac', { 'java' }, function(src)
        return { 'javac', src }
    end)
end, { desc = 'Compile current Java file with javac' })

-- rustc for Rust (main.rs -> main)
vim.keymap.set('n', '<leader>cr', function()
    compile_buffer('rustc', { 'rs' }, function(src)
        local out = vim.fn.fnamemodify(src, ':r')
        return { 'rustc', '--edition', '2021', src, '-o', out }, out
    end)
end, { desc = 'Compile current Rust file with rustc' })

-- ocamlopt for OCaml (main.ml -> main)
vim.keymap.set('n', '<leader>co', function()
    compile_buffer('ocamlopt', { 'ml' }, function(src)
        local out = vim.fn.fnamemodify(src, ':r')
        return { 'ocamlopt', src, '-o', out }, out
    end)
end, { desc = 'Compile current OCaml file with ocamlopt' })

-- CsvView plugin
vim.keymap.set(
    'n',
    '<leader>cv',
    '<cmd>CsvViewEnable display_mode=border<CR>',
    { desc = 'Enable CsvView with border display' }
)
vim.keymap.set('n', '<leader>cx', '<cmd>CsvViewToggle display_mode=border<CR>', { desc = 'Toggle CsvView' })

-- Lazyvim configuration
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end

local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
    { import = 'plugins' },
}, {
    git = {
        timeout = 300,
    },
    ui = {
        icons = vim.g.have_nerd_font and {} or {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    },
})
