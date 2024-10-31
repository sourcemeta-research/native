noa_library(
  NAMESPACE sourcemeta
  PROJECT native
  NAME webview
  VARIANT win32
  FOLDER "Native/Ui/Webview"
  SOURCES webview_win32.cc)

noa_library_install(
  NAMESPACE sourcemeta
  PROJECT native
  NAME webview
  VARIANT win32)

set_target_properties(sourcemeta_native_webview_win32 PROPERTIES 
  VS_GLOBAL_WebView2LoaderPreference "Static"
  VS_USER_PROPS "${CMAKE_CURRENT_SOURCE_DIR}/webview.props"
  VS_PACKAGE_REFERENCES "Microsoft.Web.WebView2_1.0.2592.51")

