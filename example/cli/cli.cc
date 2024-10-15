#include <sourcemeta/native/application.h>
// #include <sourcemeta/native/args.h>

#include <exception>
#include <iostream>

class App : public sourcemeta::native::Application {
public:
  auto on_start() -> void override { std::cout << "Starting!" << std::endl; }

  auto on_ready() -> void override {
    std::cout << "Arguments:" << std::endl;
    // const auto &args = sourcemeta::native::sysmod::args::args();
    // for (const auto &arg : args) {
    //   std::cout << arg << std::endl;
    // }

    this->exit();
  }

  auto on_error(std::exception_ptr) noexcept -> void override {}
};

NATIVE_RUN(App)
