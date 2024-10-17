#ifndef SOURCEMETA_NATIVE_APPLICATION_WIN32_DELEGATE_H
#define SOURCEMETA_NATIVE_APPLICATION_WIN32_DELEGATE_H

#include <exception>
#include <windows.h>

namespace sourcemeta::native {

class AppDelegate {
public:
  static LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam,
                                     LPARAM lParam);
};

struct ApplicationInternals {
  static auto on_ready() -> void;
  static auto on_error(std::exception_ptr error) noexcept -> void;
};

} // namespace sourcemeta::native

#endif
