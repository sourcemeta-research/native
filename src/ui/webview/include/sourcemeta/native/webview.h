#ifndef SOURCEMETA_NATIVE_UI_WEBVIEW_H
#define SOURCEMETA_NATIVE_UI_WEBVIEW_H

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
  auto attachToWindow(void *windowHandle) -> void;
  auto loadUrl(const std::string &url) -> void;
  // auto loadHtml(const std::string& html) -> void;

  // IPC messaging
  // auto sendMessage(const std::string& channel, const std::string& message) ->
  // void; auto onMessage(const std::string& channel, void (*callback)(const
  // std::string&)) -> void;

  // Size control
  auto resize(unsigned int width, unsigned int height) -> void;
  // auto hide() -> void;

private:
  using Internal = void *;
  Internal internal_;
};

} // namespace sourcemeta::native

#endif