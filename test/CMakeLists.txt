project(CMakeUtilitiesTest VERSION 0.1)

include(${PROJECT_SOURCE_DIR}/../cmake/Dependency.cmake)

add_test(
        NAME global_map_test
        COMMAND ${CMAKE_COMMAND}
            -Dcmake.utilities.path=${PROJECT_SOURCE_DIR}/../cmake
            -P ${PROJECT_SOURCE_DIR}/cmake/GlobalMapTest.cmake
)

add_test(
        NAME logging_test
        COMMAND ${CMAKE_COMMAND}
            -Dcmake.utilities.path=${PROJECT_SOURCE_DIR}/../cmake
            -P ${PROJECT_SOURCE_DIR}/cmake/LoggingTest.cmake
)

add_test(
        NAME dynamic_functions_test
        COMMAND ${CMAKE_COMMAND}
            -Dcmake.utilities.path=${PROJECT_SOURCE_DIR}/../cmake
            -P ${PROJECT_SOURCE_DIR}/cmake/DynamicFunctionsTest.cmake
)
