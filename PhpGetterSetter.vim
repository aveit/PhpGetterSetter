let iTotalLinhas = line('$')
let aModificadores = ['public', 'protected', 'private']
let aRegexModificadores = []

for sModificador in aModificadores

  let sRegex = '\' . sModificador . '\s\+\(static\s\+\)*$\([^ ]\).\+;'
  call add(aRegexModificadores, sRegex)
endfor

let sRegexModificadores = join(aRegexModificadores, '\|')

for iLinha in range(1, iTotalLinhas)

  let sLinha = getline(iLinha)
  if match(sLinha, sRegexModificadores, 0) >= 0

    let sStatic = ""
    if match(sLinha, 'static', 0) >= 0
      let sStatic = "static "
    endif
    let sVariable = strpart(matchstr(sLinha, '$\(\h\|\d\)\+', 0), 1)
    let sMethod  = "public " . sStatic . "function set" . toupper(strpart(sVariable, 0, 1)) . strpart(sVariable, 1)
    let sMethod .= "($" . sVariable . ") {"
    call append('$', sMethod)

    let sMethod = "\t$this->" . sVariable . " = $" . sVariable . ";"
    call append('$', sMethod)

    let sMethod = "}"
    call append('$', sMethod)

    let sMethod  = "public " . sStatic . "function get" . toupper(strpart(sVariable, 0, 1)) . strpart(sVariable, 1)
    let sMethod .= "() {"
    call append('$', sMethod)

    let sMethod = "\treturn $this->" . sVariable . ";"
    call append('$', sMethod)

    let sMethod = "}"
    call append('$', sMethod)

  endif
endfor
