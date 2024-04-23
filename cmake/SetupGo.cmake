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
  set(VERSION 1.22.2)

  if(CMAKE_SYSTEM_NAME STREQUAL Darwin)
    set(OS darwin)
  elseif(CMAKE_SYSTEM_NAME STREQUAL Linux)
    set(OS linux)
  elseif(CMAKE_SYSTEM_NAME STREQUAL Windows)
    set(OS windows)
  else()
    message(FATAL_ERROR "Unsupported system for setting up Go: ${CMAKE_SYSTEM_NAME}")
  endif()

  if(CMAKE_SYSTEM_PROCESSOR STREQUAL x86_64 OR CMAKE_SYSTEM_PROCESSOR STREQUAL AMD64)
    set(ARCH amd64)
  elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL arm64)
    set(ARCH arm64)
  else()
    message(FATAL_ERROR "Unsupported architecture for setting up Go: ${CMAKE_SYSTEM_PROCESSOR}")
  endif()

  if(OS STREQUAL windows)
    set(PACKAGE_EXT .zip)
    set(EXECUTABLE_EXT .exe)
  else()
    set(PACKAGE_EXT .tar.gz)
  endif()

  set(GO_BUILD go${VERSION}.${OS}-${ARCH})
  set(GO_PACKAGE ${GO_BUILD}${PACKAGE_EXT})
  set(GO_EXECUTABLE ${CMAKE_BINARY_DIR}/_deps/${GO_BUILD}/go/bin/go${EXECUTABLE_EXT})

  if(NOT EXISTS ${GO_EXECUTABLE})
    # Download the Go build.
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/_deps)
    file(DOWNLOAD https://go.dev/dl/${GO_PACKAGE} ${CMAKE_BINARY_DIR}/_deps/${GO_PACKAGE})

    # Extract the Go build.
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/_deps/${GO_BUILD})
    execute_process(
      COMMAND tar -xf ${CMAKE_BINARY_DIR}/_deps/${GO_PACKAGE} -C ${CMAKE_BINARY_DIR}/_deps/${GO_BUILD}
      RESULT_VARIABLE RES
    )
    if(NOT RES EQUAL 0)
      message(FATAL_ERROR "Failed to extract '${CMAKE_BINARY_DIR}/_deps/${GO_PACKAGE}' to '${CMAKE_BINARY_DIR}/_deps/${GO_BUILD}' (${RES})")
    endif()

    # Remove the downloaded Go build to free up space.
    file(REMOVE ${CMAKE_BINARY_DIR}/_deps/${GO_PACKAGE})
  endif()

  set(GO_EXECUTABLE ${GO_EXECUTABLE} PARENT_SCOPE)
endfunction()
