#include <sourcemeta/native/application.h>

#include <cassert>

namespace sourcemeta::native {

Application::Application() {}

Application::~Application() {}

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
