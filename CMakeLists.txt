cmake_minimum_required(VERSION 3.20)
project(cmake_utilities)

set(CMAKE_CXX_STANDARD 14)

include(cmake/GlobalMap.cmake)

global_set(prefix a b)
global_get(prefix a _var)
message(STATUS "_var = ${_var}")
global_set(prefix a c)
global_get(prefix a _var)
message(STATUS "_var = ${_var}")

#add_library(cmake_utilities library.cpp)
