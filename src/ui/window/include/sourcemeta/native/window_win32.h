
#ifndef SOURCEMETA_NATIVE_UI_WINDOW_WIN32_H
#define SOURCEMETA_NATIVE_UI_WINDOW_WIN32_H

#include "window.h"

#include <type_traits>

namespace sourcemeta::native {

// Platform-specific implementation of add_impl for Windows
template <typename T> void add_impl(Window &window, T &child) {
  if constexpr (requires { child.attachToWindow(window); }) {
    child.attachToWindow(window);
  }
}

// Define the template add function here in the platform-specific header
template <typename T> void Window::add(T &child) {
  add_impl(*this, child); // Forward to platform-specific implementation
}

} // namespace sourcemeta::native

#endif
