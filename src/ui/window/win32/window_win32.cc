#include <Windows.h>
#include <sourcemeta/native/window.h>

#include <iostream>

namespace {
LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam,
                            LPARAM lParam) {
  switch (uMsg) {
  case WM_CLOSE:
    DestroyWindow(hwnd);
    return 0;
  case WM_DESTROY:
    PostQuitMessage(0);
    return 0;
  }
  return DefWindowProc(hwnd, uMsg, wParam, lParam);
}
} // end anonymous namespace

namespace sourcemeta::native {

Window::Window() : internal_(nullptr) {
  const char CLASS_NAME[] = "NativeWin32WindowClass";
  WNDCLASS wc = {};
  wc.lpfnWndProc = WindowProc;
  wc.hInstance = GetModuleHandle(NULL);
  wc.lpszClassName = CLASS_NAME;
  RegisterClass(&wc);
}

Window::~Window() {
  if (internal_) {
    std::cerr << "Destroying window" << std::endl;
    DestroyWindow(static_cast<HWND>(internal_));
  }
}

auto Window::size(const unsigned int width, const unsigned int height) -> void {
  SetWindowPos(static_cast<HWND>(internal_), NULL, 0, 0, // Ignore position
               width, height, SWP_NOMOVE | SWP_NOZORDER);
}

auto Window::show() -> void {
  const char CLASS_NAME[] = "NativeWin32WindowClass";
  // TODO(tony): add parameter for title
  HWND hwnd =
      CreateWindowEx(0, CLASS_NAME, "Window Title", WS_OVERLAPPEDWINDOW,
                     CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
                     NULL, // Parent window
                     NULL, // Menu
                     GetModuleHandle(NULL), NULL);

  if (!hwnd) {
    std::cerr << "Failed to create window. Error: " << GetLastError()
              << std::endl;
    return;
  }

  internal_ = hwnd;
  ShowWindow(static_cast<HWND>(internal_), SW_SHOW);
}

auto Window::handle() -> void * { return internal_; }

} // namespace sourcemeta::native
