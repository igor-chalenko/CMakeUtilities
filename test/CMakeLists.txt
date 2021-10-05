include(cmake/GlobalMapTest.cmake)
include(cmake/LoggingTest.cmake)
include(cmake/PrefixFunctionsTest.cmake)

include(${PROJECT_SOURCE_DIR}/cmake/GlobalMap.cmake)
include(${PROJECT_SOURCE_DIR}/cmake/Logging.cmake)
include(${PROJECT_SOURCE_DIR}/cmake/PrefixFunctions.cmake)

include(${PROJECT_SOURCE_DIR}/cmake/Testing.cmake)
assert(true)
assert_same("false" false)
#assert(false)

