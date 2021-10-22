cmake_minimum_required(VERSION 3.18)

include(${cmake.utilities.path}/Dependency.cmake)

add_to_registry(self "${cmake.utilities.path}")

import(self::Testing)
import(self::Logging)

function(test_log_functions)
    log_info(test "Path {1} will be changed to {2}" examples "${PROJECT_SOURCE_DIR}/examples")
    log_level(test DEBUG)
    log_debug(test "Path {1} will be changed to {2}" examples "${PROJECT_SOURCE_DIR}/examples")
endfunction()

function(test_log_to_file)
    log_to_file(test test.log)
    log_warn(test "This is a warning with a parameter '{1}'" x)
    log_to_console(test)
    log_info(test "info message")
    log_warn(test "This is a warning with a parameter {1}" y)

    file(STRINGS ${CMAKE_CURRENT_BINARY_DIR}/test.log _messages)
    assert_ends_with("${_messages}" "This is a warning with a parameter 'x'")
endfunction()

test_log_functions()
test_log_to_file()


