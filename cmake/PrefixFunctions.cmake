function(prefix_functions _prefix)
    foreach(_fun ${ARGN})
        log_debug(prefix_functions "inject ${_prefix}_${_fun}")
        cmake_language(EVAL CODE "
macro(${_prefix}_${_fun})
    ${_fun}(${_prefix} \${ARGN})
endmacro()
")
    endforeach()
endfunction()

