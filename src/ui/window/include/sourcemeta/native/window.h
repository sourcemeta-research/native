#ifndef SOURCEMETA_NATIVE_UI_WINDOW_H
#define SOURCEMETA_NATIVE_UI_WINDOW_H

#include <functional>

namespace sourcemeta::native {
class Window {
public:
  Window();
  ~Window();

  auto size(const unsigned int width, const unsigned int height) -> void;
  auto show() -> void;
  auto handle() -> void *;

  auto on_resize(std::function<void(void)> callback) -> void;

private:
  using Internal = void *;

  Internal internal_;
};
} // namespace sourcemeta::native

#endif
