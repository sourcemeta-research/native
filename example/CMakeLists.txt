add_custom_target(hello_world_configure
  COMMAND "${CMAKE_COMMAND}"
  -S "${CMAKE_CURRENT_SOURCE_DIR}/hello_world"
  -B "${CMAKE_CURRENT_BINARY_DIR}/hello_world"
  "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
  "-DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH};${PROJECT_SOURCE_DIR}/build/dist"
  "-DCMAKE_TOOLCHAIN_FILE:PATH=${CMAKE_TOOLCHAIN_FILE}"
  COMMENT "Configuring hello_world example"
)

add_custom_target(hello_world_build
  COMMAND "${CMAKE_COMMAND}"
  --build "${CMAKE_CURRENT_BINARY_DIR}/hello_world"
  --config "${CMAKE_BUILD_TYPE}"
  COMMENT "Building hello_world example"
)

add_dependencies(hello_world_build hello_world_configure)

add_custom_target(hello_world_run
  COMMAND "${CMAKE_CURRENT_BINARY_DIR}/hello_world/hello_world_app.app/Contents/MacOS/hello_world_app"
  COMMENT "Running hello_world example"
)

add_dependencies(hello_world_run hello_world_build)

