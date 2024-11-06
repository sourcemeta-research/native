#include <sourcemeta/native/application.h>
#include <sourcemeta/native/window.h>
#ifdef _WIN32
#include <chrono>
#include <sourcemeta/native/webview.h>
#include <thread>
#endif

#include <exception>
#include <iostream>

class App : public sourcemeta::native::Application {
public:
  auto on_start() -> void override { std::cout << "Starting!" << std::endl; }

  auto on_ready() -> void override {
    std::cout << "Ready!" << std::endl;

    window.size(1200, 900);
    window.show();

#ifdef _WIN32
    webview.attachToWindow(window);
    std::this_thread::sleep_for(std::chrono::seconds(2));
#endif

    this->exit();
  }

  auto on_error(std::exception_ptr) noexcept -> void override {}

private:
  sourcemeta::native::Window window;
#ifdef _WIN32
  sourcemeta::native::WebView webview;
#endif
};

NATIVE_RUN(App)
