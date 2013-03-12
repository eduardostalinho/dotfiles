map <S-Insert> <MiddleMouse>

map <F5> :bp<CR>
map <F6> :bn<CR>
map <F7> :syntax on<CR>
map <F8> :syntax off<CR>

map <C-S-Left> <c-w><
map <C-S-Right> <c-w>>
map <C-S-Up> <c-w>-
map <C-S-Down> <c-w>+

" vmap <space> zf

function ToggleFold()
   if foldlevel('.') == 0
      " No fold exists at the current line,
      " so create a fold based on indentation

      let l_min = line('.')   " the current line number
      let l_max = line('$')   " the last line number
      let i_min = indent('.') " the indentation of the current line
      let l = l_min + 1

      " Search downward for the last line whose indentation > i_min
      while l <= l_max
         " if this line is not blank ...
         if strlen(getline(l)) > 0 && getline(l) !~ '^\s*$'
            if indent(l) <= i_min

               " we've gone too far
               let l = l - 1    " backtrack one line
               break
            endif
         endif
         let l = l + 1
      endwhile

      " Clamp l to the last line
      if l > l_max
         let l = l_max
      endif

      " Backtrack to the last non-blank line
      while l > l_min
         if strlen(getline(l)) > 0 && getline(l) !~ '^\s*$'
            break
         endif
         let l = l - 1
      endwhile

      "execute "normal i" . l_min . "," . l . " fold"   " print debug info

      if l > l_min
"         " Create the fold from l_min to l
         execute l_min . "," . l . " fold"
      endif
   else
      " Delete the fold on the current line
      normal zd
   endif
endfunction

nmap <space> :call ToggleFold()<CR>

syntax on
colorscheme pablo

set softtabstop=4       "makes backspacing over spaced out tabs work real nice
set expandtab           "expand tabs to spaces
set shiftwidth=4
set tabstop=4
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,default,latin1
match DiffAdd '\%>80v.*'


" remove ^M characters from windows files
map <C-M> mvggVG:s/<C-V><CR>//g<CR>`v
"
"rot13 dmca-grade encryption
"this is useful to obfuscate whatever it is that you're working on temporarily
"if someone walks by (vim pr0n?)
map <F2> mzggVGg?`z

"good tab completion - press <tab> to autocomplete if there's a character
"previously
function InsertTabWrapper()
      let col = col('.') - 1
      if !col || getline('.')[col - 1] !~ '\k'
          return "\<tab>"
      else
          return "\<c-p>"
      endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" automatically remove trailing whitespace before write
function StripTrailingWhitespace()
  normal mZ
  %s/\s\+$//e
  if line("'Z") != line(".")
    echo "Stripped whitespace\n"
  endif
  normal `Z
endfunction
autocmd BufWritePre *.cpp,*.hpp,*.i,*.py,*.js,*.html,*.php :call StripTrailingWhitespace()


if has("gui_running")
    set guioptions-=T	" desabilita barra de ferramentas
    set guioptions-=t	" desabilita tear-off
    set guioptions-=m	" desabilita menu
    set guifont=Inconsolata\ 11
    set mouse=a	 " habilita uso pleno do mouse
endif

colorscheme desert
autocmd FileType html,xhtml,xml,css,javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
