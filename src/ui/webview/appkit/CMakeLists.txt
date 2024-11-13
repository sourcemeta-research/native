noa_library(
  NAMESPACE sourcemeta
  PROJECT native
  NAME webview
  VARIANT appkit
  FOLDER "Native/Ui/Webview"
  SOURCES webview_appkit.mm)

noa_library_install(
  NAMESPACE sourcemeta
  PROJECT native
  NAME webview
  VARIANT appkit)

target_link_libraries(sourcemeta_native_webview_appkit PRIVATE "-framework AppKit")
target_link_libraries(sourcemeta_native_webview_appkit PRIVATE "-framework Foundation")
target_link_libraries(sourcemeta_native_webview_appkit PRIVATE "-framework WebKit")
target_link_libraries(sourcemeta_native_webview_appkit PRIVATE
  sourcemeta::native::window::appkit)

