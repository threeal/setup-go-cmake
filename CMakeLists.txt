cmake_minimum_required(VERSION 3.19)

project(
  SetupGo
  VERSION 1.0.0
  DESCRIPTION "Set up a specific version of Go from a CMake project"
  HOMEPAGE_URL https://github.com/threeal/setup-go-cmake
  LANGUAGES NONE
)

if(NOT CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  set(SUBPROJECT TRUE)
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
if(SUBPROJECT)
  set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
endif()

if(NOT SUBPROJECT)
  if(BUILD_TESTING)
    enable_testing()
    add_subdirectory(test)
  endif()

  include(CMakePackageConfigHelpers)
  write_basic_package_version_file(
    SetupGoConfigVersion.cmake
    COMPATIBILITY SameMajorVersion
  )

  install(
    FILES
      cmake/SetupGo.cmake
      cmake/SetupGoConfig.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/SetupGoConfigVersion.cmake
    DESTINATION lib/cmake/SetupGo
  )
endif()
