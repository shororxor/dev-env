" Basic setup for modern vim
syntax on
set nocompatible
set backup
set backupdir=~/.backup

" Identation configuration
filetype plugin indent on
set autoindent
set smartindent

" Tab configuration
set expandtab
set tabstop=2
set shiftwidth=2

" UI configuration
set wrap
set linebreak
set ruler
color onedark
set t_RV=
set t_u7=
set number
set clipboard=unnamedplus,unnamed

" Smart bracket
inoremap { {}<Left>
inoremap <expr> <CR> getline('.')[col('.') - 2 : col('.') - 1] == '{}' ? "\<CR>\<ESC>O" : "\<CR>"

" Remap tab change
nnoremap <C-h> gT
nnoremap <C-l> gt
set tabpagemax=60

" Visual map for commentng java code
vnoremap c :s#^#// #<CR>
vnoremap u :s#^// ##<CR>

" Past yanked text in terminal
tnoremap <C-p> <C-w>""
tnoremap <Esc><Esc> <C-w>N

" Allow mouse usage
set mouse+=a

" Advanced options
" set hidden 
" set wildmenu 
" set showcmd 
" set hlsearch 
" set confirm 
" set visualbell 
" set ignorecase 
" set smartcase

" Abbreviation fast snippet
abbr psvm public static void main(String[] args) {
abbr sout System.out.println("");<esc>2hi
abbr sop System.out.print("");<esc>2hi

" Syntastic configuration
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_c_checkers = ['clang_tidy', 'clang_check']
let g:syntastic_clang_tidy_config_file = 'compile_flags.txt'
let g:syntastic_clang_check_config_file = 'compile_flags.txt'
let g:syntastic_c_compiler = 'clang'
let g:syntastic_c_config_file = 'compile_flags.txt'
let g:syntastic_java_checkers = ['javac', 'checkstyle']
let g:syntastic_java_checkstyle_classpath = "~cs2030s/bin/checkstyle.jar"
let g:syntastic_java_checkstyle_conf_file = "~cs2030s/bin/checkstyle.xml"
let g:syntastic_sh_checkers = ['shellcheck']
let g:syntastic_sh_shellcheck_args="-x"
let g:syntastic_java_javac_options = "-Xlint:rawtypes -Xlint:unchecked"
let g:syntastic_loc_list_height = 4
