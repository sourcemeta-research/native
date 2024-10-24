#include <sourcemeta/native/application.h>

#ifdef __APPLE__ // Temporary until window module is available for windows
#include <sourcemeta/native/window.h>
#endif

#include <exception>
#include <iostream>

class App : public sourcemeta::native::Application {
public:
  auto on_start() -> void override { std::cout << "Starting!" << std::endl; }

  auto on_ready() -> void override {
    std::cout << "Ready!" << std::endl;

#ifdef __APPLE__ // Temporary
    window.size(800, 600);
    window.show();
#endif

    this->exit();
  }

  auto on_error(std::exception_ptr) noexcept -> void override {}

#ifdef __APPLE__ // Temporary
private:
  sourcemeta::native::Window window;
#endif
};

NATIVE_RUN(App)
