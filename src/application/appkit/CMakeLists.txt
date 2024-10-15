noa_library(
  NAMESPACE sourcemeta
  PROJECT native
  NAME application_appkit
  FOLDER "Native/Application"
  SOURCES appkit.mm delegate.mm delegate.h
  CHILD application)

noa_library_install(
  NAMESPACE sourcemeta
  PROJECT native
  NAME application_appkit)

target_link_libraries(sourcemeta_native_application_appkit PRIVATE "-framework AppKit")
target_link_libraries(sourcemeta_native_application_appkit PRIVATE "-framework Foundation")
