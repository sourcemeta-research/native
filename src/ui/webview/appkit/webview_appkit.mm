#include <sourcemeta/native/webview.h>
#include <sourcemeta/native/window.h>

#import <WebKit/WebKit.h>

namespace sourcemeta::native {

class WebView::Internal {
public:
  Internal() { webView_ = [[WKWebView alloc] initWithFrame:CGRectZero]; }

  ~Internal() { [webView_ release]; }

  void load_url(const std::string &url) {
    NSString *urlString = [NSString stringWithUTF8String:url.c_str()];
    NSURL *nsUrl = [NSURL URLWithString:urlString];
    if (nsUrl) {
      NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl];
      [webView_ loadRequest:request];
    } else {
      NSLog(@"Invalid URL string: %@", urlString);
    }
  }

  auto get_webview() -> WKWebView * { return webView_; }

private:
  WKWebView *webView_;
};

WebView::WebView() : internal_(new WebView::Internal{}) {}

WebView::~WebView() { delete internal_; }

auto WebView::resize() -> void {
  // Implement resize if needed
}

auto WebView::attach_to(sourcemeta::native::Window &window) -> void {
  NSWindow *native_window = static_cast<NSWindow *>(window.handle());
  WKWebView *webview = internal_->get_webview();

  NSView *contentView = [native_window contentView];
  [webview setFrame:contentView.bounds];
  [contentView addSubview:webview];
}

auto WebView::load_url(const std::string &url) -> void {
  internal_->load_url(url);
}

auto WebView::load_html(const std::string &) -> void {
  // Placeholder for loading HTML
}
} // namespace sourcemeta::native
