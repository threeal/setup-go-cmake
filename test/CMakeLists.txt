function(add_cmake_test FILE)
  math(EXPR STOP "${ARGC} - 1")
  foreach(I RANGE 1 "${STOP}")
    add_test(
      NAME "${ARGV${I}}"
      COMMAND "${CMAKE_COMMAND}"
        -D CMAKE_HOST_SYSTEM_PROCESSOR=${CMAKE_HOST_SYSTEM_PROCESSOR}
        -D CMAKE_BINARY_DIR=${CMAKE_CURRENT_SOURCE_DIR}/build
        -D "TEST_COMMAND=${ARGV${I}}"
        -P ${CMAKE_CURRENT_SOURCE_DIR}/${FILE}
    )
  endforeach()
endfunction()

add_cmake_test(
  cmake/SetupGoTest.cmake
  "Set up the latest version of Go"
  "Set up a specific version of Go"
)
