return {
    'shororxor/github-nvim-theme',
    branch = 'explore',
    name = 'github-theme',
    lazy = false,
    priority = 1000,
    config = function()
        require('github-theme').setup({})
    end,
}
