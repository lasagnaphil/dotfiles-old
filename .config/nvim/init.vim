call plug#begin('~/.local/share/nvim/plugged')

Plug 'chriskempson/base16-vim'

Plug 'junegunn/goyo.vim'

Plug 'neomake/neomake'

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jistr/vim-nerdtree-tabs'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'vim-airline/vim-airline'

Plug 'vimlab/split-term.vim'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'roxma/nvim-completion-manager'

Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }

Plug 'vim-pandoc/vim-pandoc', { 'for': 'markdown' }
Plug 'vim-pandoc/vim-pandoc-syntax', { 'for': 'markdown' }

Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'cakebaker/scss-syntax.vim'

Plug 'slim-template/vim-slim', { 'for': 'slim' }

Plug 'rust-lang/rust.vim', { 'for': 'rust' }

Plug 'vim-scripts/asmx86_64'

Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'othree/javascript-libraries-syntax.vim'

Plug 'lervag/vimtex'
Plug 'lluchs/vim-wren', { 'for': 'wren' }

call plug#end()

" Colors
syntax on
"if &term =~# '^screen'
"    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
"endif
hi Pmenu ctermbg=gray guibg=gray
hi PmenuSel ctermbg=yellow guibg=yellow
highlight LineNr ctermfg=grey ctermbg=white
if has("termguicolors")
    set termguicolors
endif
"let base16colorspace=256
colorscheme base16-default-dark

filetype on
au BufNewFile,BufRead *.rs set filetype=rust

" set ruby compiler plugin
autocmd FileType ruby compiler ruby

" Spaces & Tabs
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set smarttab
set ai
set si

" set tab spacing for ruby
autocmd Filetype ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2

" set tab spacing for tex
autocmd Filetype tex setlocal tabstop=2 shiftwidth=2 softtabstop=2


" UI Config
set number
set wildmenu
set showmatch

" Display status line always
set statusline=2
set laststatus=2
set ttimeoutlen=50

" Searching
set incsearch
set hlsearch
nnoremap <leader><space> :nohlsearch<CR>

" Folding
set foldenable
set foldlevelstart=10
set foldnestmax=10
nnoremap <space> za

" Movement
nnoremap j gj
nnoremap k gk
nnoremap gV `[v`]

" Leader shortcuts
let mapleader = ","

" Duh.
inoremap jk <Esc>

" Better split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" More natural split opening
set splitbelow
set splitright

" Enable mouse support
set mouse=a

" LanguageClient
set hidden
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ }
let g:LanguageClient_autoStart = 1

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" Neomake: Run cargo asynchronously on saving rust files
autocmd! BufWritePost, *.rs Neomake! cargo

" NeoMake: Enable messages
let g:neomake_verbose = 3

" NeoMake: Open the list of errors without moving the cursor
let g:neomake_open_list = 2

" NeoMake: Disable rustc maker, enable cargo maker.
let g:neomake_rust_enabled_makers = []
let g:neomake_enabled_makers = ['cargo']
let g:neomake_cargo_args = ['check']

" NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" CTRL-n to toggle tree view
map <C-n> :NERDTreeTabsToggle<CR>

" vim-numbertoggle
let g:NumberToggleTrigger="<F3>"

" deoplete
let g:deoplete#enable_at_startup = 1

" OCaml Merlin integration
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" fzf.vim
map <C-p> :Files<CR>

"
" Terminal integration
"

" Window split settings
" highlight TermCursor ctermfg=red guifg=red
set splitbelow
set splitright

" Terminal settings
tnoremap <Leader><ESC> <C-\><C-n>

" No line numbers in terminal
au TermOpen * setlocal nonumber norelativenumber

" Window navigation function
" Make ctrl-h/j/k/l move between windows and auto-insert in terminals
func! s:mapMoveToWindowInDirection(direction)
    func! s:maybeInsertMode(direction)
        stopinsert
        execute "wincmd" a:direction

        if &buftype == 'terminal'
            startinsert!
        endif
    endfunc

    execute "tnoremap" "<silent>" "<C-" . a:direction . ">"
                \ "<C-\\><C-n>"
                \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
    execute "nnoremap" "<silent>" "<C-" . a:direction . ">"
                \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
endfunc
for dir in ["j", "k"]
    call s:mapMoveToWindowInDirection(dir)
endfor

" Vimtex
let g:vimtex_view_method = 'zathura'
let g:vimtex_latexmk_options = '-pdf -shell-escape -verbose -file-line-error -synctex=1 -interaction=nonstopmode'
