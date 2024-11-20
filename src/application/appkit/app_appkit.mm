#include <sourcemeta/native/application.h>

#import <AppKit/AppKit.h>
#import <Cocoa/Cocoa.h>

#include <exception>
#include <functional>
#include <iostream>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property std::function<void()> on_ready;
@property std::function<void(std::exception_ptr)> on_error;
@end

@implementation AppDelegate
- (AppDelegate *)initWithCallbacks:(std::function<void()>)on_ready
                               and:(std::function<void(std::exception_ptr)>)
                                       on_error {
  self.on_ready = on_ready;
  self.on_error = on_error;

  return self;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender
                    hasVisibleWindows:(BOOL)visibleWindows {
  assert(self.on_ready);
  assert(self.on_error);

  if (!visibleWindows) {
    try {
      (self.on_ready)();
    } catch (const std::exception &) {
      std::exception_ptr error = std::current_exception();
      (self.on_error)(error);
    }
  }

  return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  assert(self.on_ready);
  assert(self.on_error);

  try {
    (self.on_ready)();
  } catch (const std::exception &) {
    std::exception_ptr error = std::current_exception();
    (self.on_error)(error);
  }
}
@end

namespace {
sourcemeta::native::Application *instance_{nullptr};
}

namespace sourcemeta::native {

class Application::Internal {
public:
  Internal() = default;
  ~Internal() = default;

  auto run_application(std::function<void()> on_start,
                       std::function<void()> on_ready,
                       std::function<void(std::exception_ptr)> on_error)
      -> void {
    NSApplication *application = [NSApplication sharedApplication];
    AppDelegate *delegate = [[AppDelegate alloc] initWithCallbacks:on_ready
                                                               and:on_error];
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

  internal_->run_application(
      std::bind(&Application::on_start, this),
      std::bind(&Application::on_ready, this),
      std::bind(&Application::on_error, this, std::placeholders::_1));

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
