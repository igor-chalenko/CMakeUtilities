project(cmake-utilities-test VERSION 0.1)
#include(cmake/GlobalMapTest.cmake)
#include(cmake/LoggingTest.cmake)
#include(cmake/DynamicFunctionsTest.cmake)

add_test(
        NAME global_map_test
        COMMAND ${CMAKE_COMMAND} -P ${PROJECT_SOURCE_DIR}/cmake/GlobalMapTest.cmake
)

add_test(
        NAME logging_test
        COMMAND ${CMAKE_COMMAND} -P ${PROJECT_SOURCE_DIR}/cmake/LoggingTest.cmake
)

add_test(
        NAME dynamic_functions_test
        COMMAND ${CMAKE_COMMAND} -P ${PROJECT_SOURCE_DIR}/cmake/DynamicFunctionsTest.cmake
)
