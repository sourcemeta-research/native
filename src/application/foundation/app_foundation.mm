#include <sourcemeta/native/application.h>

#include <iostream>

#import <Foundation/Foundation.h> // NSObject

namespace {
sourcemeta::native::Application *instance_{nullptr};
}

namespace sourcemeta::native {
Application::Application() {
  assert(!instance_);
  instance_ = this;
}

Application::~Application() { instance_ = nullptr; }

Application &Application::instance() {
  assert(instance_);
  return *instance_;
}

auto Application::run() noexcept -> int {
  assert(!running_);
  running_ = true;

  on_start();
  on_ready();

  return EXIT_SUCCESS;
}

auto Application::on_error(std::exception_ptr error) -> void {
  try {
    if (error)
      std::rethrow_exception(error);
  } catch (const std::exception &error) {
    std::cerr << "Error: " << error.what() << std::endl;
  }
#ifndef NDEBUG
  std::abort();
#else
  throw error;
#endif
}

auto Application::exit(const int code) const noexcept -> void {
  assert(running_);
  std::exit(code);
}
} // namespace sourcemeta::native
