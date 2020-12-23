" First of all determine os
let g:os = substitute(system('uname'), '\n', '', '')
" Linux or Darwin


" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
    finish
endif

" Get the defaults that most users want.
if !has("nvim")
    source $VIMRUNTIME/defaults.vim
endif

if has("vms")
    set nobackup		" do not keep a backup file, use versions instead
else
    set backup		" keep a backup file (restore to previous version)
    if has('persistent_undo')
        set undofile	" keep an undo file (undo changes after closing)
    endif
endif

if &t_Co > 2 || has("gui_running")
    " Switch on highlighting the last used search pattern.
    set hlsearch
endif

" Settings
set wildmode=longest:full,full " Command completion mode

set ts=4 " Expand tab section
set sw=4
set et
set mouse=a
" Keymap
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
    packadd! matchit
endif

call plug#begin('~/.vim/plugged')

" UI
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

Plug 'tomasr/molokai'

Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim' "Not working in macvim
if !has("gui_running")
    let g:ranger_replace_netrw = 1
endif

" LaTeX
Plug 'lervag/vimtex'

" Python
Plug 'nvie/vim-flake8'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }

" Snippets and completions
"Plug 'valloric/youcompleteme'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'
Plug 'gisphm/vim-gitignore'

" Fun
Plug 'vim/killersheep'
call plug#end()

"UltiSnips
let g:UltiSnipsListSnippets = '<F2>'
let g:UltiSnipsExpandTrigger = '<F3>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsEnableSnipMate = 0

" YouCompleteMe .tex completions
"if !exists('g:ycm_semantic_triggers')
"    let g:ycm_semantic_triggers = {}
"endif
"au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme

" Vimtex settings
if g:os == 'Darwin'
    let g:vimtex_view_method = 'skim'
else
    let g:vimtex_view_method = 'zathura'
endif
let g:tex_flavor = 'latex'
" Use local texdoc
let g:vimtex_doc_handlers = ['MyHandler']
function! MyHandler(context)
    call vimtex#doc#make_selection(a:context)
    if !empty(a:context.selected)
        execute '!texdoc' a:context.selected '&'
    endif
    return 1
endfunction


" Colorscheme
let g:rehash256 = 1
colorscheme molokai
" vim hardcodes background color erase even if the terminfo file does
" not contain bce (not to mention that libvte based terminals
" incorrectly contain bce in their terminfo files). This causes
" incorrect background rendering when using a color theme with a
" background color.
let &t_ut=''



" Augroups
"
" Number group
augroup Lines
    au!
    "autocmd FileType tex	 let g:ycm_min_num_of_chars_for_completion=3
    autocmd FileType tex	 set number
    autocmd FileType py      set number
    autocmd FileType vim	 set number
    autocmd FileType tex     set tw=99
augroup END
set relativenumber

augroup Formatting
    au!
    au FileType python setlocal formatprg=autopep8\ -
augroup END

" Cursor Settings
"if !has("gui_running")
"    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
"    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"endif
"
if !has("gui_running")
    let &t_SI="\<Esc>[5 q"
    let &t_EI="\<Esc>[2 q"
endif
"if exists('$TMUX')
"    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
"    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
"else
"    let &t_SI = "\e[5 q"
"    let &t_EI = "\e[2 q"
"endif

" Mappings
nnoremap <leader>bs	:terminal<CR> 
nnoremap <leader>bw	:terminal ++curwin<CR>
nnoremap <leader>tn	:tabnew<CR>
nnoremap <leader>tb 	:tab terminal<CR> 
nnoremap <leader>tc 	:tabclose<CR>
nnoremap <C-j>	 	:tabp<CR>
nnoremap <C-k>	 	:tabn<CR>

"" Coc mappings
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<Tab>" :
            \ coc#refresh()

inoremap <silent><expr> <c-n> coc#refresh()
