
noa_library(
  NAMESPACE sourcemeta
  PROJECT native
  NAME application_foundation
  FOLDER "Native/Application"
  SOURCES app_foundation.mm
  CHILD application)

noa_library_install(
  NAMESPACE sourcemeta
  PROJECT native
  NAME application_foundation)

target_link_libraries(sourcemeta_native_application_foundation PRIVATE "-framework AppKit")
