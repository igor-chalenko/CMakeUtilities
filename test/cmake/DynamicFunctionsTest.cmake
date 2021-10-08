set(_project_source_dir "${CMAKE_CURRENT_BINARY_DIR}/../../")

include(${_project_source_dir}/cmake/Testing.cmake)
include(${_project_source_dir}/cmake/Logging.cmake)
include(${_project_source_dir}/cmake/DynamicFunctions.cmake)

parameter_to_function_prefix(doxygen
        global_set
        global_get
        test_fn
        )

global_set(doxygen a b)
doxygen_global_set(a b)
doxygen_global_get(a _var)
assert_same(${_var} b)

# test for https://github.com/igor-chalenko/cmake-utilities/issues/9
doxygen_global_set(key "")
doxygen_global_get(key _var)
assert_empty("${_var}")

trace_functions(global_set)
log_level(global_set TRACE)
log_to_file(global_set global_set.log)
_trace_global_set(test a bcd)
file(STRINGS ${CMAKE_CURRENT_BINARY_DIR}/global_set.log _messages)
assert_ends_with("${_messages}" "global_set(\"test\" \"a\" \"bcd\")")


