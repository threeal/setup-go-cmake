# This code is licensed under the terms of the MIT License.
# Copyright (c) 2024 Alfi Maulana

include_guard(GLOBAL)

# Sets up the latest version of Go within this project.
#
# This function downloads the latest version of the Go build from the remote server, extracts it,
# and makes it available in the project.
#
# This function sets the `GO_EXECUTABLE` variable to the location of the Go executable.
function(setup_go)
  file(MAKE_DIRECTORY ${CMAKE_BUILD_DIR}/_deps)
  file(
    DOWNLOAD https://go.dev/dl/go1.22.2.linux-amd64.tar.gz ${CMAKE_BUILD_DIR}/_deps/go.tar.gz
    EXPECTED_MD5 f64eb5791a9dab9cbcdf6549b9583280
  )

  execute_process(
    COMMAND tar -xf ${CMAKE_BUILD_DIR}/_deps/go.tar.gz -C ${CMAKE_BUILD_DIR}/_deps
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to extract '${CMAKE_BUILD_DIR}/_deps/go.tar.gz' to '${CMAKE_BUILD_DIR}/_deps' (${RES})")
  endif()

  set(GO_EXECUTABLE ${CMAKE_BUILD_DIR}/_deps/go/bin/go PARENT_SCOPE)
endfunction()
