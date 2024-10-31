#include <WebView2.h>
#include <sourcemeta/native/webview.h>
#include <windows.h>
#include <wrl.h>

using namespace Microsoft::WRL;

namespace sourcemeta::native {

struct WebViewInternal {
  HWND parentHwnd;
  ComPtr<ICoreWebView2Controller> controller;
  ComPtr<ICoreWebView2> webview;
};

WebView::WebView() : internal_(new WebViewInternal{}) {}

WebView::~WebView() { delete static_cast<WebViewInternal *>(internal_); }

// auto WebView::loadUrl(const std::string &url) -> void {
//   auto internal = static_cast<WebViewInternal *>(internal_);
//   if (internal->webview) {
//     std::wstring wurl(url.begin(), url.end());
//     internal->webview->Navigate(wurl.c_str());
//   }
// }

// auto WebView::resize(unsigned int width, unsigned int height) -> void {
//   auto internal = static_cast<WebViewInternal *>(internal_);
//   if (internal->controller) {
//     RECT bounds = {0, 0, static_cast<LONG>(width),
//     static_cast<LONG>(height)}; internal->controller->put_Bounds(bounds);
//   }
// }

auto WebView::attachToWindow(void *windowHandle) -> void {
  auto internal = static_cast<WebViewInternal *>(internal_);
  internal->parentHwnd = static_cast<HWND>(windowHandle);

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
                      return S_OK;
                    })
                    .Get());
            return S_OK;
          })
          .Get());
}
} // namespace sourcemeta::native
