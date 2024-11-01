# MIT License
#
# Copyright (c) 2024 Alfi Maulana
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Sets up a specific version of Go within this project.
#
# This function downloads a specific version of the Go build from the remote server, extracts it,
# and makes it available in the project.
#
# If the version is not specified, it will download the latest version of the Go build.
#
# This function sets the `GO_EXECUTABLE` variable to the location of the Go executable.
#
# Optional arguments:
#   - VERSION: The version of Go to set up.
function(setup_go)
  cmake_parse_arguments(PARSE_ARGV 0 ARG "" "VERSION" "")

  if(NOT DEFINED ARG_VERSION)
    set(ARG_VERSION 1.22.5)
  endif()

  if(CMAKE_HOST_SYSTEM_NAME STREQUAL Darwin)
    set(OS darwin)
    if(NOT DEFINED CMAKE_HOST_SYSTEM_PROCESSOR)
      execute_process(COMMAND uname -m OUTPUT_VARIABLE OUTPUT)
      string(STRIP "${OUTPUT}" CMAKE_HOST_SYSTEM_PROCESSOR)
    endif()
  elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL Linux)
    set(OS linux)
    if(NOT DEFINED CMAKE_HOST_SYSTEM_PROCESSOR)
      execute_process(COMMAND uname -m OUTPUT_VARIABLE OUTPUT)
      string(STRIP "${OUTPUT}" CMAKE_HOST_SYSTEM_PROCESSOR)
    endif()
  elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL Windows)
    set(OS windows)
    if(NOT DEFINED CMAKE_HOST_SYSTEM_PROCESSOR)
      set(CMAKE_HOST_SYSTEM_PROCESSOR "$ENV{PROCESSOR_ARCHITECTURE}")
    endif()
  else()
    message(FATAL_ERROR "Unsupported system for setting up Go: "
      "${CMAKE_HOST_SYSTEM_NAME}")
  endif()

  if(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES x86_64|AMD64)
    set(ARCH amd64)
  elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL arm64)
    set(ARCH arm64)
  else()
    message(FATAL_ERROR "Unsupported architecture for setting up Go: "
      "${CMAKE_HOST_SYSTEM_PROCESSOR}")
  endif()

  if(OS STREQUAL windows)
    set(PACKAGE_EXT .zip)
    set(EXECUTABLE_EXT .exe)
  else()
    set(PACKAGE_EXT .tar.gz)
  endif()

  set(GO_BUILD go${ARG_VERSION}.${OS}-${ARCH})
  set(GO_PACKAGE "${GO_BUILD}${PACKAGE_EXT}")
  set(GO_EXECUTABLE ${CMAKE_BINARY_DIR}/_deps/${GO_BUILD}/go/bin/go${EXECUTABLE_EXT})

  if(NOT EXISTS "${GO_EXECUTABLE}")
    # Download the Go build.
    message(STATUS "SetupGo: Downloading https://go.dev/dl/${GO_PACKAGE}...")
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/_deps)
    file(DOWNLOAD https://go.dev/dl/${GO_PACKAGE} ${CMAKE_BINARY_DIR}/_deps/${GO_PACKAGE})

    # Extract the Go build.
    message(STATUS "SetupGo: Extracting ${CMAKE_BINARY_DIR}/_deps/${GO_PACKAGE}...")
    find_program(TAR_EXECUTABLE tar)
    if(TAR_EXECUTABLE STREQUAL TAR_EXECUTABLE-NOTFOUND)
      message(FATAL_ERROR "Could not find the 'tar' program required to extract the Go package")
    endif()
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/_deps/${GO_BUILD})
    execute_process(
      COMMAND "${TAR_EXECUTABLE}" -xf ${CMAKE_BINARY_DIR}/_deps/${GO_PACKAGE} -C ${CMAKE_BINARY_DIR}/_deps/${GO_BUILD}
      RESULT_VARIABLE RES)
    if(NOT RES EQUAL 0)
      message(FATAL_ERROR "Failed to extract '${CMAKE_BINARY_DIR}/_deps/${GO_PACKAGE}' to '${CMAKE_BINARY_DIR}/_deps/${GO_BUILD}' (${RES})")
    endif()

    # Remove the downloaded Go build to free up space.
    file(REMOVE ${CMAKE_BINARY_DIR}/_deps/${GO_PACKAGE})
  endif()

  set(GO_EXECUTABLE "${GO_EXECUTABLE}" PARENT_SCOPE)
endfunction()
