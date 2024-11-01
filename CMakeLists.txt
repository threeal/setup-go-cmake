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

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# Include the main module.
include(SetupGo)

if(SETUP_GO_ENABLE_TESTS)
  enable_testing()

  file(
    DOWNLOAD https://github.com/threeal/assertion-cmake/releases/download/v2.0.0/Assertion.cmake
      ${CMAKE_BINARY_DIR}/cmake/Assertion.cmake
    EXPECTED_MD5 5ebe475aee6fc5660633152f815ce9f6)
  include(${CMAKE_BINARY_DIR}/cmake/Assertion.cmake)

  add_cmake_script_test(test/setup_go.cmake
    DEFINITIONS CMAKE_MODULE_PATH=${CMAKE_BINARY_DIR}/cmake)
endif()

if(SETUP_GO_ENABLE_INSTALL)
  file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/cmake/SetupGoConfig.cmake
    "list(PREPEND CMAKE_MODULE_PATH \${CMAKE_CURRENT_LIST_DIR})\n"
    "include(SetupGo)\n")

  include(CMakePackageConfigHelpers)
  write_basic_package_version_file(cmake/SetupGoConfigVersion.cmake
    COMPATIBILITY SameMajorVersion ARCH_INDEPENDENT)

  install(
    FILES cmake/SetupGo.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/cmake/SetupGoConfig.cmake
      ${CMAKE_CURRENT_BINARY_DIR}/cmake/SetupGoConfigVersion.cmake
    DESTINATION lib/cmake/SetupGo)

  set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}")
  include(CPack)
endif()
