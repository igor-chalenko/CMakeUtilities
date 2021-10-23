##############################################################################
# Copyright (c) 2020 Igor Chalenko
# Distributed under the MIT license.
# See accompanying file LICENSE.md.md or copy at
# https://opensource.org/licenses/MIT
##############################################################################

cmake_policy(SET CMP0011 NEW)

include(${CMAKE_CURRENT_LIST_DIR}/GlobalMap.cmake)

##############################################################################
#.rst:
# .. cmake:command:: log_message
#
# .. code-block:: cmake
#
#    log_message(_level _category _message)
#
# Formats and prints the given message. Filters out the messages based on
# the logging level of the category ``_category``, previously specified by
# a call to ``log_level``.
##############################################################################
function(log_message _level _category _message)
    _log_levels(_levels)
    list(FIND _levels ${_level} _ind)
    global_get(log.category.${_category}. level _current_level)
    global_get(log.category.${_category}. file _file_name)

    if (_current_level STREQUAL "")
        _log_parent_level(${_category} _current_level)
    endif()
    if (_file_name STREQUAL "")
        _log_parent_destination(${_category} _file_name)
    endif()

    _log_format_message(_formatted_message "${_message}" ${ARGN})
    if (NOT _current_level OR _current_level LESS_EQUAL ${_ind})
        string(TIMESTAMP _timestamp)
        if (_level STREQUAL FATAL)
            message(FATAL_ERROR "[${_timestamp}][${_category}][${_level}] ${_formatted_message}")
        elseif (_level STREQUAL ERROR)
            message(SEND_ERROR "[${_timestamp}][${_category}][${_level}] ${_formatted_message}")
        else()
            set(_message_prefix "[${_timestamp}][${_category}][${_level}]")
            if (NOT "${_file_name}" STREQUAL "")
                file(APPEND "${CMAKE_CURRENT_BINARY_DIR}/${_file_name}" "${_message_prefix} ${_formatted_message}\n")
            else()
                message("${_message_prefix} ${_formatted_message}")
            endif()
        endif()
    endif()
endfunction()

function(_log_parent_level _category _out_var)
    if(_category MATCHES "(.+)\\.(.+)")
        global_get(log.category.${CMAKE_MATCH_1}. level _level)
        if (NOT _level)
            _log_parent_level(${CMAKE_MATCH_1}  _new_out_var)
            set(${_out_var} "${_new_out_var}" PARENT_SCOPE)
        else()
            set(${_out_var} "${_level}" PARENT_SCOPE)
        endif()
    else()
        set(${_out_var} "WARN" PARENT_SCOPE)
    endif()
endfunction()

function(_log_parent_destination _category _out_var)
    if(_category MATCHES "(.+)\\.(.+)")
        global_get(log.category.${CMAKE_MATCH_1}. file _file)
        if (NOT _file)
            _log_parent_destination(${CMAKE_MATCH_1}  _new_out_var)
            set(${_out_var} "${_new_out_var}" PARENT_SCOPE)
        else()
            set(${_out_var} "${_file}" PARENT_SCOPE)
        endif()
    else()
        set(${_out_var} "" PARENT_SCOPE)
    endif()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_level
#
# .. code-block:: cmake
#
#    log_level(_category _level)
#
# All the subsequent messages in the given category ``_category`` and its
# nested categories will only be printed if their level is at least as high
# as ``_level``. The levels are defined by the function ``_log_levels``
# (the further it is from the beginning, the higher it is). The default level
# for every category is `WARN`.
##############################################################################
function(log_level _category _level)
    _log_levels(_levels)
    list(FIND _levels ${_level} _ind)
    if (_ind GREATER -1)
        global_set(log.category.${_category}. level ${_ind})
        #message(STATUS "setting log level of ${_category} to ${_ind} (${_level})")
    endif()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_to_file
#
# .. code-block:: cmake
#
#    log_to_file(_category _file_name)
#
# Redirects all subsequent logged messages in the category ``_category`` and
# its nested categories to a file ``_file_name`` instead of the console.
##############################################################################
function(log_to_file _category _file_name)
    global_set(log.category.${_category}. file ${_file_name})
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
#    log_to_console(_category)
#
# Directs all subsequent logged messages in the category ``_category`` to
# the console instead of a file, previously specified by a call to
# ``log_to_file``. Does nothing if the message redirection was not requested
# for the given category.
##############################################################################
function(log_to_console _category)
    global_unset(log.category.${_category}. file)
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_debug
#
# .. code-block:: cmake
#
#    log_debug(_category _message <message arguments>)
#
# Formats the given message and prints it either to a console or to a file.
# The messages have the following format:
# [<<timestamp>>][<<category>>][DEBUG] <<message after substitutions>>>
# This function is a wrapper around ``log_message``.
##############################################################################
function(log_debug _category _message)
    log_message(DEBUG "${_category}" "${_message}" ${ARGN})
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_trace
#
# .. code-block:: cmake
#
#    log_trace(_category _message <message arguments>)
#
# Formats the given message and prints it either to a console or to a file.
# The messages have the following format:
# [<<timestamp>>][<<category>>][TRACE] <<message after substitutions>>>
# This function is a wrapper around ``log_message``.
##############################################################################
function(log_trace _category _message)
    log_message(TRACE "${_category}" "${_message}" ${ARGN})
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_info
#
# .. code-block:: cmake
#
#    log_info(_category _message <message arguments>)
#
# Calls ``log_message`` with the level set to `INFO`.
##############################################################################
function(log_info _category _message)
    log_message(INFO "${_category}" "${_message}" ${ARGN})
endfunction()

##############################################################################
#.rst:
# .. _log_error_reference_label:
#
# .. cmake:command:: log_error
#
# .. code-block:: cmake
#
#    log_error(_category _message <message arguments>)
#
# Calls ``log_message`` with the level set to `ERROR`.
##############################################################################
function(log_error _category _message)
    log_message(ERROR "${_category}" "${_message}" ${ARGN})
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_warn
#
# .. code-block:: cmake
#
#    log_warn(_category _message <message arguments>)
#
# Calls ``log_message`` with the level set to `FATAL`.
##############################################################################
function(log_fatal _category _message)
    log_message(FATAL "${_category}" "${_message}" ${ARGN})
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: log_warn
#
# .. code-block:: cmake
#
#    log_warn(_category _message <message arguments>)
#
# Calls ``log_message`` with the level set to `WARN`.
##############################################################################
function(log_warn _category _message)
    log_message(WARN "${_category}" "${_message}" ${ARGN})
endfunction()

##############################################################################
# Returns the known log levels.
# Not a part of the public API.
##############################################################################
function(_log_levels _out_var)
    set(${_out_var} "TRACE;DEBUG;INFO;WARN;ERROR" PARENT_SCOPE)
endfunction()

##############################################################################
# Substitutes the parameters given ib `ARGN`
# Not a part of the public API.
##############################################################################
function(_log_format_message _out_message _message)
    global_get(log.category.${_category}. file _file_name)

    set(_index 2)
    foreach(_arg ${ARGN})
        math(EXPR _base_index "${_index} - 1")
        string(REPLACE "{${_base_index}}" "${ARGV${_index}}" _message "${_message}")
        math(EXPR _index "${_index} + 1")
    endforeach()
    set(${_out_message} "${_message}" PARENT_SCOPE)
endfunction()
