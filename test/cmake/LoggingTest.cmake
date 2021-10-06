include(${PROJECT_SOURCE_DIR}/cmake/Testing.cmake)
include(${PROJECT_SOURCE_DIR}/cmake/Logging.cmake)

function(test_log_functions)
    log_color(INFO Blue)
    log_parameter_color(INFO Red)
    log_info(test "Path {1} will be changed to {2}" examples "${PROJECT_SOURCE_DIR}/examples")
    log_level(test DEBUG)
    log_debug(test "Path {1} will be changed to {2}" examples "${PROJECT_SOURCE_DIR}/examples")
    log_color_reset(INFO)
    log_parameter_color_reset(INFO)
endfunction()

function(test_log_to_file)
    log_to_file(test test.log NEW)
    log_warn(test "This is a warning with a parameter '{1}'" x)
    log_to_console(test)
    log_info(test "info message")
    log_warn(test "This is a warning with a parameter {1}" y)

    file(STRINGS ${CMAKE_CURRENT_BINARY_DIR}/test.log _messages)
    assert_same("${_messages}" "This is a warning with a parameter 'x'")
endfunction()

message(STATUS "Run logging test...")
test_log_functions()
test_log_to_file()


