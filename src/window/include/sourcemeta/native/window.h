#ifndef SOURCEMETA_NATIVE_UI_WINDOW_H
#define SOURCEMETA_NATIVE_UI_WINDOW_H

namespace sourcemeta::native {
class Window {
public:
  Window();
  ~Window();

  auto size(const int width, const int height) -> void;
  auto show() -> void;

private:
  using Internal = void *;

  Internal internal_;
};
} // namespace sourcemeta::native

#endif
