########## MACROS ###########################################################################
#############################################################################################

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAME ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAME ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                string(REGEX REPLACE "[^A-Za-z0-9.+_-]" "_" _LIBRARY_NAME ${_LIBRARY_NAME})
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


########### FOUND PACKAGE ###################################################################
#############################################################################################

include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated FindCrc32c.cmake")
set(Crc32c_FOUND 1)
set(Crc32c_VERSION "1.1.2")

find_package_handle_standard_args(Crc32c REQUIRED_VARS
                                  Crc32c_VERSION VERSION_VAR Crc32c_VERSION)
mark_as_advanced(Crc32c_FOUND Crc32c_VERSION)

set(Crc32c_COMPONENTS Crc32c::crc32c)

if(Crc32c_FIND_COMPONENTS)
    foreach(_FIND_COMPONENT ${Crc32c_FIND_COMPONENTS})
        list(FIND Crc32c_COMPONENTS "Crc32c::${_FIND_COMPONENT}" _index)
        if(${_index} EQUAL -1)
            conan_message(FATAL_ERROR "Conan: Component '${_FIND_COMPONENT}' NOT found in package 'Crc32c'")
        else()
            conan_message(STATUS "Conan: Component '${_FIND_COMPONENT}' found in package 'Crc32c'")
        endif()
    endforeach()
endif()

########### VARIABLES #######################################################################
#############################################################################################


