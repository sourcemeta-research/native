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

target_link_libraries(sourcemeta_native_webview_win32 PRIVATE
    sourcemeta::native::window::win32)

# Set the WebView2LoaderPreference to Static
set_target_properties(sourcemeta_native_webview_win32 PROPERTIES 
  VS_GLOBAL_WebView2LoaderPreference "Static"
  VS_USER_PROPS "${CMAKE_CURRENT_SOURCE_DIR}/webview.props"
  VS_PACKAGE_REFERENCES "Microsoft.Web.WebView2_1.0.2592.51")

# Link the WebView2LoaderStatic.lib
set(WEBVIEW2_ROOT "$ENV{USERPROFILE}/.nuget/packages/microsoft.web.webview2/1.0.2592.51")
if (CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64|arm64|ARM64)$")
    message("Detected target architecture: ARM64")
    set(WEBVIEW2_LOADER_PATH "${WEBVIEW2_ROOT}/build/native/arm64/WebView2LoaderStatic.lib")
elseif (CMAKE_SIZEOF_VOID_P EQUAL 8)
    message("Detected target architecture: x64")
    set(WEBVIEW2_LOADER_PATH "${WEBVIEW2_ROOT}/build/native/x64/WebView2LoaderStatic.lib")
else()
    message("Detected target architecture: x86")
    set(WEBVIEW2_LOADER_PATH "${WEBVIEW2_ROOT}/build/native/x86/WebView2LoaderStatic.lib")
endif()
target_link_libraries(sourcemeta_native_webview_win32 PRIVATE "${WEBVIEW2_LOADER_PATH}")

