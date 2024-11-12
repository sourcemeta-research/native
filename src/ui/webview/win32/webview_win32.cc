#include <WebView2.h>

#include <sourcemeta/native/webview.h>
#include <sourcemeta/native/window.h>

#include <windows.h>
#include <wrl.h>

#include <cassert>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <optional>
#include <sstream>
#include <string>

using namespace Microsoft::WRL;

// TODO(tonygo): let see if we cannot put it in a common namespace
namespace {
static auto get_assets_path() -> std::filesystem::path {
  return std::filesystem::current_path() / "assets";
}

auto read_from_assets(const std::string &path) -> std::optional<std::string> {
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
} // namespace

namespace sourcemeta::native {

/*
 *
 * WebView::Internal for win32
 *
 */

class WebView::Internal {
public:
  bool ready{false};
  std::optional<std::string> url;
  std::optional<std::string> html_content;

  // Idealy, we would prefer to have a generic type as parent as in the future
  // WebView could be the child of a Container class, mixed with others UI
  // classes.
  ComPtr<ICoreWebView2Controller> controller;
  ComPtr<ICoreWebView2> webview;

  auto natvigate_to_url() -> void {
    assert(this->url.has_value());
    auto url_ = this->url.value();

    this->webview->Navigate(std::wstring(url_.begin(), url_.end()).c_str());
  }

  auto navigate_to_html() -> void {
    assert(this->html_content.has_value());

    auto content = this->html_content.value();
    auto webview23 = reinterpret_cast<ICoreWebView2_3 *>(this->webview.Get());

    webview23->SetVirtualHostNameToFolderMapping(
        L"native.assets", get_assets_path().c_str(),
        COREWEBVIEW2_HOST_RESOURCE_ACCESS_KIND_ALLOW);
    this->webview->NavigateToString(
        std::wstring(content.begin(), content.end()).c_str());
  }

  auto fit_to_window() -> void {
    if (this->controller && this->parent_) {
      RECT bounds;
      GetClientRect(this->parent_, &bounds);
      this->controller->put_Bounds(bounds);
    };
  }

  auto set_parent(void *parent) -> void {
    this->parent_ = static_cast<HWND>(parent);
  }

  auto create_webview(std::function<void()> callback) -> void {
    CreateCoreWebView2EnvironmentWithOptions(
        nullptr, nullptr, nullptr,
        Callback<ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler>(
            [this, callback](HRESULT result,
                             ICoreWebView2Environment *env) -> HRESULT {
              env->CreateCoreWebView2Controller(
                  this->parent_,
                  Callback<
                      ICoreWebView2CreateCoreWebView2ControllerCompletedHandler>(
                      [this, callback](
                          HRESULT result,
                          ICoreWebView2Controller *controller) -> HRESULT {
                        this->controller = controller;
                        this->controller->get_CoreWebView2(&this->webview);

                        // Set internals to ready
                        this->ready = true;

                        callback();
                        return S_OK;
                      })
                      .Get());
              return S_OK;
            })
            .Get());
  }

private:
  HWND parent_;
};

/*
 *
 * WebView API
 *
 */

WebView::WebView() : internal_(new WebView::Internal{}) {}

WebView::~WebView() {
  if (internal_) {
    auto internal = static_cast<WebView::Internal *>(internal_);

    std::cout << "WebView::~WebView(): cleaning up WebView" << std::endl;

    // Close and release WebView resources
    if (internal->controller) {
      internal->controller->Close();
    }

    // Delete internal state
    delete internal;
  }
}

auto WebView::resize() -> void {
  auto internal = static_cast<WebView::Internal *>(internal_);
  internal->fit_to_window();
}

auto WebView::attach_to(sourcemeta::native::Window &window) -> void {
  auto internal = static_cast<WebView::Internal *>(internal_);
  internal->set_parent(window.handle());

  window.on_resize([this]() { this->resize(); });

  internal->create_webview([internal]() {
    // Set the bounds of the WebView to match the bounds
    // of the parent window
    internal->fit_to_window();

    // Load the URL if it was set before the WebView was ready
    if (internal->url.has_value()) {
      internal->natvigate_to_url();
    } else if (internal->html_content.has_value()) {
      internal->navigate_to_html();
    }
  });
}

auto WebView::load_url(const std::string &url) -> void {
  auto internal = static_cast<WebView::Internal *>(internal_);
  internal->url = url;
  if (internal->webview) {
    internal->natvigate_to_url();
  }
}

auto WebView::load_html(const std::string &html_path) -> void {
  auto html_content = read_from_assets(html_path);
  if (!html_content.has_value()) {
    return;
  }

  auto internal = static_cast<WebView::Internal *>(internal_);
  internal->html_content = html_content.value();
  if (internal->webview) {
    internal->navigate_to_html();
  }
}
} // namespace sourcemeta::native
