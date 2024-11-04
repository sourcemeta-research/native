#include <WebView2.h>
#include <sourcemeta/native/webview.h>
#include <sourcemeta/native/window.h>
#include <windows.h>
#include <wrl.h>

#include <iostream>

using namespace Microsoft::WRL;

namespace sourcemeta::native {

struct WebViewInternal {
  HWND parentHwnd;
  ComPtr<ICoreWebView2Controller> controller;
  ComPtr<ICoreWebView2> webview;
};

WebView::WebView() : internal_(new WebViewInternal{}) {}

WebView::~WebView() {
  auto internal = static_cast<WebViewInternal *>(internal_);
  if (internal->controller) {
    internal->controller.Reset(); // Explicitly release
  }
  if (internal->webview) {
    internal->webview.Reset(); // Explicitly release
  }
  delete internal;
}
// auto WebView::loadUrl(const std::string &url) -> void {
//   auto internal = static_cast<WebViewInternal *>(internal_);
//   if (internal->webview) {
//     std::wstring wurl(url.begin(), url.end());
//     internal->webview->Navigate(wurl.c_str());
//   }
// }

auto WebView::resize() -> void {
  auto internal = static_cast<WebViewInternal *>(internal_);
  if (internal->controller) {
    RECT bounds;
    GetClientRect(internal->parentHwnd, &bounds);
    internal->controller->put_Bounds(bounds);
  };
}

auto WebView::attachToWindow(sourcemeta::native::Window &window) -> void {
  auto internal = static_cast<WebViewInternal *>(internal_);
  internal->parentHwnd = static_cast<HWND>(window.handle());

  window.on_resize([this]() { this->resize(); });

  CreateCoreWebView2EnvironmentWithOptions(
      nullptr, nullptr, nullptr,
      Callback<ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler>(
          [internal](HRESULT result, ICoreWebView2Environment *env) -> HRESULT {
            env->CreateCoreWebView2Controller(
                internal->parentHwnd,
                Callback<
                    ICoreWebView2CreateCoreWebView2ControllerCompletedHandler>(
                    [internal](HRESULT result,
                               ICoreWebView2Controller *controller) -> HRESULT {
                      internal->controller = controller;
                      internal->controller->get_CoreWebView2(
                          &internal->webview);

                      // Set the bounds of the WebView to match the bounds of
                      // the parent window
                      RECT bounds;
                      GetClientRect(internal->parentHwnd, &bounds);
                      internal->controller->put_Bounds(bounds);
                      internal->webview->Navigate(L"https://www.google.com");
                      return S_OK;
                    })
                    .Get());
            return S_OK;
          })
          .Get());
}
} // namespace sourcemeta::native
