get_filename_component(_current_dir ${CMAKE_CURRENT_LIST_FILE} PATH)
include(${_current_dir}/GlobalMap.cmake)
global_set(current dir "${_current_dir}")

macro(add_to_registry _module _path)
    global_set(module.path. ${_module} "${_path}")
endmacro()

macro(import _module)
    global_get(current dir _current_dir)
    include(${_current_dir}/GlobalMap.cmake)

    if (${_module} MATCHES "(.+)::(.+)")
        global_get(module.path. ${CMAKE_MATCH_1} _path)
        if (NOT _path)
            obtain(${CMAKE_MATCH_1} ${ARGN})
            global_get(module.path. ${CMAKE_MATCH_1} _path)
        endif()
        include(${_path}/${CMAKE_MATCH_2}.cmake)
    else()
        message(FATAL_ERROR "Use package::module form for importing")
    endif()
endmacro()