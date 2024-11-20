#include <sourcemeta/native/window.h>

#include <Windows.h>

#include <functional>
#include <iostream>
#include <vector>

namespace sourcemeta::native {

class Window::Internal {
public:
  Internal() {
    WNDCLASS wc = {};
    wc.lpfnWndProc = &Internal::WindowProc;
    wc.hInstance = GetModuleHandle(NULL);
    wc.lpszClassName = this->class_name_;
    RegisterClass(&wc);

    // TODO: Make this configurable
    this->title_ = "Native Window";
  }

  // The `CALLBACK` macro is a Windows-specific calling convention that
  // guarantees that the stack is cleaned up properly.
  static LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam,
                                     LPARAM lParam) {
    if (uMsg == WM_NCCREATE) {
      // Windows gives us back our internal pointer that we passed to
      // CreateWindowEx
      auto *cs = reinterpret_cast<CREATESTRUCT *>(lParam);
      auto internal = static_cast<Internal *>(cs->lpCreateParams);

      // We store it with the window so we can get it back later
      SetWindowLongPtr(hwnd, GWLP_USERDATA,
                       reinterpret_cast<LONG_PTR>(internal));
    }

    switch (uMsg) {
    case WM_SIZE: {
      auto internal =
          reinterpret_cast<Internal *>(GetWindowLongPtr(hwnd, GWLP_USERDATA));
      if (internal) {
        for (auto &callback : internal->get_resize_callbacks()) {
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

  auto size(const unsigned int width, const unsigned int height) -> void {
    if (this->hwnd_) {
      SetWindowPos(static_cast<HWND>(this->hwnd_), NULL, 0,
                   0, // Ignore position
                   width, height, SWP_NOMOVE | SWP_NOZORDER);
    }
  }

  auto create_window() -> void {
    // Create the window
    this->hwnd_ =
        CreateWindowEx(0, this->class_name_, this->title_, WS_OVERLAPPEDWINDOW,
                       CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
                       CW_USEDEFAULT, NULL, NULL, GetModuleHandle(NULL), this);
    if (!this->hwnd_) {
      std::cerr << "Failed to create window. Error: " << GetLastError()
                << std::endl;
      return;
    }
  }

  auto show() -> void {
    if (!this->hwnd_) {
      this->create_window();
    }
    if (this->hwnd_) {
      ShowWindow(this->hwnd_, SW_SHOW);
    }
  }

  auto handle() -> void * { return &this->hwnd_; }

  auto add_resize_callback(std::function<void(void)> callback) -> void {
    this->resize_callbacks_.push_back(callback);
  }

  auto get_resize_callbacks() -> std::vector<std::function<void(void)>> {
    return this->resize_callbacks_;
  }

private:
  HWND hwnd_;
  std::vector<std::function<void(void)>> resize_callbacks_;
  const char *class_name_ = "NativeWin32WindowClass";
  const char *title_;
};

Window::Window() { internal_ = new Internal(); }

Window::~Window() {
  if (internal_) {
    delete internal_;
  }
}

auto Window::size(const unsigned int width, const unsigned int height) -> void {
  internal_->size(width, height);
}

auto Window::show() -> void {
  internal_->create_window();
  internal_->show();
}

auto Window::handle() -> void * { return internal_->handle(); }

auto Window::on_resize(std::function<void(void)> callback) -> void {
  internal_->add_resize_callback(callback);
}
} // namespace sourcemeta::native
