return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        local filetypes = {
            'sh',
            'typescriptreact',
            'typescript',
            'arduino',
            'asm',
            'bash',
            'bibtex',
            'c',
            'c_sharp',
            'cmake',
            'cpp',
            'cuda',
            'dockerfile',
            'doxygen',
            'fortran',
            'go',
            'haskell',
            'html',
            'htmldjango',
            'java',
            'javadoc',
            'javascript',
            'jsx',
            'json',
            'kotlin',
            'latex',
            'make',
            'markdown',
            'lua',
            'luadoc',
            'ninja',
            'ocaml',
            'ocaml_interface',
            'ocamllex',
            'perl',
            'php',
            'python',
            'r',
            'scheme',
            'sql',
            'ssh_config',
            'swift',
            'xml',
            'yaml',
            'typst',
        }
        local ensure_installed = {
            'tsx',
            'typescript',
            'arduino',
            'asm',
            'bash',
            'bibtex',
            'c',
            'c_sharp',
            'cmake',
            'cpp',
            'cuda',
            'dockerfile',
            'doxygen',
            'fortran',
            'go',
            'haskell',
            'html',
            'htmldjango',
            'java',
            'javadoc',
            'javascript',
            'jsx',
            'json',
            'kotlin',
            'latex',
            'make',
            'markdown',
            'lua',
            'luadoc',
            'ninja',
            'ocaml',
            'ocaml_interface',
            'ocamllex',
            'perl',
            'php',
            'python',
            'r',
            'scheme',
            'sql',
            'ssh_config',
            'swift',
            'xml',
            'yaml',
            'typst',
        }

        -- vim.cmd 'syntax off'
        require('nvim-treesitter').install(ensure_installed)
        vim.api.nvim_create_autocmd('FileType', {
            pattern = filetypes,
            callback = function()
                vim.treesitter.start()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })

        local function toggle_folds()
            if vim.wo.foldmethod == 'expr' then
                vim.wo.foldmethod = 'manual'
            else
                vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                vim.wo.foldmethod = 'expr'
            end
        end
        vim.api.nvim_create_user_command('TSFold', toggle_folds, {})
        vim.keymap.set('n', '<leader>tf', toggle_folds, { desc = 'Toggle treesitter folding' })
    end,
}
