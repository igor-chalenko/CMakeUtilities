include(${PROJECT_SOURCE_DIR}/cmake/GlobalMap.cmake)
include(${PROJECT_SOURCE_DIR}/cmake/Logging.cmake)

global_set(prefix a b)
global_get(prefix a _var)
message(STATUS "_var = ${_var}")
global_set(prefix a c)
global_get(prefix a _var)
message(STATUS "_var = ${_var}")

global_append(prefix a d)
global_get(prefix a _var)
message(STATUS "_var = ${_var}")
global_clear(prefix)
global_get(prefix a _var)
message(STATUS "_var = ${_var}")

log_level(test DEBUG)

log_debug(test "Path {1} will be changed to {2}" examples "${PROJECT_SOURCE_DIR}/examples")
log_info(test "Path {1} will be changed to {2}" examples "${PROJECT_SOURCE_DIR}/examples")
log_warn(test "This is a warning with a parameter {1}" x)
log_error(test "This is an error with a parameter {1}" y)

include(${PROJECT_SOURCE_DIR}/cmake/WrapModule.cmake)

wrap(doxygen global_set global_unset global_get global_append global_clear global_index global_set_index)

doxygen_global_set(a b)
doxygen_global_get(a _var)
message(STATUS "var=${_var}")

include(${PROJECT_SOURCE_DIR}/cmake/Testing.cmake)
assert(true)
assert_same("false" false)
#assert(false)

