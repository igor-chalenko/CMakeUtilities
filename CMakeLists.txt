cmake_minimum_required(VERSION 3.20)
project(cmake-utilities VERSION 0.1)

if (PROJECT_NAME STREQUAL CMAKE_PROJECT_NAME)
    include(cmake/InstallBasicPackageFiles.cmake)

    add_subdirectory(test)
    add_subdirectory(doc)

    if (NOT DEFINED CMAKE_INSTALL_DATADIR)
        unset(CMAKE_INSTALL_DATADIR)
        include(GNUInstallDirs)
    endif()
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
endif()