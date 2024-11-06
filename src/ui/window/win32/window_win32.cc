#include <Windows.h>
#include <sourcemeta/native/window.h>

#include <functional>
#include <iostream>
#include <vector>

namespace sourcemeta::native {

struct WindowInternal {
  HWND hwnd;
  std::vector<std::function<void(void)>> resize_callbacks;

  static LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam,
                                     LPARAM lParam) {
    if (uMsg == WM_NCCREATE) {
      // Windows gives us back our internal pointer that we passed to
      // CreateWindowEx
      auto *cs = reinterpret_cast<CREATESTRUCT *>(lParam);
      auto internal = static_cast<WindowInternal *>(cs->lpCreateParams);

      // We store it with the window so we can get it back later
      SetWindowLongPtr(hwnd, GWLP_USERDATA,
                       reinterpret_cast<LONG_PTR>(internal));
    }

    switch (uMsg) {
    case WM_SIZE: {
      auto internal = reinterpret_cast<WindowInternal *>(
          GetWindowLongPtr(hwnd, GWLP_USERDATA));
      if (internal) {
        for (auto &callback : internal->resize_callbacks) {
          callback();
        }
      }
      return 0;
    }
    case WM_CLOSE:
      DestroyWindow(hwnd);
      return 0;
    case WM_DESTROY:
      PostQuitMessage(0);
      return 0;
    }
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
  }
};

Window::Window() : internal_(new WindowInternal{}) {
  const char CLASS_NAME[] = "NativeWin32WindowClass";
  WNDCLASS wc = {};
  wc.lpfnWndProc = WindowInternal::WindowProc;
  wc.hInstance = GetModuleHandle(NULL);
  wc.lpszClassName = CLASS_NAME;
  RegisterClass(&wc);
}

Window::~Window() {
  if (internal_) {
    auto internal = static_cast<WindowInternal *>(internal_);
    if (internal->hwnd) {
      std::cout << "Destroying window" << std::endl;
      DestroyWindow(internal->hwnd);
      std::cout << "Window destroyed" << std::endl;
    }
    delete internal;
  }
}

auto Window::size(const unsigned int width, const unsigned int height) -> void {
  auto internal = static_cast<WindowInternal *>(internal_);
  if (internal->hwnd) {
    SetWindowPos(static_cast<HWND>(internal->hwnd), NULL, 0,
                 0, // Ignore position
                 width, height, SWP_NOMOVE | SWP_NOZORDER);
  }
}

auto Window::show() -> void {
  const char CLASS_NAME[] = "NativeWin32WindowClass";
  auto internal = static_cast<WindowInternal *>(internal_);
  // TODO(tony): add parameter for title
  HWND hwnd =
      CreateWindowEx(0, CLASS_NAME, "Native Window", WS_OVERLAPPEDWINDOW,
                     CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
                     NULL, // Parent window
                     NULL, // Menu
                     GetModuleHandle(NULL), internal);

  if (!hwnd) {
    std::cerr << "Failed to create window. Error: " << GetLastError()
              << std::endl;
    return;
  }

  internal->hwnd = hwnd;
  ShowWindow(hwnd, SW_SHOW);
}

auto Window::handle() -> void * {
  auto internal = static_cast<WindowInternal *>(internal_);
  return internal->hwnd;
}

auto Window::on_resize(std::function<void(void)> callback) -> void {
  auto internal = static_cast<WindowInternal *>(internal_);
  internal->resize_callbacks.push_back(callback);
}
} // namespace sourcemeta::native
