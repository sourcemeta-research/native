
noa_library(
  NAMESPACE sourcemeta
  PROJECT native
  NAME application
  VARIANT foundation
  PRIVATE_HEADERS entry.h
  FOLDER "Native/Application"
  SOURCES app_foundation.mm)

noa_library_install(
  NAMESPACE sourcemeta
  PROJECT native
  NAME application
  VARIANT foundation)

target_link_libraries(sourcemeta_native_application_foundation PRIVATE "-framework AppKit")
