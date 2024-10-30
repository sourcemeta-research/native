#include <sourcemeta/native/application.h>

#ifdef APPLE
#include <sourcemeta/native/args.h>
#endif

#include <exception>
#include <iostream>

class App : public sourcemeta::native::Application {
public:
  auto on_start() -> void override { std::cout << "Starting!" << std::endl; }

  auto on_ready() -> void override {
    std::cout << "Arguments:" << std::endl;

#ifdef APPLE
    const auto &args = sourcemeta::native::sysmod::args::args();
    for (const auto &arg : args) {
      std::cout << arg << std::endl;
    }
#endif

    this->exit();
  }

  auto on_error(std::exception_ptr) noexcept -> void override {}
};

NATIVE_RUN(App)
