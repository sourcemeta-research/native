#include "delegate.h"

#include <sourcemeta/native/application.h>

@implementation AppDelegate

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender
                    hasVisibleWindows:(BOOL)visibleWindows {
  if (!visibleWindows) {
    try {
      sourcemeta::native::ApplicationInternals::on_ready();
    } catch (const std::exception &error) {
      sourcemeta::native::ApplicationInternals::on_error(error);
    }
  }

  return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {

  try {
    sourcemeta::native::ApplicationInternals::on_ready();
  } catch (const std::exception &error) {
    sourcemeta::native::ApplicationInternals::on_error(error);
  }
}

@end

namespace sourcemeta::native {

auto ApplicationInternals::on_ready() -> void {
  sourcemeta::native::Application::instance()->on_ready();
}

auto ApplicationInternals::on_error(const std::exception &error) noexcept
    -> void {
  sourcemeta::native::Application::instance()->on_error(error);
}
} // namespace sourcemeta::native
