include(${PROJECT_SOURCE_DIR}/cmake/Testing.cmake)
include(${PROJECT_SOURCE_DIR}/cmake/Logging.cmake)

function(test_log_functions)
    log_debug(test "Path {1} will be changed to {2}" examples "${PROJECT_SOURCE_DIR}/examples")
    log_info(test "Path {1} will be changed to {2}" examples "${PROJECT_SOURCE_DIR}/examples")

    log_level(test DEBUG)
endfunction()

function(test_log_to_file)
    log_to_file(test test.log NEW)
    log_warn(test "This is a warning with a parameter {1}" x)
    log_to_console(test)
    log_error(test "This is an error with a parameter {1}" y)

    file(STRINGS ${CMAKE_CURRENT_BINARY_DIR}/test.log _messages)
    assert_same("${_messages}" "This is a warning with a parameter 'x'")
endfunction()

message(STATUS "Run logging test...")
test_log_functions()
test_log_to_file()


