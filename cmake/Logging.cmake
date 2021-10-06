##############################################################################
# Copyright (c) 2020 Igor Chalenko
# Distributed under the MIT license.
# See accompanying file LICENSE.md.md or copy at
# https://opensource.org/licenses/MIT
##############################################################################

cmake_policy(SET CMP0011 NEW)

include(${CMAKE_CURRENT_LIST_DIR}/GlobalMap.cmake)

string(ASCII 27 Esc)
set(Red         "")
set(ColourReset "")
set(Green       "")
set(Yellow      "")
set(Blue        "")
set(Magenta     "")
set(Cyan        "")
set(White       "")

if (CMAKE_COLORIZED_OUTPUT AND UNIX)
    execute_process(COMMAND tput colors OUTPUT_VARIABLE _colours OUTPUT_STRIP_TRAILING_WHITESPACE)
    if (_colours)
        set(Green       "${Esc}[32m")
        set(Yellow      "${Esc}[33m")
        set(Blue        "${Esc}[34m")
        set(Magenta     "${Esc}[35m")
        set(Cyan        "${Esc}[36m")
        set(White       "${Esc}[37m")
        set(ColourReset "${Esc}[m")
        if (_colours EQUAL 256)
            # set red color
            execute_process(COMMAND tput setaf 202 OUTPUT_VARIABLE Red OUTPUT_STRIP_TRAILING_WHITESPACE)
        elseif(_colours EQUAL 16)
            set(Red         "${Esc}[31m")
        endif()
    endif()
    if (VERBOSE)
        if (_colours)
            message(STATUS "This terminal supports ${_colours} colours")
        else()
            message(STATUS "Assuming no support for coloured output on this terminal")
        endif()
    endif()
endif()

function(_log_levels _out_var)
    set(${_out_var} "TRACE;DEBUG;INFO;WARN;ERROR" PARENT_SCOPE)
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_color
#
# .. code-block:: cmake
#
#    log_color(_level)
#
# Specifies a color of the subsequent messages of the level ``_level``.
##############################################################################
function(log_color _level _color)
    global_set(log.color. ${_level} ${_color})
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_parameter_color
#
# .. code-block:: cmake
#
#    log_parameter_color(_level)
#
# Specifies a color of the parameters of the subsequent messages of the level
# ``_level``.
##############################################################################
function(log_parameter_color _level _color)
    global_set(log.parameter.color. ${_level} ${_color})
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_color_reset
#
# .. code-block:: cmake
#
#    log_color_reset(_level)
#
# Removes color setting for the messages of the level ``_level``.
##############################################################################
function(log_color_reset _level)
    global_unset(log.color. ${_level})
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_color_reset
#
# .. code-block:: cmake
#
#    log_color_reset(_level)
#
# Removes color setting for the parameters of the messages of the level
# ``_level``.
##############################################################################
function(log_parameter_color_reset _level)
    global_unset(log.parameter.color. ${_level})
endfunction()

function(_log_format_message _out_message _message)
    global_get(log.context.${_context}. file _file_name)

    if ("${_file_name}" STREQUAL "")
        global_get(log.color. ${_level} _color)
        global_get(log.parameter.color. ${_level} _parameter_color)
    else()
        set(_color "")
        set(_parameter_color "")
    endif()

    set(_index 2)
    foreach(_arg ${ARGN})
        math(EXPR _base_index "${_index} - 1")
        if (_parameter_color)
            message(STATUS "_parameter_color = ${_parameter_color}, _color = ${_color}")
            string(REPLACE "{${_base_index}}" "${${_parameter_color}}${ARGV${_index}}${ColourReset}${${_color}}" _message "${_message}")
        else()
            string(REPLACE "{${_base_index}}" "${ARGV${_index}}" _message "${_message}")
        endif()
        math(EXPR _index "${_index} + 1")
    endforeach()
    if (_color)
        set(_message "${${_color}}${_message}${ColourReset}")
    endif()
    set(${_out_message} "${_message}" PARENT_SCOPE)
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_message
#
# .. code-block:: cmake
#
#    log_message(_level _context _message)
#
# Formats and prints the given message. Filters out the messages based on
# the logging level of the context ``_context``, previously specified by
# a call to ``log_level``.
##############################################################################
function(log_message _level _context _message)
    _log_levels(_levels)
    list(FIND _levels ${_level} _ind)
    global_get(log.context.${_context}. level _current_level)
    global_get(log.context.${_context}. file _file_name)

    if (_current_level STREQUAL "")
        list(FIND _levels INFO _current_level)
    endif()

    _log_format_message(_formatted_message "${_message}" ${ARGN})
    if (NOT _current_level OR _current_level LESS_EQUAL ${_ind})
        string(TIMESTAMP _timestamp)
        if (_level STREQUAL FATAL)
            message(FATAL_ERROR "[${_timestamp}][${_context}][${_level}] ${_formatted_message}")
        elseif (_level STREQUAL ERROR)
            message(SEND_ERROR "[${_timestamp}][${_context}][${_level}] ${_formatted_message}")
        else()
            set(_message_prefix "[${_timestamp}][${_context}][${_level}]")
            if (NOT "${_file_name}" STREQUAL "")
                file(APPEND "${CMAKE_CURRENT_BINARY_DIR}/${_file_name}" "${_message_prefix} ${_formatted_message}\n")
            else()
                message("${_message_prefix} ${_formatted_message}")
            endif()
        endif()
    endif()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_level
