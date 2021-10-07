#include(cmake/GlobalMapTest.cmake)
#include(cmake/LoggingTest.cmake)
#include(cmake/DynamicFunctionsTest.cmake)

message(STATUS "Add logging test...")
add_test(
        NAME logging_test
        COMMAND ${CMAKE_COMMAND} -P cmake/LoggingTest.cmake
)

message(STATUS "Add global map test...")
add_test(
        NAME global_map_test
        COMMAND ${CMAKE_COMMAND} -P cmake/GlobalMapTest.cmake
)
