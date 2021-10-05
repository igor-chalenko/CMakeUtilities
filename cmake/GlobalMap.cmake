##############################################################################
# Copyright (c) 2020 Igor Chalenko
# Distributed under the MIT license.
# See accompanying file LICENSE.md.md or copy at
# https://opensource.org/licenses/MIT
##############################################################################

##############################################################################
#.rst:
# .. cmake:command:: global_set
#
# .. code-block:: cmake
#
#    global_set(_prefix _property _value)
#
# Stores the [``_property``, ``_value``] pair in the global map ``_prefix``.
##############################################################################
function(global_set _prefix _property _value)
    global_index(${_prefix} _index)
    list(FIND _index "${_prefix}${_property}" _ind)
    set_property(GLOBAL PROPERTY "${_prefix}${_property}" ${_value})
    if (_ind EQUAL -1)
        list(APPEND _index "${_prefix}${_property}")
        global_set_index(${_prefix} "${_index}")
    endif()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: global_unset
#
# .. code-block:: cmake
#
#    global_unset(_prefix _property)
#
# Removes the property ``_property`` from the global map ``_prefix``.
##############################################################################
function(global_unset _prefix _property)
    global_index(${_prefix} _index)
    list(FIND _index "${_prefix}${_property}" _ind)
    if (NOT _ind EQUAL -1)
        set_property(GLOBAL PROPERTY "${_prefix}${_property}")
        list(REMOVE_ITEM _index "${_prefix}${_property}")
        global_set_index(${_prefix} "${_index}")
    endif()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: global_get
#
# .. code-block:: cmake
#
#    global_get(_prefix _property _out_var)
#
# Stores the value of the property ``_property`` into the parent scope's
# variable designated by ``_out_var``.
##############################################################################
function(global_get _prefix _property _out_var)
    get_property(_value GLOBAL PROPERTY ${_prefix}${_property})
    if ("${_value}" STREQUAL "_value-NOTFOUND")
        set(${_out_var} "" PARENT_SCOPE)
    else ()
        set(${_out_var} "${_value}" PARENT_SCOPE)
    endif ()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: global_get_or_fail
#
# .. code-block:: cmake
#
#    global_get_or_fail(_prefix _property _out_var)
#
# Stores the value of the property ``_property`` into the parent scope's
# variable designated by ``_out_var``.
##############################################################################
function(global_get_or_fail _prefix _property _out_var)
    global_get(${_prefix} ${_property} _value)
    if (NOT _value STREQUAL "")
        set(${_out_var} "${_value}" PARENT_SCOPE)
    else()
        message(FATAL_ERROR "The key `${_property}` is not in the global map
        `${_prefix}`.")
    endif()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: global_append
#
# .. code-block:: cmake
#
#    global_append(_prefix _property _value)
#
# If the property ``_property`` exists, it is treated as a list, and
# the value of ``_value`` is appended to it. Otherwise, the property
# ``_property`` is created and set to the given value.
##############################################################################
function(global_append _prefix _property _value)
    global_index(${_prefix} _index)
    #list(FIND _index ${_property} _ind)

    # list(APPEND ${_property} ${_values})
    global_get(${_prefix} ${_property} _current_value)
    if ("${_current_value}" STREQUAL "")
        global_set(${_prefix} ${_property} "${_value}")
    else()
        list(APPEND _current_value "${_value}")
        global_set(${_prefix} ${_property} "${_current_value}")
    endif()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: global_map_clear_scope
#
# .. code-block:: cmake
#
#    global_map_clear_scope()
#
# Clears all properties previously set by calls to ``global_map_set`` and
# ``global_map_append``.
##############################################################################
function(global_clear _prefix)
    global_index(${_prefix} _index)
    foreach(_property ${_index})
        set_property(GLOBAL PROPERTY "${_property}")
    endforeach()
    set_property(GLOBAL PROPERTY ${_prefix}property.index)
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: global_map_index
#
# .. code-block:: cmake
#
#    global_map_index(_out_var)
#
# Writes the current scope's index into the variable designated by ``_out_var``
# in the parent scope.
##############################################################################
function(global_index _prefix _out_var)
    global_get(${_prefix} property.index _index)
    set(${_out_var} "${_index}" PARENT_SCOPE)
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: global_set_index
#
# Replace the current TPA scope's index by the list given by ``_index``.
##############################################################################
function(global_set_index _prefix _index)
    set_property(GLOBAL PROPERTY ${_prefix}property.index "${_index}")
endfunction()
