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

# Load Native CMake module
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
include(cmake/native.cmake)
include(cmake/example.cmake)

# Load Noa CMake module
include(vendor/noa/cmake/noa.cmake)
include(vendor/noa/cmake/noa/defaults.cmake)

# Load install helpers
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# Configure the Native CMake module
configure_package_config_file(
  config.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config.cmake"
  INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake"
  COMPATIBILITY SameMajorVersion)
# Install the Native CMake module
install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config.cmake"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
  COMPONENT sourcemeta_native)

# TODO(tonygo): hide this in a native macro
install(FILES
  # Install native functions like (native_add_app, native_set_profile)
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/native.cmake"
  # Install macOS skeleton files
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/entitlements.plist"
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Info.plist"
  #  install Windows skeleton files
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/resource.rc.in"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
  COMPONENT sourcemeta_native)

add_subdirectory(src/application)
add_subdirectory(src/ui)
add_subdirectory(src/sysmod)
add_subdirectory(example)
