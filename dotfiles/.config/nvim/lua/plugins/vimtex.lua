return {
    'lervag/vimtex',
    lazy = false,
    tag = 'v2.18',
    init = function()
        vim.g.vimtex_view_method = 'zathura'
        vim.g.vimtex_view_general_viewer = 'okular'
        vim.g.vimtex_compiler_method = 'latexmk'
        vim.g.vimtex_compiler_latexmk = {
            continuous = 0,
            build_dir = 'build',
            options = {
                '-pdf',
                '-shell-escape',
                '-verbose',
                '-file-line-error',
                '-synctex=1',
                '-interaction=nonstopmode',
                '-outdir=build',
            },
        }
    end,
}
