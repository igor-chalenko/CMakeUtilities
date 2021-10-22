#############################################################################
# Copyright (c) 2020 Igor Chalenko
# Distributed under the MIT license.
# See accompanying file LICENSE.md.md or copy at
# https://opensource.org/licenses/MIT
##############################################################################

cmake_minimum_required(VERSION 3.18)
project(cmake-utilities VERSION 0.1)

function(self_register)
    include(${PROJECT_SOURCE_DIR}/cmake/Dependency.cmake)
    add_to_registry(cmake-utilities "${PROJECT_SOURCE_DIR}/cmake")
endfunction()

if (PROJECT_NAME STREQUAL CMAKE_PROJECT_NAME)
    include(cmake/3rd-party/InstallBasicPackageFiles.cmake)

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
            PATTERN cmake/3rd-party EXCLUDE)
else()
    self_register()
endif()

