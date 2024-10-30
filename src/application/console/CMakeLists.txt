noa_library(
  NAMESPACE sourcemeta
  PROJECT native
  NAME application
  VARIANT console
  PRIVATE_HEADERS entry.h
  FOLDER "Native/Application"
  SOURCES app_console.cc)

noa_library_install(
  NAMESPACE sourcemeta
  PROJECT native
  NAME application
  VARIANT console)
