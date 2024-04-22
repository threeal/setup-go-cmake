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
  if(CMAKE_SYSTEM_NAME STREQUAL Windows)
    set(GO_EXECUTABLE ${CMAKE_BINARY_DIR}/_deps/go/bin/go.exe)
  else()
    set(GO_EXECUTABLE ${CMAKE_BINARY_DIR}/_deps/go/bin/go)
  endif()

  if(NOT EXISTS ${GO_EXECUTABLE})
    if(CMAKE_SYSTEM_NAME STREQUAL Linux)
      set(URL https://go.dev/dl/go1.22.2.linux-amd64.tar.gz)
    elseif(CMAKE_SYSTEM_NAME STREQUAL Darwin)
      if(CMAKE_SYSTEM_PROCESSOR STREQUAL x86_64)
        set(URL https://go.dev/dl/go1.22.2.darwin-amd64.tar.gz)
      elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL arm64)
        set(URL https://go.dev/dl/go1.22.2.darwin-arm64.tar.gz)
      else()
        message(FATAL_ERROR "Unsupported architecture for setting up Go: ${CMAKE_SYSTEM_PROCESSOR}")
      endif()
    elseif(CMAKE_SYSTEM_NAME STREQUAL Windows)
      set(URL https://go.dev/dl/go1.22.2.windows-amd64.zip)
    else()
      message(FATAL_ERROR "Unsupported system for setting up Go: ${CMAKE_SYSTEM_NAME}")
    endif()

    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/_deps)
    get_filename_component(FILENAME ${URL} NAME)

    # Download the Go build.
    file(DOWNLOAD ${URL} ${CMAKE_BINARY_DIR}/_deps/${FILENAME})

    # Extract the Go build.
    execute_process(
      COMMAND tar -xf ${CMAKE_BINARY_DIR}/_deps/${FILENAME} -C ${CMAKE_BINARY_DIR}/_deps
      RESULT_VARIABLE RES
    )
    if(NOT RES EQUAL 0)
      message(FATAL_ERROR "Failed to extract '${CMAKE_BINARY_DIR}/_deps/${FILENAME}' to '${CMAKE_BINARY_DIR}/_deps' (${RES})")
    endif()

    # Remove the downloaded Go build to free up space.
    file(REMOVE ${CMAKE_BINARY_DIR}/_deps/${FILENAME})
  endif()

  set(GO_EXECUTABLE ${GO_EXECUTABLE} PARENT_SCOPE)
endfunction()
