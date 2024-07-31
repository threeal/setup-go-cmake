add_test(
  NAME cmake/SetupGoTest.cmake
  COMMAND "${CMAKE_COMMAND}"
    -D CMAKE_BINARY_DIR=${CMAKE_CURRENT_SOURCE_DIR}/build
    -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/SetupGoTest.cmake)
