include(${CMAKE_CURRENT_LIST_DIR}/Logging.cmake)

##############################################################################
#.rst:
#
# .. cmake:command:: assert_not_empty
#
# .. code-block:: cmake
#
#    assert_not_empty(value)
#
# If the string given by ``value`` is empty, emits an error message.
# Does nothing otherwise.
##############################################################################
macro(assert_not_empty value)
    if ("${value}" STREQUAL "")
        log_error(test "Expected non-empty variable.")
    endif()
endmacro()

##############################################################################
#.rst:
#
# .. cmake:command:: assert_empty
#
# .. code-block:: cmake
#
#    assert_empty(value)
#
# If the string given by ``value`` is not empty, emits an error message.
# Does nothing otherwise.
##############################################################################
macro(assert_empty value)
    if (NOT "${value}" STREQUAL "")
        log_error(test "Expected empty variable.")
    endif()
endmacro()

##############################################################################
#.rst:
#
# .. cmake:command:: assert_same
#
# .. code-block:: cmake
#
#    assert_same(value)
#
# If the strings ``str1`` and ``str2`` are not equal, emits an error message.
# Does nothing otherwise.
##############################################################################
macro(assert_same str1 str2)
    if (NOT "${str1}" STREQUAL "${str2}")
        log_error(test "`${str1}` is not the same as `${str2}`")
    endif ()
endmacro()

##############################################################################
#.rst:
#
# .. cmake:command:: assert_ends_with
#
# .. code-block:: cmake
#
#    assert_ends_with(value)
#
# If the string ``str1`` does not end with ``str2``, emits an error message.
# Does nothing otherwise.
##############################################################################
macro(assert_ends_with str1 str2)
    string(FIND "${str1}" "${str2}" _ind)
    string(LENGTH ${str1} _length)
    string(LENGTH ${str2} _substr_length)
    math(EXPR _diff "${_length} - ${_substr_length}")
    if (NOT ${_ind} EQUAL ${_diff})
        log_error(test "`${str1}` does not end with `${str2}`")
    endif ()
endmacro()
##############################################################################
#.rst:
#
# .. cmake:command:: assert
#
# .. code-block:: cmake
#
#    assert(value)
#
# If ``value`` evaluates to `false`, emits an error message.
# Does nothing otherwise.
##############################################################################
macro(assert value)
    if (NOT ${value})
        log_error(test "Expected `${value}` to evaluate to `true`.")
    endif()
endmacro()

##############################################################################
#.rst:
#
# .. cmake:command:: assert
#
# .. code-block:: cmake
#
#    assert_list_contains(_list _el)
#
# If the list ``_list`` does not contain the element ``_el``, emits an error
# message. Does nothing otherwise.
##############################################################################
function(assert_list_contains _list _el)
    if (NOT "${_el}" IN_LIST _list)
        log_error(test "${_el} is not contained in ${_list}")
    endif ()
endfunction()

