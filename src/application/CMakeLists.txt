noa_library(
  NAMESPACE sourcemeta 
  PROJECT native 
  NAME application
  FOLDER "Native/Application"
  SOURCES appkit/appkit.mm appkit/delegate.mm appkit/delegate.h)

noa_library_install(
  NAMESPACE sourcemeta
  PROJECT native
  NAME application)

target_link_libraries(sourcemeta_native_application PRIVATE "-framework AppKit")
target_link_libraries(sourcemeta_native_application PRIVATE "-framework Foundation")
