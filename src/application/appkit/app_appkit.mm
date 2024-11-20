#include <sourcemeta/native/application.h>

#include "delegate.h"

#import <AppKit/AppKit.h>
#import <Cocoa/Cocoa.h>

#include <iostream>

namespace {
sourcemeta::native::Application *instance_{nullptr};
}

namespace sourcemeta::native {

class Application::Internal {
public:
  Internal() = default;
  ~Internal() = default;

  auto run_application(std::function<void()> on_start) -> void {
    NSApplication *application = [NSApplication sharedApplication];
    AppDelegate *delegate = [[AppDelegate alloc] init];
    [application setDelegate:delegate];
    [application run];

    on_start();
  }

  auto terminate() -> void { [NSApp terminate:nil]; }
};

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

  internal_->run_application([this]() {
    try {
      on_start();
    } catch (...) {
      on_error(std::current_exception());
    }
  });

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

  if (code == 0) {
    internal_->terminate();
  }

  std::exit(code);
}
} // namespace sourcemeta::native
