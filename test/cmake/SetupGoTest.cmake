cmake_minimum_required(VERSION 3.5)

file(
  DOWNLOAD https://github.com/threeal/assertion-cmake/releases/download/v0.3.0/Assertion.cmake
    ${CMAKE_BINARY_DIR}/Assertion.cmake
  EXPECTED_MD5 851f49c10934d715df5d0b59c8b8c72a)
include(${CMAKE_BINARY_DIR}/Assertion.cmake)

find_package(SetupGo REQUIRED PATHS ${CMAKE_CURRENT_LIST_DIR}/../../cmake)

# Asserts whether a Go executable exists with the specified version.
#
# Arguments:
#   - VERSION: The expected version of the Go executable.
function(assert_go_executable VERSION)
  assert(DEFINED GO_EXECUTABLE)
  assert(EXISTS "${GO_EXECUTABLE}")

  assert_execute_process(
    COMMAND "${GO_EXECUTABLE}" version
    OUTPUT "^go version go${VERSION}")
endfunction()

function("Set up the latest version of Go")
  setup_go()
  assert_go_executable(1.22.2)
endfunction()

function("Set up a specific version of Go")
  setup_go(VERSION 1.21.9)
  assert_go_executable(1.21.9)
endfunction()

cmake_language(CALL "${TEST_COMMAND}")