#
# .. code-block:: cmake
#
#    log_level(_context _level)
#
# All the subsequent messages in the given context ``_context`` will only
# be printed if their level is at least as high as ``_level``. The levels
# are defined by the function ``_log_levels`` (the further it is from
# the beginning, the higher it is). The default level for every context is
# `INFO`.
##############################################################################
function(log_level _context _level)
    _log_levels(_levels)
    list(FIND _levels ${_level} _ind)
    if (_ind GREATER -1)
        global_set(log.context.${_context}. level ${_ind})
        #message(STATUS "setting log level of ${_context} to ${_ind} (${_level})")
    endif()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_to_file
#
# .. code-block:: cmake
#
#    log_to_file(_context _file_name)
#
# Directs all subsequent logged messages in the context ``_context`` to a file
# ``_file_name`` instead of the console.
##############################################################################
function(log_to_file _context _file_name)
    global_set(log.context.${_context}. file ${_file_name})
    if (NOT ARGN)
        file(REMOVE ${CMAKE_CURRENT_BINARY_DIR}/${_file_name})
    endif()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_to_console
#
# .. code-block:: cmake
#
#    log_to_console(_context)
#
# Directs all subsequent logged messages in the context ``_context`` to
# the console instead of a file, previously specified by a call to
# ``log_to_file``. Does nothing if the message redirection was not requested
# for the given context.
##############################################################################
function(log_to_console _context)
    global_unset(log.context.${_context}. file)
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_debug
#
# .. code-block:: cmake
#
#    log_debug(_context _message <message arguments>)
#
# Formats the given message and prints it either to a console or to a file.
# The messages have the following format:
# [<<timestamp>>][<<context>>][DEBUG] <<message after substitutions>>>
# This function is a wrapper around ``log_message``.
##############################################################################
function(log_debug _context _message)
    log_message(DEBUG "${_context}" "${_message}" ${ARGN})
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_trace
#
# .. code-block:: cmake
#
#    log_trace(_context _message <message arguments>)
#
# Formats the given message and prints it either to a console or to a file.
# The messages have the following format:
# [<<timestamp>>][<<context>>][TRACE] <<message after substitutions>>>
# This function is a wrapper around ``log_message``.
##############################################################################
function(log_trace _context _message)
    log_message(TRACE "${_context}" "${_message}" ${ARGN})
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_info
#
# .. code-block:: cmake
#
#    log_info(_context _message <message arguments>)
#
# Formats the given message and prints it either to a console or to a file.
# The messages have the following format:
# [<<timestamp>>][<<context>>][INFO] <<message after substitutions>>>
# This function is a wrapper around ``log_message``.
##############################################################################
function(log_info _context _message)
    log_message(INFO "${_context}" "${_message}" ${ARGN})
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_error
#
# .. code-block:: cmake
#
#    log_error(_context _message <message arguments>)
#
# Formats the given message and prints it either to a console or to a file.
# Then, raises a CMake error via `message(SEND_ERROR)`.
# The messages have the following format:
# [<<timestamp>>][<<context>>][ERROR] <<message after substitutions>>>
# This function is a wrapper around ``log_message``.
##############################################################################
function(log_error _context _message)
    log_message(ERROR "${_context}" "${_message}" ${ARGN})
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_warn
#
# .. code-block:: cmake
#
#    log_warn(_context _message <message arguments>)
#
# Formats the given message and prints it either to a console or to a file.
# Then, raises a CMake error via `message(FATAL_ERROR)`.
# The messages have the following format:
# [<<timestamp>>][<<context>>][FATAL] <<message after substitutions>>>
# This function is a wrapper around ``log_message``.
##############################################################################
function(log_fatal _context _message)
    log_message(FATAL "${_context}" "${_message}" ${ARGN})
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_warn
#
# .. code-block:: cmake
#
#    log_warn(_context _message <message arguments>)
#
# Calls ``log_message`` with the level set to `WARN`.
##############################################################################
function(log_warn _context _message)
    log_message(WARN "${_context}" "${_message}" ${ARGN})
endfunction()