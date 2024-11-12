#include <WebView2.h>

#include <sourcemeta/native/webview.h>
#include <sourcemeta/native/window.h>

#include <windows.h>
#include <wrl.h>

#include <filesystem>
#include <fstream>
#include <iostream>
#include <optional>
#include <sstream>
#include <string>

using namespace Microsoft::WRL;

namespace sourcemeta::native {

/*
 *
 * Internals for win32
 *
 */

struct WebViewInternal {
  bool ready{false};
  std::optional<std::string> url;
  std::optional<std::string> html_content;

  // Idealy, we would prefer to have a generic type as parent as in the future
  // WebView could be the child of a Container class, mixed with others UI
  // classes.
  HWND parent;
  ComPtr<ICoreWebView2Controller> controller;
  ComPtr<ICoreWebView2> webview;
};

/*
 *
 * Internals helpers
 *
 */

static auto get_assets_path() -> std::filesystem::path {
  return std::filesystem::current_path() / "assets";
}

static auto set_html_content(WebViewInternal *internal,
                             const std::string &html_content) -> void {
  auto webview23 = reinterpret_cast<ICoreWebView2_3 *>(internal->webview.Get());
  webview23->SetVirtualHostNameToFolderMapping(
      L"native.assets", get_assets_path().c_str(),
      COREWEBVIEW2_HOST_RESOURCE_ACCESS_KIND_ALLOW);
  internal->webview->NavigateToString(
      std::wstring(html_content.begin(), html_content.end()).c_str());
}

static auto read_from_assets(const std::string &path)
    -> std::optional<std::string> {
  auto final_path = get_assets_path() / path;
  std::ifstream file(final_path);
  if (!file.is_open()) {
    std::cerr << "Failed to open file: " << final_path << std::endl;
    return std::nullopt;
  }

  std::stringstream buffer;
  buffer << file.rdbuf();
  std::string content = buffer.str();
  file.close();

  return content;
}

static auto fit_to_window(WebViewInternal *internal) -> void {
  if (internal->controller && internal->parent) {
    RECT bounds;
    GetClientRect(internal->parent, &bounds);
    internal->controller->put_Bounds(bounds);
  };
}

/*
 *
 * WebView API
 *
 */

WebView::WebView() : internal_(new WebViewInternal{}) {}

WebView::~WebView() {
  if (internal_) {
    auto internal = static_cast<WebViewInternal *>(internal_);

    if (internal->ready) {
      std::cout << "WebView::~WebView(): cleaning up WebView" << std::endl;

      // Close and release WebView resources
      if (internal->controller) {
        internal->controller->Close();
        internal->controller = nullptr;
      }
      if (internal->webview) {
        internal->webview = nullptr;
      }
    }

    // Delete internal state
    delete internal;
    internal_ = nullptr;
  }
}

auto WebView::resize() -> void {
  auto internal = static_cast<WebViewInternal *>(internal_);
  fit_to_window(internal);
}

auto WebView::attach_to(sourcemeta::native::Window &window) -> void {
  auto internal = static_cast<WebViewInternal *>(internal_);
  internal->parent = static_cast<HWND>(window.handle());

  window.on_resize([this]() { this->resize(); });

  CreateCoreWebView2EnvironmentWithOptions(
      nullptr, nullptr, nullptr,
      Callback<ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler>(
          [internal](HRESULT result, ICoreWebView2Environment *env) -> HRESULT {
            env->CreateCoreWebView2Controller(
                internal->parent,
                Callback<
                    ICoreWebView2CreateCoreWebView2ControllerCompletedHandler>(
                    [internal](HRESULT result,
                               ICoreWebView2Controller *controller) -> HRESULT {
                      internal->controller = controller;
                      internal->controller->get_CoreWebView2(
                          &internal->webview);

                      // Set the bounds of the WebView to match the bounds
                      // of the parent window
                      fit_to_window(internal);

                      // Set internals to ready
                      internal->ready = true;

                      // Load the URL if it was set before the WebView was ready
                      if (internal->url.has_value()) {
                        const auto url = internal->url.value();
                        internal->webview->Navigate(
                            std::wstring(url.begin(), url.end()).c_str());
                      } else if (internal->html_content.has_value()) {
                        const auto html_content =
                            internal->html_content.value();
                        set_html_content(internal, html_content);
                      }

                      return S_OK;
                    })
                    .Get());
            return S_OK;
          })
          .Get());
}

auto WebView::load_url(const std::string &url) -> void {
  auto internal = static_cast<WebViewInternal *>(internal_);
  if (internal->webview) {
    internal->webview->Navigate(std::wstring(url.begin(), url.end()).c_str());
  } else {
    // If the WebView is not ready, store the URL to load when it is ready
    internal->url = url;
  }
}

auto WebView::load_html(const std::string &html_path) -> void {
  auto html_content = read_from_assets(html_path);
  if (!html_content.has_value()) {
    return;
  }

  auto internal = static_cast<WebViewInternal *>(internal_);
  if (internal->webview) {
    set_html_content(internal, html_content.value());
  } else {
    // If the WebView is not ready, store the HTML content to load when it is
    // ready
    internal->html_content = html_content.value();
  }
}
} // namespace sourcemeta::native
