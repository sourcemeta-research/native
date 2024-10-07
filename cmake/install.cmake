# Install the native.cmake module
install(FILES "${CMAKE_SOURCE_DIR}/cmake/Native/native.cmake"
        DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Native")

# Install the package configuration files
install(FILES "${CMAKE_SOURCE_DIR}/cmake/Native/NativeConfig.cmake"
              "${CMAKE_SOURCE_DIR}/cmake/Native/NativeConfigVersion.cmake"
        DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Native")
