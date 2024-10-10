cmake_minimum_required(VERSION 3.14)

project(my_cli)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Native REQUIRED)

native_add_app(
    TARGET cli_app
    PLATFORM desktop
    SOURCES cli.cc)

native_set_profile(
    TARGET cli_app
    NAME "example_cli_app"
    IDENTIFIER "com.native.example_cli"
    VERSION "1.0.0"
    DESCRIPTION "My cli ..."
    CODESIGN_IDENTITY "W4MF6H9XZ6"
    MODULES "sysmod/args")
