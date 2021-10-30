##############################################################################
# Copyright (c) 2020 Igor Chalenko
# Distributed under the MIT license.
# See accompanying file LICENSE.md.md or copy at
# https://opensource.org/licenses/MIT
##############################################################################

##############################################################################
# These inspiring macros are a workaround for the CMake empty argument
# forwarding problem
# see https://crascit.com/2019/01/29/forwarding-command-arguments-in-cmake/
##############################################################################

macro(var_arg_call_0 _fun)
    cmake_language(EVAL CODE "${_fun}()")
endmacro()

macro(var_arg_call_1 _fun _arg1)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\")")
endmacro()

macro(var_arg_call_2 _fun _arg1 _arg2)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\")")
endmacro()

macro(var_arg_call_3 _fun _arg1 _arg2 _arg3)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\" \"${_arg3}\")")
endmacro()

macro(var_arg_call_4 _fun _arg1 _arg2 _arg3 _arg4)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\" \"${_arg3}\" \"${_arg4}\")")
endmacro()

macro(var_arg_call_5 _fun _arg1 _arg2 _arg3 _arg4 _arg5)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\" \"${_arg3}\" \"${_arg4}\" \"${_arg5}\")")
endmacro()

macro(var_arg_call_6 _fun _arg1 _arg2 _arg3 _arg4 _arg5 _arg6)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\" \"${_arg3}\" \"${_arg4}\" \"${_arg5}\" \"${_arg6}\")")
endmacro()

macro(var_arg_call_7 _fun _arg1 _arg2 _arg3 _arg4 _arg5 _arg6 _arg7)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\" \"${_arg3}\"
                                      \"${_arg4}\" \"${_arg5}\" \"${_arg6}\"
                                      \"${_arg7}\")")
endmacro()

macro(var_arg_call_8 _fun _arg1 _arg2 _arg3 _arg4 _arg5 _arg6 _arg7 _arg8)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\" \"${_arg3}\"
                                      \"${_arg4}\" \"${_arg5}\" \"${_arg6}\"
                                      \"${_arg7}\" \"${_arg8}\")")
endmacro()

macro(var_arg_call_9
        _fun
        _arg1
        _arg2
        _arg3
        _arg4
        _arg5
        _arg6
        _arg7
        _arg8
        _arg9)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\" \"${_arg3}\"
                                      \"${_arg4}\" \"${_arg5}\" \"${_arg6}\"
                                      \"${_arg7}\" \"${_arg8}\" \"${_arg9}\")")
endmacro()

macro(var_arg_call_10 _fun
        _arg1
        _arg2
        _arg3
        _arg4
        _arg5
        _arg6
        _arg7
        _arg8
        _arg9
        _arg10)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\" \"${_arg3}\"
                                      \"${_arg4}\" \"${_arg5}\" \"${_arg6}\"
                                      \"${_arg7}\" \"${_arg8}\" \"${_arg9}\"
                                      \"${_arg10}\")")
endmacro()

macro(var_arg_call_11 _fun
        _arg1
        _arg2
        _arg3
        _arg4
        _arg5
        _arg6
        _arg7
        _arg8
        _arg9
        _arg10
        _arg11)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\" \"${_arg3}\"
                                      \"${_arg4}\" \"${_arg5}\" \"${_arg6}\"
                                      \"${_arg7}\" \"${_arg8}\" \"${_arg9}\"
                                      \"${_arg10}\" \"${_arg11}\")")
endmacro()

macro(var_arg_call_12 _fun
        _arg1
        _arg2
        _arg3
        _arg4
        _arg5
        _arg6
        _arg7
        _arg8
        _arg9
        _arg10
        _arg11
        _arg12)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\" \"${_arg3}\"
                                      \"${_arg4}\" \"${_arg5}\" \"${_arg6}\"
                                      \"${_arg7}\" \"${_arg8}\" \"${_arg9}\"
                                      \"${_arg10}\" \"${_arg11}\" \"${_arg12}\")")
