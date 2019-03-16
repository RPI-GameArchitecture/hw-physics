cmake_minimum_required (VERSION 3.6)
project (gamearch5)

# SDL: for windowing and input:
set(SDL_AUDIO_ENABLED_BY_DEFAULT OFF)
set(SDL_ATOMIC_ENABLED_BY_DEFAULT OFF)
set(SDL_DLOPEN_ENABLED_BY_DEFAULT OFF)
set(SDL_FILE_ENABLED_BY_DEFAULT OFF)
set(SDL_FILESYSTEM_ENABLED_BY_DEFAULT OFF)
set(SDL_RENDER_ENABLED_BY_DEFAULT OFF)
set(SDL_THREADS_ENABLED_BY_DEFAULT OFF)
set(SDL_TIMER_ENABLED_BY_DEFAULT OFF)
set(SDL_SHARED_ENABLED_BY_DEFAULT OFF)
set(SDL_STATIC_ENABLED_BY_DEFAULT OFF)

include_directories ("${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/SDL2-2.0.9/include")
link_directories ("${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/SDL2-2.0.9/lib/x64")

# STB: for image loading and font:
include_directories ("${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/stb")

# GLEW: for OpenGL loading:
set(CMAKE_PREFIX_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/glew-2.1.0")
set(CMAKE_LIBRARY_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/glew-2.1.0/lib/Release/x64")
find_package(GLEW REQUIRED)
include_directories (${GLEW_INCLUDE_DIRS})
link_directories ("${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/glew-2.1.0/lib/Release/x64")

# AssImp Open Asset Importer library
include_directories ("${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/assimp/include")
link_directories ("${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/assimp/lib")

# GA framework and homeworks:
include_directories ("${CMAKE_CURRENT_SOURCE_DIR}")
file(GLOB_RECURSE GA_SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)

# On Windows, we're not going to worry about CRT secure warnings.
if (MSVC)
	set(CMAKE_CXX_FLAGS "$(CMAKE_CXX_FLAGS) /EHsc")
endif()

add_executable(ga ${GA_SOURCE_FILES} always_copy_data.h)
target_link_libraries(ga SDL2 SDL2main SDL2test glew32s opengl32 assimp-vc140-mt.lib IrrXML.lib zlibstaticd.lib)

if (MSVC)
	set_target_properties(ga PROPERTIES LINK_FLAGS "/ignore:4098 /ignore:4099")
endif()

add_custom_command(TARGET ga PRE_BUILD COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/ttf-bitstream-vera-1.10/VeraMono.ttf $<TARGET_FILE_DIR:ga>)

add_custom_target(ALWAYS_COPY_DATA COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_CURRENT_SOURCE_DIR}/always_copy_data.h)
add_dependencies(ga ALWAYS_COPY_DATA)

add_custom_command(TARGET ga POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/../../data $<TARGET_FILE_DIR:ga>/data)

add_custom_command(TARGET ga POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/SDL2-2.0.9/lib/x64/SDL2.dll $<TARGET_FILE_DIR:ga>)

add_custom_command(TARGET ga POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/../3rdparty/assimp/lib/assimp-vc140-mt.dll $<TARGET_FILE_DIR:ga>)

