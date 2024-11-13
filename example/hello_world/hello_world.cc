#include <sourcemeta/native/application.h>
#include <sourcemeta/native/webview.h>
#include <sourcemeta/native/window.h>

#include <exception>
#include <iostream>

class App : public sourcemeta::native::Application {
public:
  auto on_start() -> void override { std::cout << "Starting!" << std::endl; }

  auto on_ready() -> void override {
    std::cout << "Ready!" << std::endl;

    window.size(1200, 900);
    window.show();

    // webview.load_html("index.html");
    webview.load_url("https://sourcemeta.com");
    window.add(webview);

    // this->exit();
  }

  auto on_error(std::exception_ptr) noexcept -> void override {}

private:
  sourcemeta::native::Window window;
  sourcemeta::native::WebView webview;
};

NATIVE_RUN(App)
