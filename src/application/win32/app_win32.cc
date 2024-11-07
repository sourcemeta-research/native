#include <Windows.h>

#include <sourcemeta/native/application.h>

#include <cassert>
#include <exception>
#include <iostream>

namespace {
sourcemeta::native::Application *instance_{nullptr};
}

namespace sourcemeta::native {

Application::Application() {
  assert(!instance_);
  SetProcessDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2);
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

  try {
    this->on_start();
    // It seems that win32 doesn't have a ready message
    // which is app-wide, events are correlated to the window
    this->on_ready();
  } catch (...) {
    this->on_error(std::current_exception());
  }

  MSG msg = {};
  BOOL ret = 0;
  while ((ret = GetMessage(&msg, NULL, 0, 0) != 0)) {
    if (ret == -1) {
      // The error is coming from GetMessage().
      throw std::runtime_error(
          "Failed to retrieve message from the message queue");
    }
    TranslateMessage(&msg);
    DispatchMessage(&msg);
  }

  return static_cast<int>(msg.wParam);
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
  PostQuitMessage(code);
}

} // namespace sourcemeta::native
