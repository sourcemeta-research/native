cmake_minimum_required(VERSION 3.14)

project(my_hello_world)

# Include the custom module
include(${CMAKE_SOURCE_DIR}/cmake/native.cmake)

# Add the macOS application
native_add_app(
    TARGET hello_world_app
    PLATFORM desktop
    SOURCES hello_world.cc
)

native_set_profile(
    TARGET hello_world_app
    NAME "example_hello_world"
    GUI_IDENTIFIER "com.native.example_hello_world"
    VERSION "1.0.0"
    DESCRIPTION "My app ..."
    CODESIGN_IDENTITY "W4MF6H9XZ6"
)
