#ifndef SOURCEMETA_NATIVE_APPLICATION_H
#define SOURCEMETA_NATIVE_APPLICATION_H

#include <cassert>
#include <exception>
#include <type_traits>

namespace sourcemeta::native {

using Internal = void *;

struct ApplicationInternals;

class Application {
public:
  Application();
  virtual ~Application() = default;

  // Remove copy semantics
  Application(Application const &) = delete;
  void operator=(Application const &) = delete;

  static Application *instance();

  template <typename T> static auto instance() -> T * {
    static_assert(std::is_base_of_v<Application, T>);
    Application *instance = Application::instance();
    assert(instance);
    return dynamic_cast<T *>(instance);
  }

  auto run() noexcept -> int;
  auto exit(const int code) const noexcept -> void;

protected:
  virtual auto on_start() -> void = 0;
  virtual auto on_ready() -> void = 0;
  virtual auto on_error(const std::exception &error) -> void = 0;

private:
  Internal internal_;
  bool running_{false};

  friend struct ApplicationInternals;
};

#define NATIVE_RUN(class)                                                      \
  int main(const int, char *[]) {                                              \
    static_assert(std::is_base_of_v<sourcemeta::native::Application, class>,   \
                  "You must pass a subclass of Application");                  \
    return (class {}).run();                                                   \
  }

} // namespace sourcemeta::native

#endif // SOURCEMETA_NATIVE_APPLICATION_H
