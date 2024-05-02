# SetupGo.cmake

Set up a specific version of [Go](https://go.dev/) from a [CMake](https://cmake.org/) project.

The `SetupGo.cmake` is a CMake module containing a `setup_go` function.
This function sets up a specific version of Go to be used in a CMake project.
It downloads a specific Go build based on the current operating system and architecture from the official Go website and extracts the downloaded result to the CMake build directory.

## Integration

This module can be integrated into a CMake project in the following ways:

- Manually download the [`SetupGo.cmake`](./cmake/SetupGo.cmake) file and include it in the CMake project:
  ```cmake
  include(path/to/SetupGo.cmake)
  ```
- Use [`file(DOWNLOAD)`](https://cmake.org/cmake/help/latest/command/file.html#download) to automatically download the `SetupGo.cmake` file:
  ```cmake
  file(
    DOWNLOAD https://threeal.github.io/setup-go-cmake/v1.0.0
    ${CMAKE_BINARY_DIR}/SetupGo.cmake
  )
  include(${CMAKE_BINARY_DIR}/SetupGo.cmake)
  ```
- Use [CPM.cmake](https://github.com/cpm-cmake/CPM.cmake) to add this package to the CMake project:
  ```cmake
  cpmaddpackage(gh:threeal/setup-go-cmake@1.0.0)
  include(${SetupGo_SOURCE_DIR}/cmake/SetupGo.cmake)
  ```

## Example Usages

This example demonstrates how to set up the latest version of Go to be used in a CMake project:

```cmake
setup_go()

execute_process(COMMAND ${GO_EXECUTABLE} version)
```

### Specify Go Version

Use the `VERSION` argument to specify the Go version to set up:

```cmake
setup_go(VERSION 1.21.9)
```

## License

This project is licensed under the terms of the [MIT License](./LICENSE).

Copyright © 2024 [Alfi Maulana](https://github.com/threeal)
