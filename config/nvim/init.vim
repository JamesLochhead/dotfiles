"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" File-top section
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

" ALE and coc integration, needs to be before plugins
let g:ale_disable_lsp = 1

" Automatic VimPlug installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" Plugins
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

call plug#begin()
Plug 'preservim/nerdtree'                                          " File navigation in a left pane
Plug 'vim-airline/vim-airline', { 'tag': 'v0.11' }                 " Nicer bottom status line with git branch
Plug 'vim-airline/vim-airline-themes'                              " Themes for the above
Plug 'dense-analysis/ale'                                          " Async linting, code completion, etc
Plug 'moll/vim-bbye'                                               " Enables some commands that improve NERDTree
Plug 'plasticboy/vim-markdown'                                     " Vim markdown syntax highlighting
Plug 'godlygeek/tabular'                                           " Need for vim-markdown table formatting
"Plug 'ParamagicDev/vim-medic_chalk'                                " Theme
Plug 'Xuyuanp/nerdtree-git-plugin'                                 " Git status in NERDTree
Plug 'airblade/vim-gitgutter'                                      " See changes that have been made to a file
Plug 'tpope/vim-surround'                                          " Shortcuts for surrounding text with characters
Plug 'tpope/vim-commentary'                                        " Shortcuts for commenting out code
Plug 'neoclide/coc.nvim', {'branch': 'release'}                    " Code completion
Plug 'pearofducks/ansible-vim'                                     " Ansible syntax highlighting
Plug 'koalaman/shellcheck'                                         " Bash/sh linter
"Plug 'altercation/vim-colors-solarized'                            " Solarized theme
Plug 'romainl/flattened'                                           " Alternative to Solarized
Plug 'nathanaelkane/vim-indent-guides'                             " Indent guides for code blocks
Plug 'liuchengxu/vista.vim'                                        " Python navigation pane. Requries ctags.
Plug 'ntpeters/vim-better-whitespace' 				   " Show trailing whitespace in red
call plug#end()

"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" Plugin: nathanaelkane/vim-indent-guides configuration
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#fdf6e3   ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#f7f0dd ctermbg=4

" moll/vim-bbye allows buffers to be closed without closing windows, hence
" keeping vim open when a buffer needs to be closed. The command is :Bd.

"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" General options
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set number relativenumber                      " Turn on line numbers
set mouse=a                                    " Turn on mouse mode
set nowrap                                     " No word wrapping
"set autoread                                  " Reload all changed files automatically
set colorcolumn=80,100                         " Column highlighting
"set textwidth=80                              " Set the width for auto wrapping

" Causing incorrect colours in Byobu:
set termguicolors                             " Enable True Color

"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" File-type specific
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

" Enable the filetype plugin for extra vim config files.
" Currently used for automatic Python docstring folding.
filetype plugin on

" Sane tabs for YAML
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" foldmethod=syntax just for Python; necessary for docstring folding
autocmd FileType python setlocal foldenable foldmethod=syntax

" Set textwidth by file type
" au BufRead,BufNewFile *.md setlocal textwidth=80

"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" Plugin: NerdTree
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

" Shortcut for NERDTree
map <C-n> :NERDTreeToggle<CR>

" Close NERDTree when it is the only window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" If Neovim starts with no open files, open NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open NERDTree and another window when a folder is opened in Neovim
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" Make NerdTree prettier
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" Plugin: vim-airline
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

" Show a line for tabs and buffers
let g:airline#extensions#tabline#enabled = 1

" Theme for vim-airline 
let g:airline_theme='minimalist'

let g:airline#extensions#tabline#formatter = 'unique_tail'

"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" Plugin: ALE
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

" Turn on code completion; turn off if using another source
" 0 = off
let g:ale_completion_enabled = 0

" Override filetypes for specific paths so linters work
au BufRead,BufNewFile **/Ansible**.yml set filetype=yaml.ansible
au BufRead,BufNewFile **/ansible**.yml set filetype=yaml.ansible
au BufRead,BufNewFile **/cloudformation**.yml set filetype=yaml.cloudformation
au BufRead,BufNewFile **/Cloudformation**.yml set filetype=yaml.cloudformation

