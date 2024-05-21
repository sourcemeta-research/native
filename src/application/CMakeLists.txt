noa_library(
  NAMESPACE sourcemeta 
  PROJECT native 
  NAME application
  FOLDER "Native/Application"
  SOURCES appkit.mm delegate.mm delegate.h)

target_link_libraries(sourcemeta_native_application PRIVATE "-framework AppKit")
target_link_libraries(sourcemeta_native_application PRIVATE "-framework Foundation")
