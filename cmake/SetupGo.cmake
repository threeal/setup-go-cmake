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
  if(CMAKE_SYSTEM_NAME STREQUAL Linux)
    set(URL https://go.dev/dl/go1.22.2.linux-amd64.tar.gz)
    set(EXPECTED_MD5 f64eb5791a9dab9cbcdf6549b9583280)
  elseif(CMAKE_SYSTEM_NAME STREQUAL Darwin)
    set(URL https://go.dev/dl/go1.22.2.darwin-amd64.tar.gz)
    set(EXPECTED_MD5 6a8e1186969f0ce1cc6fc2551d834c6b)
  elseif(CMAKE_SYSTEM_NAME STREQUAL Windows)
    set(URL https://go.dev/dl/go1.22.2.windows-amd64.zip)
    set(EXPECTED_MD5 125813601d166b742b5ab86d986be78c)
  else()
    message(FATAL_ERROR "Unsupported system for setting up Go: ${CMAKE_SYSTEM_NAME}")
  endif()

  file(MAKE_DIRECTORY ${CMAKE_BUILD_DIR}/_deps)
  get_filename_component(FILENAME ${URL} NAME)

  file(
    DOWNLOAD ${URL} ${CMAKE_BUILD_DIR}/_deps/${FILENAME}
    EXPECTED_MD5 ${EXPECTED_MD5}
  )

  execute_process(
    COMMAND tar -xf ${CMAKE_BUILD_DIR}/_deps/${FILENAME} -C ${CMAKE_BUILD_DIR}/_deps
    RESULT_VARIABLE RES
  )
  if(NOT RES EQUAL 0)
    message(FATAL_ERROR "Failed to extract '${CMAKE_BUILD_DIR}/_deps/${FILENAME}' to '${CMAKE_BUILD_DIR}/_deps' (${RES})")
  endif()

  if(CMAKE_SYSTEM_NAME STREQUAL Windows)
    set(GO_EXECUTABLE ${CMAKE_BUILD_DIR}/_deps/go/bin/go.exe PARENT_SCOPE)
  else()
    set(GO_EXECUTABLE ${CMAKE_BUILD_DIR}/_deps/go/bin/go PARENT_SCOPE)
  endif()
endfunction()
