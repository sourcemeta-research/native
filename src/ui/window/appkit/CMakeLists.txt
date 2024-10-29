noa_library(
  NAMESPACE sourcemeta
  PROJECT native
  NAME window
  VARIANT appkit
  FOLDER "Native/Ui/Window"
  SOURCES window_appkit.mm)

noa_library_install(
  NAMESPACE sourcemeta
  PROJECT native
  NAME window
  VARIANT appkit)

target_link_libraries(sourcemeta_native_window_appkit PRIVATE "-framework AppKit")
target_link_libraries(sourcemeta_native_window_appkit PRIVATE "-framework Foundation")
