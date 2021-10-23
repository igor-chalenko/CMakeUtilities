cmake_minimum_required(VERSION 3.18)

include(${cmake.utilities.path}/Dependency.cmake)

add_to_registry(self "${cmake.utilities.path}")

import(self::Testing)
import(self::Logging)

function(log_functions_test)
    log_info(test "Path {1} will be changed to {2}" examples "${cmake.utilities.path}/examples")
    log_level(test DEBUG)
    log_debug(test "Path {1} will be changed to {2}" examples "${cmake.utilities.path}/examples")
endfunction()

function(log_parent_level_test)
    log_level(test1 INFO)
    log_to_file(test1 test1.log)
    log_level(test1.test2.test3 TRACE)
    _log_parent_level(test1.test2 _level)
    assert_same(${_level} INFO)
    _log_parent_level(test3.test2 _level)
    assert_same(${_level} WARN)
    _log_parent_destination(test1.test2 _file_name)
    assert_same(${_file_name} test1.log)
endfunction()

function(log_to_file_test)
    log_to_file(test test.log)
    log_warn(test "This is a warning with a parameter '{1}'" x)
    log_to_console(test)
    log_info(test "info message")
    log_warn(test "This is a warning with a parameter {1}" y)

    file(STRINGS ${CMAKE_CURRENT_BINARY_DIR}/test.log _messages)
    assert_ends_with("${_messages}" "This is a warning with a parameter 'x'")
endfunction()

log_functions_test()
log_to_file_test()
log_parent_level_test()
