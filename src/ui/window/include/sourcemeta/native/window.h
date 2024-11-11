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

  template <typename T> auto add(T &child) -> void { add_(child); }

private:
  using Internal = void *;
  Internal internal_;

  // TODO(tonygo): Hide this implementation detail
  template <typename T> void add_(T &child) {
    if constexpr (requires { child.attach_to(*this); }) {
      child.attach_to(*this);
    }
  }
};
} // namespace sourcemeta::native

#endif
