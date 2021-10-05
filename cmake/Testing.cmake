include(${CMAKE_CURRENT_LIST_DIR}/Logging.cmake)

##############################################################################
#.rst:
#
# .. cmake:command:: _doxygen_assert_not_empty
#
# .. code-block:: cmake
#
#    _doxygen_assert_not_empty(_value)
#
# If the value given by ``_value`` is empty, fails with a fatal error.
# Does nothing otherwise.
macro(assert_not_empty _value)
    if ("${_value}" STREQUAL "")
        log_fatal("Expected non-empty variable.")
    endif()
endmacro()

macro(assert_empty _value)
    if (NOT "${_value}" STREQUAL "")
        log_fatal("Expected empty variable.")
    endif()
endmacro()

macro(assert_same str1 str2)
    if (NOT "${str1}" STREQUAL "${str2}")
        message(SEND_ERROR "`${str1}` is not the same as `${str2}`")
    endif ()
endmacro()

macro(assert _value)
    if (NOT ${_value})
        log_fatal(assert "Expected `${_value}` to evaluate to `true`.")
    endif()
endmacro()

function(assert_list_contains list1 el)
    if (NOT "${el}" IN_LIST list1)
        message(SEND_ERROR "${el} is not contained in ${list1}")
    endif ()
endfunction()

