##############################################################################
#.rst:
# .. cmake:command:: parameter_to_function_prefix
#
# .. code-block:: cmake
#
#    parameter_to_function_prefix(<function list>>)
#
# For each given function `fn`, creates a counterpart `${_prefix}_${fn}` that
# has all the parameters of the original function except the first one, and
# does nothing but calls `fn` with the given arguments.
#
# .. note::
# Since the argument count changes, the logic that depends on `ARGN`, `ARGC`
# and other values that are different in the wrapper function compared to
# the original, may change.
#
##############################################################################
function(parameter_to_function_prefix _prefix)
    foreach(_fun ${ARGN})
        log_debug(parameter_to_function_prefix "inject ${_prefix}_${_fun}")
        cmake_language(EVAL CODE "
macro(${_prefix}_${_fun})
    ${_fun}(${_prefix} \${ARGN})
endmacro()
")
    endforeach()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: trace_functions
#
# .. code-block:: cmake
#
#    trace_functions(<function list>>)
#
# For each given function `fn`, creates a counterpart `_trace_fn` that prints
# a trace message `called fn(${ARGN})` into the log context `fn` and then calls
# the original function with unchanged arguments. For example:
#
# .. code-block:: cmake
#
#    trace_functions(global_set)
#    log_level(global_set TRACE)
#    log_to_file(global_set global_set.log)
#    # will append 'called global_set(a bcd)' to 'global_set.log'
#    # before calling 'global_set'
#    _trace_global_set(a bcd)
#
##############################################################################
function(trace_functions)
    foreach(_fun ${ARGN})
        log_debug(trace_functions "inject _trace_${_fun}")
        cmake_language(EVAL CODE "
macro(_trace_${_fun})
    set(_args \"\")
    foreach(_arg \${ARGN})
        string(APPEND _args \" \${_arg}\")
    endforeach()
    string(SUBSTRING \"\${_args}\" 1 -1 _args)
    log_trace(${_fun} \"called ${_fun}(\${_args})\")
    ${_fun}(${_fun} \${ARGN})
endmacro()
")
    endforeach()
endfunction()

