function(add_cmake_test FILE)
  foreach(NAME ${ARGN})
    string(TOLOWER ${NAME} TEST_COMMAND)
    string(REPLACE " " "_" TEST_COMMAND ${TEST_COMMAND})
    add_test(
      NAME ${NAME}
      COMMAND ${CMAKE_COMMAND}
        -D CMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}
        -D CMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}
        -D CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
        -D CMAKE_BINARY_DIR=${CMAKE_CURRENT_SOURCE_DIR}/build
        -D TEST_COMMAND=${TEST_COMMAND}
        -P ${CMAKE_CURRENT_SOURCE_DIR}/${FILE}
    )
  endforeach()
endfunction()

add_cmake_test(
  cmake/SetupGoTest.cmake
  "Set up the latest version of Go"
  "Set up a specific version of Go"
)
