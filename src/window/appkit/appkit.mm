#include <sourcemeta/native/window.h>

#include <iostream>

namespace sourcemeta::native {
auto Window::size(const int width, const int height) -> void {
  std::cout << "size" << std::endl;
}

auto Window::show() -> void { std::cout << "show" << std::endl; }
} // namespace sourcemeta::native
