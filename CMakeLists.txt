cmake_minimum_required(VERSION 3.22)

set(NATIVE_LANGUAGES C CXX)
if(APPLE)
  list(APPEND NATIVE_LANGUAGES OBJC OBJCXX)
endif()

project(native 
  VERSION 0.0.1 
  LANGUAGES ${NATIVE_LANGUAGES}
  DESCRIPTION "Build your macOS app with C++"
)

include(vendor/noa/cmake/noa.cmake)
include(vendor/noa/cmake/noa/defaults.cmake)

add_subdirectory(src/application)
add_subdirectory(src/window)

add_subdirectory(example/hello_world)
