cmake_minimum_required(VERSION 3.14)

project(my_hello_world)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Native REQUIRED)

native_add_app(
    TARGET hello_world_app
    PLATFORM desktop
    SOURCES hello_world.cc)

native_add_assets(
    TARGET hello_world_app
    ASSETS index.html style.css)

native_set_profile(
    TARGET hello_world_app
    NAME "example_hello_world"
    IDENTIFIER "com.native.example_hello_world"
    VERSION "1.0.0"
    DESCRIPTION "My app ..."
    CODESIGN_IDENTITY "W4MF6H9XZ6"
    MODULES "ui/window" "ui/webview")
