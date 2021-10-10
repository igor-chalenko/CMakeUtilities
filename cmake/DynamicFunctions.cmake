##############################################################################
# Copyright (c) 2020 Igor Chalenko
# Distributed under the MIT license.
# See accompanying file LICENSE.md.md or copy at
# https://opensource.org/licenses/MIT
##############################################################################

cmake_policy(SET CMP0054 NEW)

macro(parameter_to_function_prefix_0 _fun _prefix)
    cmake_language(EVAL CODE "${_fun}(${_prefix})")
endmacro()

macro(parameter_to_function_prefix_1 _fun _prefix _arg1)
    cmake_language(EVAL CODE "${_fun}(${_prefix} \"${_arg1}\")")
endmacro()

macro(parameter_to_function_prefix_2 _fun _prefix _arg1 _arg2)
    cmake_language(EVAL CODE "${_fun}(${_prefix} \"${_arg1}\" \"${_arg2}\")")
endmacro()

macro(parameter_to_function_prefix_3 _fun _prefix _arg1 _arg2 _arg3)
    cmake_language(EVAL CODE "${_fun}(${_prefix} \"${_arg1}\" \"${_arg2}\" \"${_arg3}\")")
endmacro()

macro(parameter_to_function_prefix_4 _fun _prefix _arg1 _arg2 _arg3 _arg4)
    cmake_language(EVAL CODE "${_fun}(${_prefix} \"${_arg1}\" \"${_arg2}\" \"${_arg3}\" \"${_arg4}\")")
endmacro()

macro(parameter_to_function_prefix_4 _fun _prefix _arg1 _arg2 _arg3 _arg4 _arg5)
    cmake_language(EVAL CODE "${_fun}(${_prefix} \"${_arg1}\" \"${_arg2}\" \"${_arg3}\" \"${_arg4}\" \"${_arg5}\")")
endmacro()

macro(trace_functions_0 _fun)
    cmake_language(EVAL CODE "${_fun}()")
endmacro()

macro(trace_functions_1 _fun _arg1)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\")")
endmacro()

macro(trace_functions_2 _fun _arg1 _arg2)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\")")
endmacro()

macro(trace_functions_3 _fun _arg1 _arg2 _arg3)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\" \"${_arg3}\")")
endmacro()

macro(trace_functions_4 _fun _arg1 _arg2 _arg3 _arg4)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\" \"${_arg3}\" \"${_arg4}\")")
endmacro()

macro(trace_functions_4 _fun _arg1 _arg2 _arg3 _arg4 _arg5)
    cmake_language(EVAL CODE "${_fun}(\"${_arg1}\" \"${_arg2}\" \"${_arg3}\" \"${_arg4}\" \"${_arg5}\")")
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
    if (\${ARGC} EQUAL 0)
        parameter_to_function_prefix_0(\"${_fun}\" \"${_prefix}\")
    elseif (\${ARGC} EQUAL 1)
        parameter_to_function_prefix_1(\"${_fun}\" \"${_prefix}\" \"\${ARGV0}\")
    elseif (\${ARGC} EQUAL 2)
        parameter_to_function_prefix_2(
            \"${_fun}\"
            \"${_prefix}\"
            \"\${ARGV0}\"
            \"\${ARGV1}\")
    elseif (\${ARGC} EQUAL 3)
        parameter_to_function_prefix_3(
            \"${_fun}\"
            \"${_prefix}\"
            \"\${ARGV0}\"
            \"\${ARGV1}\"
            \"\${ARGV2}\")
    elseif (\${ARGC} EQUAL 4)
        parameter_to_function_prefix_4(
            \"${_fun}\"
            \"${_prefix}\"
            \"\${ARGV0}\"
            \"\${ARGV1}\"
            \"\${ARGV2}\"
            \"\${ARGV3}\")
    elseif (\${ARGC} EQUAL 5)
        parameter_to_function_prefix_5(
            \"${_fun}\"
            \"${_prefix}\"
            \"\${ARGV0}\"
            \"\${ARGV1}\"
            \"\${ARGV2}\"
            \"\${ARGV3}\"
            \"\${ARGV4}\")
    else()
        message(FATAL_ERROR \"todo\")
    endif()
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
        log_debug(trace_functions "inject _trace_${_fun}")
        cmake_language(EVAL CODE "
macro(_trace_${_fun})
    set(_args \"\")
    foreach(_arg \${ARGN})
        string(APPEND _args \" \\\"\${_arg}\\\"\")
    endforeach()
    string(SUBSTRING \"\${_args}\" 1 -1 _args)
    log_trace(${_fun} \"${_fun}(\${_args})\")
    if (\${ARGC} EQUAL 0)
        trace_functions_0(\"${_fun}\")
    elseif (\${ARGC} EQUAL 1)
        trace_functions_1(\"${_fun}\" \"\${ARGV0}\")
    elseif (\${ARGC} EQUAL 2)
        trace_functions_2(
            \"${_fun}\"
            \"\${ARGV0}\"
            \"\${ARGV1}\")
    elseif (\${ARGC} EQUAL 3)
        trace_functions_3(
            \"${_fun}\"
            \"\${ARGV0}\"
            \"\${ARGV1}\"
            \"\${ARGV2}\")
    elseif (\${ARGC} EQUAL 4)
        trace_functions_4(
            \"${_fun}\"
            \"\${ARGV0}\"
            \"\${ARGV1}\"
            \"\${ARGV2}\"
            \"\${ARGV3}\")
    elseif (\${ARGC} EQUAL 5)
        trace_functions_5(
            \"${_fun}\"
            \"\${ARGV0}\"
            \"\${ARGV1}\"
            \"\${ARGV2}\"
            \"\${ARGV3}\"
            \"\${ARGV4}\")
    else()
        message(FATAL_ERROR \"todo\")
    endif()
endmacro()
")
    endforeach()
endfunction()

macro(dynamic_call _fun)
    cmake_language(EVAL CODE "
    if (${ARGC} EQUAL 1)
        ${_fun}()
    elseif (${ARGC} EQUAL 2)
        ${_fun}(\"${ARGV1}\")
    elseif (${ARGC} EQUAL 3)
        ${_fun}(\"${ARGV1}\" \"${ARGV2}\")
    elseif (${ARGC} EQUAL 4)
        ${_fun}(\"${ARGV1}\" \"${ARGV2}\" \"${ARGV3}\")
    elseif (${ARGC} EQUAL 5)
        ${_fun}(\"${ARGV1}\" \"${ARGV2}\" \"${ARGV3}\" \"${ARGV4}\")
    else()
        message(FATAL_ERROR \"todo\")
    endif()
")
endmacro()