set(Crc32c_INCLUDE_DIRS "/home/chrissi/.conan/data/crc32c/1.1.2/_/_/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/include")
set(Crc32c_INCLUDE_DIR "/home/chrissi/.conan/data/crc32c/1.1.2/_/_/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/include")
set(Crc32c_INCLUDES "/home/chrissi/.conan/data/crc32c/1.1.2/_/_/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/include")
set(Crc32c_RES_DIRS )
set(Crc32c_DEFINITIONS )
set(Crc32c_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(Crc32c_COMPILE_DEFINITIONS )
set(Crc32c_COMPILE_OPTIONS_LIST "" "")
set(Crc32c_COMPILE_OPTIONS_C "")
set(Crc32c_COMPILE_OPTIONS_CXX "")
set(Crc32c_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(Crc32c_LIBRARIES "") # Will be filled later
set(Crc32c_LIBS "") # Same as Crc32c_LIBRARIES
set(Crc32c_SYSTEM_LIBS )
set(Crc32c_FRAMEWORK_DIRS )
set(Crc32c_FRAMEWORKS )
set(Crc32c_FRAMEWORKS_FOUND "") # Will be filled later
set(Crc32c_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(Crc32c_FRAMEWORKS_FOUND "${Crc32c_FRAMEWORKS}" "${Crc32c_FRAMEWORK_DIRS}")

mark_as_advanced(Crc32c_INCLUDE_DIRS
                 Crc32c_INCLUDE_DIR
                 Crc32c_INCLUDES
                 Crc32c_DEFINITIONS
                 Crc32c_LINKER_FLAGS_LIST
                 Crc32c_COMPILE_DEFINITIONS
                 Crc32c_COMPILE_OPTIONS_LIST
                 Crc32c_LIBRARIES
                 Crc32c_LIBS
                 Crc32c_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to Crc32c_LIBS and Crc32c_LIBRARY_LIST
set(Crc32c_LIBRARY_LIST crc32c)
set(Crc32c_LIB_DIRS "/home/chrissi/.conan/data/crc32c/1.1.2/_/_/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_Crc32c_DEPENDENCIES "${Crc32c_FRAMEWORKS_FOUND} ${Crc32c_SYSTEM_LIBS} ")

conan_package_library_targets("${Crc32c_LIBRARY_LIST}"  # libraries
                              "${Crc32c_LIB_DIRS}"      # package_libdir
                              "${_Crc32c_DEPENDENCIES}"  # deps
                              Crc32c_LIBRARIES            # out_libraries
                              Crc32c_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "Crc32c")                                      # package_name

set(Crc32c_LIBS ${Crc32c_LIBRARIES})

foreach(_FRAMEWORK ${Crc32c_FRAMEWORKS_FOUND})
    list(APPEND Crc32c_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND Crc32c_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${Crc32c_SYSTEM_LIBS})
    list(APPEND Crc32c_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND Crc32c_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(Crc32c_LIBRARIES_TARGETS "${Crc32c_LIBRARIES_TARGETS};")
set(Crc32c_LIBRARIES "${Crc32c_LIBRARIES};")

set(CMAKE_MODULE_PATH "/home/chrissi/.conan/data/crc32c/1.1.2/_/_/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/chrissi/.conan/data/crc32c/1.1.2/_/_/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/" ${CMAKE_PREFIX_PATH})


########### COMPONENT crc32c VARIABLES #############################################

set(Crc32c_crc32c_INCLUDE_DIRS "/home/chrissi/.conan/data/crc32c/1.1.2/_/_/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/include")
set(Crc32c_crc32c_INCLUDE_DIR "/home/chrissi/.conan/data/crc32c/1.1.2/_/_/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/include")
set(Crc32c_crc32c_INCLUDES "/home/chrissi/.conan/data/crc32c/1.1.2/_/_/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/include")
set(Crc32c_crc32c_LIB_DIRS "/home/chrissi/.conan/data/crc32c/1.1.2/_/_/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/lib")
set(Crc32c_crc32c_RES_DIRS )
set(Crc32c_crc32c_DEFINITIONS )
set(Crc32c_crc32c_COMPILE_DEFINITIONS )
set(Crc32c_crc32c_COMPILE_OPTIONS_C "")
set(Crc32c_crc32c_COMPILE_OPTIONS_CXX "")
set(Crc32c_crc32c_LIBS crc32c)
set(Crc32c_crc32c_SYSTEM_LIBS )
set(Crc32c_crc32c_FRAMEWORK_DIRS )
set(Crc32c_crc32c_FRAMEWORKS )
set(Crc32c_crc32c_BUILD_MODULES_PATHS )
set(Crc32c_crc32c_DEPENDENCIES )
set(Crc32c_crc32c_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)


########## FIND PACKAGE DEPENDENCY ##########################################################
#############################################################################################

include(CMakeFindDependencyMacro)


########## FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #######################################
#############################################################################################

########## COMPONENT crc32c FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(Crc32c_crc32c_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(Crc32c_crc32c_FRAMEWORKS_FOUND "${Crc32c_crc32c_FRAMEWORKS}" "${Crc32c_crc32c_FRAMEWORK_DIRS}")

set(Crc32c_crc32c_LIB_TARGETS "")
set(Crc32c_crc32c_NOT_USED "")
set(Crc32c_crc32c_LIBS_FRAMEWORKS_DEPS ${Crc32c_crc32c_FRAMEWORKS_FOUND} ${Crc32c_crc32c_SYSTEM_LIBS} ${Crc32c_crc32c_DEPENDENCIES})
conan_package_library_targets("${Crc32c_crc32c_LIBS}"
                              "${Crc32c_crc32c_LIB_DIRS}"
                              "${Crc32c_crc32c_LIBS_FRAMEWORKS_DEPS}"
                              Crc32c_crc32c_NOT_USED
                              Crc32c_crc32c_LIB_TARGETS
                              ""
                              "Crc32c_crc32c")

set(Crc32c_crc32c_LINK_LIBS ${Crc32c_crc32c_LIB_TARGETS} ${Crc32c_crc32c_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH "/home/chrissi/.conan/data/crc32c/1.1.2/_/_/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/chrissi/.conan/data/crc32c/1.1.2/_/_/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/" ${CMAKE_PREFIX_PATH})


########## TARGETS ##########################################################################
#############################################################################################

########## COMPONENT crc32c TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET Crc32c::crc32c)
        add_library(Crc32c::crc32c INTERFACE IMPORTED)
        set_target_properties(Crc32c::crc32c PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${Crc32c_crc32c_INCLUDE_DIRS}")
        set_target_properties(Crc32c::crc32c PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${Crc32c_crc32c_LIB_DIRS}")
        set_target_properties(Crc32c::crc32c PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${Crc32c_crc32c_LINK_LIBS};${Crc32c_crc32c_LINKER_FLAGS_LIST}")
        set_target_properties(Crc32c::crc32c PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${Crc32c_crc32c_COMPILE_DEFINITIONS}")
        set_target_properties(Crc32c::crc32c PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${Crc32c_crc32c_COMPILE_OPTIONS_C};${Crc32c_crc32c_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## GLOBAL TARGET ####################################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    if(NOT TARGET Crc32c::Crc32c)
        add_library(Crc32c::Crc32c INTERFACE IMPORTED)
    endif()
    set_property(TARGET Crc32c::Crc32c APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES "${Crc32c_COMPONENTS}")
endif()

########## BUILD MODULES ####################################################################
#############################################################################################
########## COMPONENT crc32c BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${Crc32c_crc32c_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
