#include <sourcemeta/native/application.h>

#include <cassert>

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

  try {
    this->on_start();
    // For CLI, on_ready is called right after on_start
    // since there's no GUI to wait for
    this->on_ready();
  } catch (...) {
    this->on_error(std::current_exception());
  }

  return 0;
}

auto Application::exit(const int code) const noexcept -> void {
  assert(running_);
  std::exit(code); // Direct exit for CLI
}

} // namespace sourcemeta::native
