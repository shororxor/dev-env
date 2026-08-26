return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'nvim-tree/nvim-web-devicons',
    },

    config = function()
        require('neo-tree').setup({
            filesystem = {
                commands = {
                    avante_add_files = function(state)
                        local node = state.tree:get_node()
                        if not node then
                            return
                        end
                        local filepath = node:get_id()
                        local relative_path = require('avante.utils').relative_path(filepath)
                        local sidebar = require('avante').get()

                        local open = sidebar:is_open()
                        if not open then
                            require('avante.api').ask()
                            sidebar = require('avante').get()
                        end
                        sidebar.file_selector:add_selected_file(relative_path)

                        if not open then
                            sidebar.file_selector:remove_selected_file('neo-tree filesystem [1]')
                        end
                    end,

                    open_pdf_in_firefox = function(state)
                        local node = state.tree:get_node()
                        if not node then
                            return
                        end
                        local path = node:get_id()
                        if not path then
                            vim.notify('No file path found', vim.log.levels.WARN)
                        end

                        if path:match('%.pdf$') then
                            vim.fn.jobstart({ 'firefox', path }, { detach = true })
                        else
                            vim.notify('Not a PDF file', vim.log.levels.WARN)
                        end
                    end,

                    open_markdown_in_firefox = function(state)
                        local node = state.tree:get_node()
                        if not node then
                            return
                        end
                        local path = node:get_id()
                        if not path then
                            vim.notify('No file path found', vim.log.levels.WARN)
                        end

                        if path:match('%.pdf$') then
                            vim.fn.jobstart({ 'firefox', path }, { detach = true })
                        else
                            vim.notify('Not a PDF file', vim.log.levels.WARN)
                        end
                    end,
                },
                window = {
                    mappings = {
                        ['oa'] = 'avante_add_files',
                        ['op'] = 'open_pdf_in_firefox',
                        ['om'] = 'open_markdown_in_firefox',
                    },
                },
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
            },
        })
    end,
}
