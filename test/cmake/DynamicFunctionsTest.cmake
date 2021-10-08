set(_project_source_dir "${CMAKE_CURRENT_BINARY_DIR}/../../")

include(${_project_source_dir}/cmake/Testing.cmake)
include(${_project_source_dir}/cmake/Logging.cmake)
include(${_project_source_dir}/cmake/DynamicFunctions.cmake)

parameter_to_function_prefix(doxygen
        global_set
        global_get
        )

doxygen_global_set(a b)
doxygen_global_get(a _var)
assert_same(${_var} b)

trace_functions(global_set)
log_level(global_set TRACE)
log_to_file(global_set global_set.log)
_trace_global_set(a bcd)
file(STRINGS ${CMAKE_CURRENT_BINARY_DIR}/global_set.log _messages)
assert_ends_with("${_messages}" "global_set(a bcd)")


