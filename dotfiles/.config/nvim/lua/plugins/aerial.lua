return {
    'stevearc/aerial.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        require('aerial').setup({
            backends = { 'lsp', 'treesitter', 'markdown', 'asciidoc', 'man' },
            layout = {
                max_width = { 40, 0.2 },
                width = nil,
                min_width = 10,
                default_direction = 'prefer_right',
                placement = 'window',
            },

            open_automatic = false,
            show_guides = true,
            filter_kind = {
                'File',
                'Module',
                'Namespace',
                'Package',
                'Class',
                'Method',
                'Property',
                'Field',
                'Constructor',
                'Enum',
                'Interface',
                'Function',
                'Variable',
                'Constant',
                'String',
                'Number',
                'Boolean',
                'Array',
                'Object',
                'Key',
                'Null',
                'EnumMember',
                'Struct',
                'Event',
                'Operator',
                'TypeParameter',
            },
        })

        vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>', { desc = 'Toggle [A]erial' })
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { desc = 'Aerial Prev' })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { desc = 'Aerial Next' })
    end,
}
