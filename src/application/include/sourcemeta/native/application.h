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
  virtual ~Application();

  // Remove copy semantics
  Application(Application const &) = delete;
  void operator=(Application const &) = delete;

  /// The Application class is designed to prevent multiple instances
  /// of the application from being created by using a singleton pattern.
  static Application *instance();

  /// This method is responsible for starting the application.
  /// It returns the exit code of the application. Instead of calling
  /// this method directly, use the NATIVE_RUN macro.
  auto run() noexcept -> int;

  /// This method is responsible for gracefully shutting down the application.
  auto exit(const int code = EXIT_SUCCESS) const noexcept -> void;

protected:
  /// Override this method to hook into the start event of the application.
  /// This method is called once when the application starts, before any
  /// other initialization.
  virtual auto on_start() -> void = 0;

  /// Override this method to hook into the event when the graphical user
  /// interface (GUI) is ready. In the context of a CLI application, this
  /// method is called immediately after the on_start method.
  virtual auto on_ready() -> void = 0;

  /// Override this method to handle errors that occur during the application's
  /// execution. This method provides a centralized way to manage exceptions
  /// and perform cleanup or logging.
  virtual auto on_error(std::exception_ptr error) -> void = 0;

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
