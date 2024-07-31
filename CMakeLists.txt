cmake_minimum_required(VERSION 3.21)

project(
  SetupGo
  VERSION 1.0.0
  DESCRIPTION "Set up a specific version of Go from a CMake project"
  HOMEPAGE_URL https://github.com/threeal/setup-go-cmake
  LANGUAGES NONE
)

option(SETUP_GO_ENABLE_TESTS "Enable test targets.")
option(
  SETUP_GO_ENABLE_INSTALL "Enable install targets." "${PROJECT_IS_TOP_LEVEL}")

include(cmake/SetupGo.cmake)

if(SETUP_GO_ENABLE_TESTS)
  enable_testing()

  add_test(
    NAME test/setup_go.cmake
    COMMAND "${CMAKE_COMMAND}"
      -D CMAKE_BINARY_DIR=${CMAKE_CURRENT_SOURCE_DIR}/build
      -P ${CMAKE_CURRENT_SOURCE_DIR}/test/setup_go.cmake)
endif()

if(SETUP_GO_ENABLE_INSTALL)
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
