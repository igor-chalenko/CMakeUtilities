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
#    global_set(map_name property value)
#
# Stores the [``property``, ``value``] pair in the global map ``map_name``.
# The value can be retrieved later using :ref:`global_get_reference_label`.
##############################################################################
function(global_set map_name property value)
    _global_index(${map_name} _index)
    list(FIND _index "${map_name}${property}" _ind)
    set_property(GLOBAL PROPERTY "${map_name}${property}" ${value})
    if (_ind EQUAL -1)
        list(APPEND _index "${map_name}${property}")
        _global_set_index(${map_name} "${_index}")
    endif()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: global_set_if_empty
#
# .. code-block:: cmake
#
#    global_set_if_empty(map_name property value)
#
# If the global map ``map_name`` does not contain the key ``property``,
# stores the [``property``, ``value``] pair in that map. Otherwise,
# raises an error (`SEND_ERROR`) without updating the map.
##############################################################################
function(global_set_if_empty map_name property value)
    _global_index(${map_name} _index)
    list(FIND _index "${map_name}${property}" _ind)
    if (_ind EQUAL -1)
        set_property(GLOBAL PROPERTY "${map_name}${property}" ${value})
        list(APPEND _index "${map_name}${property}")
        _global_set_index(${map_name} "${_index}")
    else()
        message(SEND_ERROR "The property ${map_name}${property} already exists,
                will not update it")
    endif()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: global_unset
#
# .. code-block:: cmake
#
#    global_unset(map_name property)
#
# Removes the property ``property`` from the global map ``map_name``.
##############################################################################
function(global_unset map_name property)
    _global_index(${map_name} _index)
    list(FIND _index "${map_name}${property}" _ind)
    if (NOT _ind EQUAL -1)
        set_property(GLOBAL PROPERTY "${map_name}${property}")
        list(REMOVE_ITEM _index "${map_name}${property}")
        _global_set_index(${map_name} "${_index}")
    endif()
endfunction()

##############################################################################
#.rst:
# .. _global_get_reference_label:
#
# .. cmake:command:: global_get
#
# .. code-block:: cmake
#
#    global_get(map_name property out_var)
#
# Stores the value of the property ``property`` into the output variable
# designated by ``out_var``. If the requested property is not found,
# sets ``out_var`` to an empty string.
##############################################################################
function(global_get map_name property out_var)
    get_property(value GLOBAL PROPERTY ${map_name}${property})
    if ("${value}" STREQUAL "value-NOTFOUND")
        set(${out_var} "" PARENT_SCOPE)
    else ()
        set(${out_var} "${value}" PARENT_SCOPE)
    endif ()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: global_get_or_fail
#
# .. code-block:: cmake
#
#    global_get_or_fail(map_name property out_var)
#
# Searches the property ``property`` in the given global map ``map_name``.
# If found, the output variable ``out_var`` is updated to store
# the property's value. Otherwise, fatal error is raised.
##############################################################################
function(global_get_or_fail map_name property out_var)
    global_get(${map_name} ${property} value)
    if (NOT value STREQUAL "")
        set(${out_var} "${value}" PARENT_SCOPE)
    else()
        message(FATAL_ERROR "The key `${property}` is not in the global map
        `${map_name}`.")
    endif()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: global_append
#
# .. code-block:: cmake
#
#    global_append(map_name property value)
#
# If the property ``property`` exists, it is treated as a list, and
# the value of ``value`` is appended to it. Otherwise, the property
# ``property`` is created and set to the given value.
##############################################################################
function(global_append map_name property value)
    _global_index(${map_name} _index)

    global_get(${map_name} ${property} _current_value)
    if ("${_current_value}" STREQUAL "")
        global_set(${map_name} ${property} "${value}")
    else()
        list(APPEND _current_value "${value}")
        global_set(${map_name} ${property} "${_current_value}")
    endif()
endfunction()

##############################################################################
#.rst:
# .. cmake:command:: global_clear
#
# .. code-block:: cmake
#
#    global_clear(map_name)
#
# Clears all the properties previously set in the global map ``map_name`` by
# the calls to ``global_set`` and ``global_append``.
##############################################################################
function(global_clear map_name)
    _global_index(${map_name} _index)
    foreach(property ${_index})
        set_property(GLOBAL PROPERTY "${property}")
    endforeach()
    set_property(GLOBAL PROPERTY ${map_name}property.index)
endfunction()

##############################################################################
# Sets the output variable ``out_var`` to store the index of the global map
# ``map_name``. Not a part of the public API.
##############################################################################
function(_global_index map_name out_var)
    global_get(${map_name} property.index _index)
    set(${out_var} "${_index}" PARENT_SCOPE)
endfunction()

##############################################################################
# Replaces the index of the global map ``map_name`` by the list ``_index``.
# Not a part of the public API.
##############################################################################
function(_global_set_index map_name _index)
    set_property(GLOBAL PROPERTY ${map_name}property.index "${_index}")
endfunction()
