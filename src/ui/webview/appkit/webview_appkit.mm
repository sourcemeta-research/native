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
  [webview setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
  [contentView addSubview:webview];
}

auto WebView::load_url(const std::string &url) -> void {
  internal_->load_url(url);
}

auto WebView::load_html(const std::string &html_path) -> void {
  NSString *html_filename = [NSString stringWithUTF8String:html_path.c_str()];
  NSString *html_filename_without_extension =
      html_filename.stringByDeletingPathExtension;
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *path = [bundle pathForResource:html_filename_without_extension
                                    ofType:@"html"];
  NSString *html = [NSString stringWithContentsOfFile:path
                                             encoding:NSUTF8StringEncoding
                                                error:nil];

  WKWebView *webview = internal_->get_webview();
  [webview loadHTMLString:html baseURL:bundle.bundleURL];
}
} // namespace sourcemeta::native
