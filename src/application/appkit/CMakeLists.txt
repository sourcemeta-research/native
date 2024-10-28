noa_library(
  NAMESPACE sourcemeta
  PROJECT native
  NAME application
  VARIANT appkit
  PRIVATE_HEADERS entry.h
  FOLDER "Native/Application"
  SOURCES app_appkit.mm delegate.mm delegate.h)

noa_library_install(
  NAMESPACE sourcemeta
  PROJECT native
  NAME application
  VARIANT appkit)

target_link_libraries(sourcemeta_native_application_appkit PRIVATE "-framework AppKit")
target_link_libraries(sourcemeta_native_application_appkit PRIVATE "-framework Foundation")
