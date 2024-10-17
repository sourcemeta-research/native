#include <sourcemeta/native/application.h>

#include "delegate_win32.h"

#include <cassert>
#include <iostream>

namespace {
sourcemeta::native::Application *instance_{nullptr};
}

namespace sourcemeta::native {

Application::Application() {
  assert(!instance_);
  instance_ = this;
}

Application::~Application() {
  if (internal_) {
    DestroyWindow(static_cast<HWND>(internal_));
  }
  instance_ = nullptr;
}

Application &Application::instance() {
  assert(instance_);
  return *instance_;
}

auto Application::run() noexcept -> int {
  assert(!running_);
  running_ = true;

  on_start();

  const char CLASS_NAME[] = "NativeWin32ApplicationClass";

  WNDCLASS wc = {};
  wc.lpfnWndProc = AppDelegate::WindowProc;
  wc.hInstance = GetModuleHandle(NULL);
  wc.lpszClassName = CLASS_NAME;

  if (!RegisterClass(&wc)) {
    on_error(std::make_exception_ptr(
        std::runtime_error("Failed to register window class")));
    return EXIT_FAILURE;
  }

  HWND hwnd =
      CreateWindowEx(0, CLASS_NAME, "Win32 Application", WS_OVERLAPPEDWINDOW,
                     CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
                     NULL, NULL, GetModuleHandle(NULL), NULL);

  if (hwnd == NULL) {
    on_error(
        std::make_exception_ptr(std::runtime_error("Failed to create window")));
    return EXIT_FAILURE;
  }

  internal_ = hwnd;
  ShowWindow(hwnd, SW_SHOW);

  MSG msg = {};
  while (GetMessage(&msg, NULL, 0, 0)) {
    TranslateMessage(&msg);
    DispatchMessage(&msg);
  }

  return static_cast<int>(msg.wParam);
}

auto Application::on_error(std::exception_ptr error) -> void {
  try {
    if (error)
      std::rethrow_exception(error);
  } catch (const std::exception &error) {
    std::cerr << "Error: " << error.what() << std::endl;
  }
#ifndef NDEBUG
  std::abort();
#else
  throw error;
#endif
}

auto Application::exit(const int code) const noexcept -> void {
  assert(running_);
  PostQuitMessage(code);
}

} // namespace sourcemeta::native
