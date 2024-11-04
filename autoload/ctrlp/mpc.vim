if exists('g:loaded_ctrlp_mpc') && g:loaded_ctrlp_mpc
  finish
endif
let g:loaded_ctrlp_mpc = 1

let s:mpc_var = {
\  'init':   'ctrlp#mpc#init()',
\  'exit':   'ctrlp#mpc#exit()',
\  'accept': 'ctrlp#mpc#accept',
\  'lname':  'mpc',
\  'sname':  'mpc',
\  'type':   'path',
\  'sort':   0,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:mpc_var)
else
  let g:ctrlp_ext_vars = [s:mpc_var]
endif

function! ctrlp#mpc#init() abort
  let s:list = split(system("mpc playlist"), "\n")
  let s:list = map(range(len(s:list)), "printf('%04d %s', v:val+1, s:list[v:val])")
  return copy(s:list)
endfunc

function! ctrlp#mpc#accept(mode, str) abort
  let l:id = str2nr(a:str, 10)
  call ctrlp#exit()
  let l:results = split(system(printf("mpc play %s", l:id)), '\n')
  let l:message = '[mpc] NOW PLAYING: ' . ' ♫' . trim(results[0])
  highlight default mpcEchoMsg cterm=bold gui=bold guifg=#5fd7ff ctermfg=lightblue
  redraw
  echohl mpcEchoMsg
  echom l:message
  echohl NONE
endfunction

function! ctrlp#mpc#exit() abort
  if exists('s:list')
    unlet! s:list
  endif
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#mpc#id() abort
  return s:id
endfunction

function! ctrlp#mpc#toggle() abort
  call system('mpc toggle')
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2
