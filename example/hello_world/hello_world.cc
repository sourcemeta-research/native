#include <sourcemeta/native/application.h>

#ifdef __APPLE__
#include <sourcemeta/native/window.h>
#endif

#include <exception>
#include <iostream>

class App : public sourcemeta::native::Application {
public:
  auto on_start() -> void override { std::cout << "Starting!" << std::endl; }

  auto on_ready() -> void override {
    std::cout << "Ready!" << std::endl;

#ifdef __APPLE__
    window.size(800, 600);
    window.show();
#endif

    this->exit();
  }

  auto on_error(std::exception_ptr) noexcept -> void override {}

#ifdef __APPLE__
private:
  sourcemeta::native::Window window;
#endif
};

NATIVE_RUN(App)
