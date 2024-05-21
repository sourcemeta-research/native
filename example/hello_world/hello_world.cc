#include <sourcemeta/native/application.h>

#include <exception>
#include <iostream>

class App : public sourcemeta::native::Application {
public:
  auto on_start() -> void override { std::cout << "Starting!" << std::endl; }

  auto on_ready() -> void override { std::cout << "Ready!" << std::endl; }

  auto on_error(const std::exception &) noexcept -> void override {}
};

NATIVE_RUN(App)
