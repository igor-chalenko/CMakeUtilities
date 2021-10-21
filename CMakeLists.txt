#############################################################################
# Copyright (c) 2020 Igor Chalenko
# Distributed under the MIT license.
# See accompanying file LICENSE.md.md or copy at
# https://opensource.org/licenses/MIT
##############################################################################

cmake_minimum_required(VERSION 3.18)
project(cmake-utilities VERSION 0.1)

if (PROJECT_NAME STREQUAL CMAKE_PROJECT_NAME)
    include(cmake/InstallBasicPackageFiles.cmake)

    enable_testing()

    add_subdirectory(test)
    add_subdirectory(doc)

    if (NOT DEFINED CMAKE_INSTALL_DATADIR)
        include(GNUInstallDirs)
    endif()
    #if (VERBOSE)
        message(STATUS "Installing to ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_DATADIR}")
    #endif()
    set(_DESTINATION ${CMAKE_INSTALL_DATADIR}/cmake/${PROJECT_NAME})
    install_basic_package_files(${PROJECT_NAME}
            VERSION ${PROJECT_VERSION}
            COMPATIBILITY AnyNewerVersion
            ARCH_INDEPENDENT
            NO_EXPORT
            LOWERCASE_FILENAMES
            EXTRA_PATH_VARS_SUFFIX MODULE_DIR
            NO_CHECK_REQUIRED_COMPONENTS_MACRO)

    # slash at the end removes `cmake` from the directory structure
    install(DIRECTORY "cmake/"
            DESTINATION ${_DESTINATION}
            PATTERN cmake/InstallBasicPackageFiles.cmake EXCLUDE)
else()
    include(${PROJECT_SOURCE_DIR}/cmake/Dependency.cmake)
    include(${PROJECT_SOURCE_DIR}/cmake/Logging.cmake)
    include(${PROJECT_SOURCE_DIR}/cmake/Testing.cmake)
    include(${PROJECT_SOURCE_DIR}/cmake/DynamicFunctions.cmake)

    add_to_registry(cmake-utilities "${PROJECT_SOURCE_DIR}/cmake")
endif()