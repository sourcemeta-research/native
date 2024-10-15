noa_library(
  NAMESPACE sourcemeta
  PROJECT native
  NAME args
  VARIANT foundation
  FOLDER "Native/SysMod/Args"
  SOURCES args_foundation.mm)

noa_library_install(
  NAMESPACE sourcemeta
  PROJECT native
  NAME args
  VARIANT foundation)

target_link_libraries(sourcemeta_native_args_foundation PRIVATE "-framework Foundation")
