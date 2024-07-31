cmake_minimum_required(VERSION 3.5)

file(
  DOWNLOAD https://github.com/threeal/assertion-cmake/releases/download/v1.0.0/Assertion.cmake
    ${CMAKE_BINARY_DIR}/Assertion.cmake
  EXPECTED_MD5 1d8ec589d6cc15772581bf77eb3873ff)
include(${CMAKE_BINARY_DIR}/Assertion.cmake)

find_package(SetupGo REQUIRED PATHS ${CMAKE_CURRENT_LIST_DIR}/../cmake)

section("it should set up the latest version of Go")
  setup_go()

  assert(DEFINED GO_EXECUTABLE)
  assert(EXISTS "${GO_EXECUTABLE}")
  assert(IS_EXECUTABLE "${GO_EXECUTABLE}")

  assert_execute_process(
    COMMAND "${GO_EXECUTABLE}" version
    OUTPUT "^go version go1.22.5")
endsection()

section("it should set up a specific version of Go")
  setup_go(VERSION 1.21.9)

  assert(DEFINED GO_EXECUTABLE)
  assert(EXISTS "${GO_EXECUTABLE}")
  assert(IS_EXECUTABLE "${GO_EXECUTABLE}")

  assert_execute_process(
    COMMAND "${GO_EXECUTABLE}" version
    OUTPUT "^go version go1.21.9")
endsection()
