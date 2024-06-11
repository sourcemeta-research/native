noa_library(
  NAMESPACE sourcemeta
  PROJECT native
  NAME window
  FOLDER "Native/Ui/Window"
  SOURCES appkit/appkit.mm)

target_link_libraries(sourcemeta_native_window PRIVATE "-framework AppKit")
target_link_libraries(sourcemeta_native_window PRIVATE "-framework Foundation")
