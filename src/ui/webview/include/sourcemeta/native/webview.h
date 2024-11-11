#ifndef SOURCEMETA_NATIVE_UI_WEBVIEW_H
#define SOURCEMETA_NATIVE_UI_WEBVIEW_H

#include <sourcemeta/native/window.h>

#include <string>

namespace sourcemeta::native {

class WebView {
public:
  WebView();
  ~WebView();

  // Remove copy semantics
  WebView(WebView const &) = delete;
  void operator=(WebView const &) = delete;

  // Core functionality
  auto attach_to(sourcemeta::native::Window &window) -> void;
  auto load_url(const std::string &url) -> void;
  // auto load_html(const std::string& html) -> void;

  // IPC messaging
  // auto send_message(const std::string& channel, const std::string& message)
  // -> void; auto on_message(const std::string& channel, void (*callback)(const
  // std::string&)) -> void;

  // Size control
  auto resize() -> void;

private:
  using Internal = void *;
  Internal internal_;
};

} // namespace sourcemeta::native

#endif
