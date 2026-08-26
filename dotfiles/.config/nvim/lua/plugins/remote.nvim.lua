return {
    'shororxor/remote-nvim.nvim',
    branch = 'explore',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        local utils = require('remote-nvim.utils')
        local constants = require('remote-nvim.constants')
        require('remote-nvim').setup({
            remote = {
                app_name = 'nvim',
                copy_dirs = {
                    extra = {
                        -- {
                        --     from = vim.fn.expand(''),
                        --     to = '',
                        --     compression = { enabled = false },
                        -- },
                    },
                    config = {
                        base = vim.fn.stdpath('config'),
                        dirs = '*',
                        compression = {
                            enabled = false,
                            additional_opts = {},
                        },
                    },
                    data = {
                        base = vim.fn.stdpath('data'),
                        dirs = '*',
                        compression = {
                            enabled = true,
                        },
                    },
                    cache = {
                        base = vim.fn.stdpath('cache'),
                        dirs = {},
                        compression = {
                            enabled = true,
                        },
                    },
                    state = {
                        base = vim.fn.stdpath('state'),
                        dirs = {},
                        compression = {
                            enabled = true,
                        },
                    },
                },
            },

            client_callback = function(port, _)
                require('remote-nvim.ui').float_term(
                    ('nvim --server localhost:%s --remote-ui'):format(port),
                    function(exit_code)
                        if exit_code ~= 0 then
                            vim.notify(
                                ('Local client failed with exit code %s'):format(exit_code),
                                vim.log.levels.ERROR
                            )
                        end
                    end
                )
            end,

            log = {
                filepath = utils.path_join(
                    utils.is_windows,
                    vim.fn.stdpath('state'),
                    ('%s.log'):format(constants.PLUGIN_NAME)
                ),
                level = 'info',
                max_size = 1024 * 1024 * 2,
            },
        })
    end,
}
