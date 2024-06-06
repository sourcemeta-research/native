#include <sourcemeta/native/window.h>

#include <iostream>

#import <AppKit/AppKit.h> // NSWindowController

@interface WindowController : NSWindowController
- (id)initWithNewWindow;
@end

@implementation WindowController
- (id)initWithNewWindow {
  // How the window should look like
  // See
  // https://developer.apple.com/documentation/appkit/nswindowstylemask?language=objc
  NSWindowStyleMask windowStyleMask =
      NSWindowStyleMaskTitled | NSWindowStyleMaskResizable |
      NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable;

  NSWindow *window = [[NSWindow alloc]
      initWithContentRect:NSMakeRect(0, 0, 0, 0)
                styleMask:windowStyleMask
                  // The window renders all drawing into a display
                  // buffer and then flushes it to the screen.
                  backing:NSBackingStoreBuffered
                    // The window server defers creating the
                    // window device until the window is moved
                    // onscreen.
                    defer:YES];

  // A value that indicates the visibility of the window's title and title bar
  // buttons.
  [window setTitleVisibility:NSWindowTitleHidden];
  // The title bar does not draw its background, which allows all
  // content underneath it to show through
  [window setTitlebarAppearsTransparent:YES];

  // Autoresize any sub view
  [window.contentView setAutoresizesSubviews:YES];

  return [super initWithWindow:window];
}
@end

namespace sourcemeta::native {
Window::Window() {
  internal_ =
      static_cast<void *>([[WindowController alloc] initWithNewWindow].window);
}

Window::~Window() {
  NSWindow *window = static_cast<NSWindow *>(internal_);
  [[window windowController] close];
}

auto Window::size(const int width, const int height) -> void {
  std::cout << "size" << std::endl;
}

auto Window::show() -> void {
  NSWindow *window = static_cast<NSWindow *>(internal_);
  WindowController *controller = [window windowController];
  [controller showWindow:nil];
  [window makeKeyAndOrderFront:controller];
}
} // namespace sourcemeta::native
