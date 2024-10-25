cmake_minimum_required(VERSION 3.21)

include(Assertion)
find_package(SetupGo REQUIRED PATHS ${CMAKE_CURRENT_LIST_DIR}/../cmake)

section("it should set up the latest version of Go")
  setup_go()

  assert(DEFINED GO_EXECUTABLE)
  assert(EXISTS "${GO_EXECUTABLE}")
  assert(IS_EXECUTABLE "${GO_EXECUTABLE}")

  assert_execute_process("${GO_EXECUTABLE}" version
    EXPECT_OUTPUT "^go version go1.22.5")
endsection()

section("it should set up a specific version of Go")
  setup_go(VERSION 1.21.9)

  assert(DEFINED GO_EXECUTABLE)
  assert(EXISTS "${GO_EXECUTABLE}")
  assert(IS_EXECUTABLE "${GO_EXECUTABLE}")

  assert_execute_process("${GO_EXECUTABLE}" version
    EXPECT_OUTPUT "^go version go1.21.9")
endsection()
