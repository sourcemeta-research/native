#include <Windows.h>

#include <sourcemeta/native/application.h>

#include "delegate_win32.h"

namespace sourcemeta::native {

LRESULT CALLBACK AppDelegate::WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam,
                                         LPARAM lParam) {
  switch (uMsg) {
  case WM_CREATE:
    // try {
    ApplicationInternals::on_ready();
    // } catch (...) {
    //   ApplicationInternals::on_error(std::current_exception());
    // }
    return 0;
  case WM_DESTROY:
    PostQuitMessage(0);
    return 0;
  case WM_PAINT: {
    PAINTSTRUCT ps;
    HDC hdc = BeginPaint(hwnd, &ps);
    FillRect(hdc, &ps.rcPaint, (HBRUSH)(COLOR_WINDOW + 1));
    EndPaint(hwnd, &ps);
  }
    return 0;
  }
  return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

auto ApplicationInternals::on_ready() -> void {
  sourcemeta::native::Application::instance().on_ready();
}

auto ApplicationInternals::on_error(std::exception_ptr error) noexcept -> void {
  sourcemeta::native::Application::instance().on_error(error);
}

} // namespace sourcemeta::native
