# Matches everything if not defined
if(NOT TEST_MATCHES)
  set(TEST_MATCHES ".*")
endif()

set(TEST_COUNT 0)

include(SetupGo)

if("Set up the latest version of Go" MATCHES ${TEST_MATCHES})
  math(EXPR TEST_COUNT "${TEST_COUNT} + 1")

  setup_go()

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
  elseif(NOT OUT MATCHES "^go version go1.22.2")
    message(FATAL_ERROR "It should execute the version 1.22.1 of Go")
  endif()
endif()

if(TEST_COUNT LESS_EQUAL 0)
  message(FATAL_ERROR "Nothing to test with: ${TEST_MATCHES}")
endif()
