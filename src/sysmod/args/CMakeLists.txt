noa_library(
  NAMESPACE sourcemeta
  PROJECT native
  NAME args
  FOLDER "Native/SysMod/Args"
  SOURCES foundation/args_foundation.mm)

noa_library_install(
  NAMESPACE sourcemeta
  PROJECT native
  NAME args)

target_link_libraries(sourcemeta_native_args PRIVATE "-framework Foundation")