" Enabled fixers
let g:ale_fixers = {
\ 'yaml': ['prettier'],
\ 'javascript': ['prettier'],
\ 'json': ['prettier'],
\ 'sh': ['shfmt'],
\ 'python': ['yapf'],
\}

"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" Plugin: Shortcuts
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

" Leader = ,
let mapleader = ","

" ,w = attempt to save with sudo
noremap <Leader>w :w !sudo tee % > /dev/null<cr>

" Prettify JSON with jq
noremap <Leader>j :%!jq '.'<cr>

" TableFormat using vim-markdown
noremap <Leader>t :TableFormat<cr>

" ALEFix
noremap <Leader>f :ALEFix<cr>

" Set spelling on
noremap <Leader>a :set nospell<cr>

" Turn spelling off
noremap <Leader>s :set spell spelllang=en_gb<cr>

" Toggle word wrapping
noremap <Leader>w :set wrap!<cr>

" Open init.vim in a new window
noremap <Leader>i :vert new ~/.config/nvim/init.vim<cr>

" windodiff this
noremap <Leader>d :windo diffthis<cr>

" windodiff this
noremap <Leader>e :diffoff<cr>

" Current column highlight
noremap <Leader>k :set cursorcolumn!<cr>

" Check if a file has been modified
noremap <Leader>x :checktime

" Current line highlight
noremap <Leader>l :set cursorline!<cr>

" Next buffer
noremap <Leader>n :bn<cr>

" Previous buffer
noremap <Leader>p :bp<cr>

" Re-format visually highlighted blocks to textwidth
noremap <Leader>g gq

" Toggle indent guides
noremap <Leader>y :IndentGuidesToggle<cr>

" Activate Vista
noremap <Leader>v :Vista!

" Activate init.vim changes
:noremap <Leader>u :source $MYVIMRC<cr>

"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" Plugin: vim-markdown
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

" Disable vim markdown code folding
let g:vim_markdown_folding_disabled = 1

" Disable code block concealment
let g:vim_markdown_conceal_code_blocks = 0

" Highlight Jekyll and Hugo front matter
let g:vim_markdown_frontmatter = 1

" Enable strikethrough
let g:vim_markdown_strikethrough = 1

" Number of spaces that are inserted when o is pressed in a list
let g:vim_markdown_new_list_item_indent = 0

" Disable automatic inseration of bullets
let g:vim_markdown_auto_insert_bullets = 0

" Disable quote concealing in JSON files
let g:vim_json_conceal=0

"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" Plugin: vim-gitgutter
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

" Make signs appear faster
set updatetime=100

" Override theme colours
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00  ctermfg=3
highlight GitGutterDelete guifg=#ff2222  ctermfg=1

"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" Plugin: coc
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-git', 'coc-cfn-lint', 'coc-pyright', 'coc-sh', 'coc-yaml', 'coc-swagger']

"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" Clipboard (notes)
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
"
" Nvim has no direct connection to the system clipboard. Instead it is
" accessible through a |provider| which transparently uses shell commands for
" communicating with the clipboard.
"
" Clipboard access is implicitly enabled if any of the following clipboard
" tools are found in your $PATH.
"
" - xclip
" - xsel (newer alternative to xclip)
" - pbcopy/pbpaste (Mac OS X)
" - lemonade (for SSH) https://github.com/pocke/lemonade
" - doitclient (for SSH) http://www.chiark.greenend.org.uk/~sgtatham/doit/
"
" Source: https://github.com/neovim/neovim/issues/1696

"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" Plugin: vim-commentary and vim-surround
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

" `gcc` to comment out a line.
" `gc` for use with a motion or visual mode.

" Inside a quoted block, for example, double quotes, press cs"', to replace
" with single quotes. Also works with non-quotes; stuff like HTML tags.

" ds" would completely the delimeter.

" cst" would change a HTML tag for a double bracket.
"

"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
" File-bottom section
"::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

" Set the color scheme; needs to be at the bottom for some reason
colorscheme flattened_light
