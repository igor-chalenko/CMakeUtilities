function(wrap _prefix)
    foreach(_fun ${ARGN})
        message(STATUS "wrapping ${_fun}")
        cmake_language(EVAL CODE "
macro(${_prefix}_${_fun})
    ${_fun}(${_prefix} \${ARGN})
endmacro()
")
    endforeach()
endfunction()

