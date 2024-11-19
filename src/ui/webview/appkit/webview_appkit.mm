#include <sourcemeta/native/webview.h>
#include <sourcemeta/native/window.h>

#import <WebKit/WebKit.h>

#include <string>

namespace sourcemeta::native {

class WebView::Internal {
public:
  Internal() {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.preferences setValue:@YES forKey:@"developerExtrasEnabled"];
    webView_ = [[WKWebView alloc] initWithFrame:CGRectZero
                                  configuration:config];
  }

  ~Internal() { [webView_ release]; }

  auto load_url(const std::string &url) -> void {
    NSString *url_ns_str = [NSString stringWithUTF8String:url.c_str()];
    NSURL *url_ns = [NSURL URLWithString:url_ns_str];
    if (url_ns) {
      NSURLRequest *request = [NSURLRequest requestWithURL:url_ns];
      [webView_ loadRequest:request];
    } else {
      NSLog(@"Invalid URL string: %@", url_ns_str);
    }
  }

  auto load_html(const std::string &html_path) -> void {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *html_filename = [NSString stringWithUTF8String:html_path.c_str()];
    NSString *html_filename_without_extension =
        [html_filename stringByDeletingPathExtension];
    NSURL *html_url = [bundle URLForResource:html_filename_without_extension
                               withExtension:@"html"];

    [this->get_webview() loadFileURL:html_url
             allowingReadAccessToURL:[html_url URLByDeletingLastPathComponent]];
  }

  auto get_webview() -> WKWebView * { return webView_; }

private:
  WKWebView *webView_;
};

WebView::WebView() : internal_(new WebView::Internal{}) {}

WebView::~WebView() { delete internal_; }

auto WebView::attach_to(sourcemeta::native::Window &window) -> void {
  NSWindow *native_window = static_cast<NSWindow *>(window.handle());
  WKWebView *webview = internal_->get_webview();

  NSView *contentView = [native_window contentView];
  [webview setFrame:contentView.bounds];
  [webview setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
  [contentView addSubview:webview];
}

auto WebView::load_url(const std::string &url) -> void {
  if (url.empty()) {
    return;
  }
  internal_->load_url(url);
}

auto WebView::load_html(const std::string &html_path) -> void {
  if (html_path.empty() || !html_path.ends_with(".html")) {
    return;
  }
  internal_->load_html(html_path);
}
} // namespace sourcemeta::native
