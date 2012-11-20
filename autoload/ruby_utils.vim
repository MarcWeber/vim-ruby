" if has('ruby') use built in interpreter else use ruby executable to verify
" that those ruby libraries can be loaded.
"
" usage example: vim_addon_ruby#CheckRubyLibsPresent(["rdebug"])
" returns: 1 on sucess
"          throws message on failure
fun! ruby_utils#CheckRubyLibsPresent(libs)
  let msg = 'throw "ruby_utils#CheckRubyLibsPresent: these ruby modules are required: ".string(a:libs)."\n".extra'
  let extra = ''

  " ruby of Vim doesnt' support gems (?) TODO
  if 0 && has('ruby')
    try
      for m in a:libs
        exec "ruby require '".m."'"
      endfor
    catch /.*/
      exec msg
    endtry
  else
    let input = join(map(copy(a:libs),string("require ").'.string(v:val)'),"\n")
    let extra = system('ruby 2>&1', input)
    if v:shell_error != 0 | exec msg | endif
  endif
  return 1
endf

" all .rb files found in $RUBYLIB
fun! ruby_utils#RubyModules()
  let l = []
  for d in split($RUBYLIB,":")
    call extend(l, map(split(glob(d.'/**/*.rb'),"\n"),'v:val[len(d)+1:]'))
  endfor
  return l
endf

fun! s:Select(label, list)
  return tlib#input#List("s", a:label, a:list)
endf

" now you can map it like this:
" inoremap <m-r><m-e> <c-r>='require "'.ruby_utils#InsertRequire('require').'"'<cr>
" inoremap <m-r><m-r> <c-r>='require_rel "'.ruby_utils#InsertRequire('require_rel').'"'<cr>
fun! ruby_utils#InsertRequire(type)
  if a:type == "require"
    return substitute(s:Select('choose req file: ', ruby_utils#RubyModules()), '\.rb$', '', '')
  endif
  if a:type == "require_rel"
    return substitute(s:Select('choose req file: ', split(glob(expand('%:h').'/**/*.rb'),"\n")), '\%(^\.[/\\]\)\?\(.*\)\.rb$', '\1', '')
  endif
endf

fun! ruby_utils#RequireLocations()
  let list = []
  " require
  let thing = matchstr(getline('.'), "require\\s\\+['\"]\\zs[^'\"]\\+\\ze['\"]")
  if thing != ""

    for d in split($RUBYLIB,":")
      let f = d.'/'.thing.'.rb'
      call add(list, { 'filename' : f, 'break' : filereadable(f)})
    endfor

  endif

  " require_rel
  let thing = matchstr(getline('.'), "require_relative\s\\+['\"]\\zs[^'\"]\\+\\ze['\"]")

  if thing != "" && filereadable(thing[2:])
    call add(list, { 'filename' : expand('%:h').'/'.thing.'.rb', 'break' : 1 })
  endif

  return list
endf
