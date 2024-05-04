include(SetupGo)

function(assert_go_executable)
  cmake_parse_arguments(ARG "" "VERSION" "" ${ARGN})

  if(NOT DEFINED GO_EXECUTABLE)
    message(FATAL_ERROR "The GO_EXECUTABLE variable should be defined")
  endif()

  if(NOT EXISTS "${GO_EXECUTABLE}")
    message(FATAL_ERROR "The Go executable at '${GO_EXECUTABLE}' should exist")
  endif()

  execute_process(
    COMMAND "${GO_EXECUTABLE}" version
    RESULT_VARIABLE RES
    OUTPUT_VARIABLE OUT
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "It should not fail to execute the Go executable")
  elseif(DEFINED ARG_VERSION AND NOT OUT MATCHES "^go version go${ARG_VERSION}")
    message(FATAL_ERROR "It should execute the version ${ARG_VERSION} of Go")
  endif()
endfunction()

function(test_set_up_the_latest_version_of_go)
  setup_go()
  assert_go_executable(VERSION 1.22.2)
endfunction()

function(test_set_up_a_specific_version_of_go)
  setup_go(VERSION 1.21.9)
  assert_go_executable(VERSION 1.21.9)
endfunction()

if(NOT DEFINED TEST_COMMAND)
  message(FATAL_ERROR "The 'TEST_COMMAND' variable should be defined")
elseif(NOT COMMAND test_${TEST_COMMAND})
  message(FATAL_ERROR "Unable to find a command named 'test_${TEST_COMMAND}'")
endif()

cmake_language(CALL test_${TEST_COMMAND})
