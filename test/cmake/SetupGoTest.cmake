# Matches everything if not defined
if(NOT TEST_MATCHES)
  set(TEST_MATCHES ".*")
endif()

set(TEST_COUNT 0)

include(SetupGo)

function(assert_go_executable)
  cmake_parse_arguments(ARG "" "VERSION" "" ${ARGN})

  if(NOT DEFINED GO_EXECUTABLE)
    message(FATAL_ERROR "The GO_EXECUTABLE variable should be defined")
  endif()

  if(NOT EXISTS ${GO_EXECUTABLE})
    message(FATAL_ERROR "The Go executable at '${GO_EXECUTABLE}' should exist")
  endif()

  execute_process(
    COMMAND ${GO_EXECUTABLE} version
    RESULT_VARIABLE RES
    OUTPUT_VARIABLE OUT
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "It should not fail to execute the Go executable")
  elseif(DEFINED ARG_VERSION AND NOT OUT MATCHES "^go version go${ARG_VERSION}")
    message(FATAL_ERROR "It should execute the version ${ARG_VERSION} of Go")
  endif()
endfunction()

if("Set up the latest version of Go" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  setup_go()
  assert_go_executable(VERSION 1.22.2)
endif()

if("Set up a specific version of Go" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  setup_go(VERSION 1.21.9)
  assert_go_executable(VERSION 1.21.9)
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()
