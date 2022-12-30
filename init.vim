call plug#begin('~/.vim/plugged')

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Completion framework
Plug 'hrsh7th/nvim-cmp'

" LSP completion source for nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'

" Snippet completion source for nvim-cmp
Plug 'hrsh7th/cmp-vsnip'

" Other usefull completion sources
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'

" See hrsh7th's other plugins for more completion sources!

" Snippet engine
Plug 'hrsh7th/vim-vsnip'

" Fuzzy finder
" Optional
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Color scheme used in the GIFs!
" Plug 'arcticicestudio/nord-vim'

Plug 'preservim/nerdtree'

Plug 'fatih/molokai'
" Plug 'gilgigilgil/anderson.vim'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'doums/darcula'

Plug 'airblade/vim-gitgutter'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-fugitive'

Plug 'fatih/vim-go'
" Plug 'ray-x/go.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }

call plug#end()
"====================================================================================================================
" Some basic stuff

" colorscheme molokai
" colorscheme sonokai
colorscheme darcula

" show lines numbers
" set number

" use relative numbers for lines
set number relativenumber

" use system clipboard
set clipboard=unnamedplus

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" boundry column for line length
set colorcolumn=80

" highlight cursor line
set cursorline
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine guibg=#303000 ctermbg=234

" highlight in file the word to which the cursor is pointin
autocmd CursorMoved * exe printf('match TabLineSel /\V\<%s\>/', escape(expand('<cword>'), '/\'))

" git branch in statusline
" function! StatuslineGit()
"   let l:branchname = GitBranch()
"   return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
" endfunction
" set statusline=
" set statusline+=%{StatuslineGit()}
"====================================================================================================================

" nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let g:NERDTreeWinSize=30
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$']
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"====================================================================================================================
" Telescope

" Find files using Telescope command-line sugar.
nnoremap <silent>ff <cmd>Telescope find_files<CR>
nnoremap <silent>fg <cmd>Telescope live_grep<CR>
nnoremap <silent>fb <cmd>Telescope buffers<CR>
nnoremap <silent>fh <cmd>Telescope help_tags<CR>

" Using Lua functions
"nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<CR>
"nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<CR>
"nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<CR>
"nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<CR>
"====================================================================================================================
" Airline

let g:airline_theme='minimalist'
"====================================================================================================================
"vim-go

let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
let g:vim_markdown_folding_disabled = 1
autocmd FileType go nmap gi  <Plug>(go-implements)
autocmd FileType go nnoremap  gr :GoReferrers<CR>
autocmd FileType go nnoremap  gn :GoRename<CR>
nnoremap <F3> :GoDebugTest<CR>
nnoremap <F4> :GoDebugBreakpoint<CR>
nnoremap <F5> :GoDebugStep<CR>
nnoremap <F6> :GoDebugStepOut<CR>
nnoremap <F7> :GoDebugContinue<CR>
nnoremap <F8> :GoDebugNext<CR>
nnoremap <F9> :GoDebugRestart<CR>
"====================================================================================================================
