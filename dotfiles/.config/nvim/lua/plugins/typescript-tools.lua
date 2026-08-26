return {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    config = function()
        require('typescript-tools').setup {
            on_attach = function() end,
            handlers = {},
            capabilities = require('blink.cmp').get_lsp_capabilities(),
            settings = {
                separate_diagnostic_server = true,
                publish_diagnostic_on = 'insert_leave',
                expose_as_code_action = 'all',
                tsserver_plugins = {},
                tsserver_max_memory = 'auto',
                tsserver_locale = 'en',
                complete_function_calls = false,
                include_completions_with_insert_text = true,
                code_lens = 'off',
                disable_member_code_lens = true,
                jsx_close_tag = {
                    enable = false,
                    filetypes = { 'typescriptreact', 'javascriptreact' },
                },
            },
        }
    end,
}
