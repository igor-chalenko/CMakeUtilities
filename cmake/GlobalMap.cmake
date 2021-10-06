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
# .. cmake:command:: global_set_if_empty
#
# .. code-block:: cmake
#
#    global_set_if_empty(_prefix _property _value)
#
# If the global map ``_prefix`` does not contain the key ``_property``,
# stores the [``_property``, ``_value``] pair in that map. Otherwise,
# issues a warning without updating the map.
##############################################################################
function(global_set_if_empty _prefix _property _value)
    global_index(${_prefix} _index)
    list(FIND _index "${_prefix}${_property}" _ind)
    if (_ind EQUAL -1)
        set_property(GLOBAL PROPERTY "${_prefix}${_property}" ${_value})
        list(APPEND _index "${_prefix}${_property}")
        global_set_index(${_prefix} "${_index}")
    else()
        message(WARNING "The property ${_prefix}${_property} already exists,
                will not update it")
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
# Stores the value of the property ``_property`` into the output variable
# designated by ``_out_var``.
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
# Searches the property ``_property`` in the given global map ``_prefix``.
# If found, the output variable ``_out_var`` is updated to store
# the property's value. Otherwise, fatal error is raised.
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
# .. cmake:command:: global_clear
#
# .. code-block:: cmake
#
#    global_clear(_prefix)
#
# Clears all the properties previously set in the global map ``_prefix`` by
# the calls to ``global_set`` and ``global_append``.
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
# .. cmake:command:: global_index
#
# .. code-block:: cmake
#
#    global_index(_prefix _out_var)
#
# Sets the output variable ``_out_var`` to store the index of the global map
# ``_prefix``.
##############################################################################
function(global_index _prefix _out_var)
    global_get(${_prefix} property.index _index)
    set(${_out_var} "${_index}" PARENT_SCOPE)
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: global_set_index
#
# .. code-block:: cmake
#
#    global_set_index(_prefix _index)
#
# Replaces the index of the global map ``_prefix`` by the list ``_index``.
##############################################################################
function(global_set_index _prefix _index)
    set_property(GLOBAL PROPERTY ${_prefix}property.index "${_index}")
endfunction()
