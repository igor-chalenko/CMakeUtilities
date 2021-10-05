include(${PROJECT_SOURCE_DIR}/cmake/Testing.cmake)
include(${PROJECT_SOURCE_DIR}/cmake/Logging.cmake)
include(${PROJECT_SOURCE_DIR}/cmake/PrefixFunctions.cmake)

prefix_functions(doxygen
        global_set
        global_unset
        global_get
        global_append
        global_clear
        global_index
        global_set_index)

doxygen_global_set(a b)
doxygen_global_get(a _var)
assert_same(${_var} b)

