#ifndef SOURCEMETA_NATIVE_UI_WINDOW_H
#define SOURCEMETA_NATIVE_UI_WINDOW_H

#include <iostream>

namespace sourcemeta::native {
class Window {
public:
  auto size(const int width, const int height) -> void;
  auto show() -> void;
};
} // namespace sourcemeta::native

#endif
