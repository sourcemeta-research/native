// window_win32.cc
#include <Windows.h>
#include <sourcemeta/native/window.h>

namespace sourcemeta::native {

Window::Window() : internal_(nullptr) {
  const char CLASS_NAME[] = "NativeWin32WindowClass";

  WNDCLASS wc = {};
  wc.lpfnWndProc = DefWindowProc; // Use default window procedure for now
  wc.hInstance = GetModuleHandle(NULL);
  wc.lpszClassName = CLASS_NAME;
  RegisterClass(&wc);

  // TODO(tony): add parameter for title
  HWND hwnd = CreateWindowEx(
      0, CLASS_NAME, "Window Title", WS_OVERLAPPEDWINDOW, CW_USEDEFAULT,
      CW_USEDEFAULT, // Position
      CW_USEDEFAULT,
      CW_USEDEFAULT, // Size (will be updated if size() was called)
      NULL,          // Parent window
      NULL,          // Menu
      GetModuleHandle(NULL), NULL);

  internal_ = hwnd;
}

Window::~Window() {
  if (internal_) {
    DestroyWindow(static_cast<HWND>(internal_));
  }
}

auto Window::size(const unsigned int width, const unsigned int height) -> void {
  SetWindowPos(static_cast<HWND>(internal_), NULL, 0, 0, // Ignore position
               width, height, SWP_NOMOVE | SWP_NOZORDER);
}

auto Window::show() -> void {
  ShowWindow(static_cast<HWND>(internal_), SW_SHOW);
}

} // namespace sourcemeta::native