endmacro()

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
# does nothing but calls `fn` with the arguments given to `${_prefix}_${fn}`.
#
# .. note::
#    Since the argument count changes, the logic that depends on `ARGN`, `ARGC`
#    and similar values, may break. Be careful when wrapping a function that
#    depends on exact argument count and order.
#
##############################################################################
function(parameter_to_function_prefix _prefix)
    foreach(_fun ${ARGN})
        log_debug(parameter_to_function_prefix "inject ${_prefix}_${_fun}")
        cmake_language(EVAL CODE "
macro(${_prefix}_${_fun})
    _materialize_argn(_argn \"\${ARGN}\")
    math(EXPR _arg_count \"\${ARGC} + 1\")
    log_trace(parameter_to_function_prefix \"ARGN = \${ARGN}\")
    log_trace(parameter_to_function_prefix \"argn = \${_argn}\")
    log_trace(parameter_to_function_prefix \"calling var_arg_call_\${_arg_count}(${_fun} ${_prefix} \${_argn})\")
    cmake_language(EVAL CODE \"var_arg_call_\${_arg_count}(${_fun} ${_prefix} \${_argn})\")
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
# the original function with the unchanged arguments. For example:
#
# .. code-block:: cmake
#
#    trace_functions(global_set)
#    log_level(global_set TRACE)
#    log_to_file(global_set global_set.log)
#    # will append 'global_set(a bcd)' to 'global_set.log'
#    # before calling 'global_set'
#    _trace_global_set(a bcd)
#
##############################################################################
function(trace_functions)
    foreach(_fun ${ARGN})
        log_trace(trace_functions "inject _trace_${_fun}")
        cmake_language(EVAL CODE "
macro(_trace_${_fun})
    set(_args \"\")
    foreach(_arg \${ARGN})
        string(APPEND _args \" \\\"\${_arg}\\\"\")
    endforeach()
    string(SUBSTRING \"\${_args}\" 1 -1 _args)
    log_trace(${_fun} \"${_fun}(\${_args})\")
    if (\${ARGC} EQUAL 0)
        var_arg_call_0(\"${_fun}\")
    elseif (\${ARGC} EQUAL 1)
        var_arg_call_1(\"${_fun}\" \"\${ARGV0}\")
    elseif (\${ARGC} EQUAL 2)
        var_arg_call_2(
            \"${_fun}\"
            \"\${ARGV0}\"
            \"\${ARGV1}\")
    elseif (\${ARGC} EQUAL 3)
        var_arg_call_3(
            \"${_fun}\"
            \"\${ARGV0}\"
            \"\${ARGV1}\"
            \"\${ARGV2}\")
    elseif (\${ARGC} EQUAL 4)
        var_arg_call_4(
            \"${_fun}\"
            \"\${ARGV0}\"
            \"\${ARGV1}\"
            \"\${ARGV2}\"
            \"\${ARGV3}\")
    elseif (\${ARGC} EQUAL 5)
        var_arg_call_5(
            \"${_fun}\"
            \"\${ARGV0}\"
            \"\${ARGV1}\"
            \"\${ARGV2}\"
            \"\${ARGV3}\"
            \"\${ARGV4}\")
    elseif (\${ARGC} EQUAL 6)
        var_arg_call_6(
            \"${_fun}\"
            \"\${ARGV0}\"
            \"\${ARGV1}\"
            \"\${ARGV2}\"
            \"\${ARGV3}\"
            \"\${ARGV4}\"
            \"\${ARGV5}\")
    else()
        message(FATAL_ERROR \"todo\")
    endif()
endmacro()
")
    endforeach()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: dynamic_call
#
# .. code-block:: cmake
#
#    dynamic_call(<function> <argument list>)
#
# Calls the given function with the given arguments. For example:
#
# .. code-block:: cmake
#
#    log_level(dynamic_call TRACE)
#    log_to_file(dynamic_call dynamic_call.log)
#    dynamic_call(${function_name} ${ARGN})
#    # will append 'global_set(a bcd)' to 'global_set.log'
#    # before calling 'global_set'
#    _trace_global_set(a bcd)
#
##############################################################################
macro(dynamic_call _fun)
    unset(_code)
    set(_ind 0)
    math(EXPR _var_arg_count "${ARGC} - 1")
    _materialize_argn(_code "${ARGN}")
    log_trace(dynamic_call "${_fun}(${_code})")
    cmake_language(EVAL CODE "var_arg_call_${_var_arg_count}(${_fun} ${_code})")
endmacro()

function(_materialize_argn _out_var x)
    set(_ind 1)
    unset(_code)
    foreach(_arg IN LISTS x)
        string(REPLACE "\"" "\\\"" _arg "${_arg}")
        string(APPEND _code "\"${_arg}\" ")
    endforeach()

    set(${_out_var} "${_code}" PARENT_SCOPE)
endfunction()
