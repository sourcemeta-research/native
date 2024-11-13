#include <sourcemeta/native/window.h>

#import <AppKit/AppKit.h> // NSWindowController

@interface WindowController : NSWindowController
- (id)initWithNewWindow;
@end

@implementation WindowController
- (id)initWithNewWindow {
  // The style of the window, which determines different aspects of the
  // window's appearance and behavior. For more information, see
  // https://developer.apple.com/documentation/appkit/nswindowstylemask?language=objc
  NSWindowStyleMask windowStyleMask =
      NSWindowStyleMaskTitled | NSWindowStyleMaskResizable |
      NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable;

  NSWindow *window = [[NSWindow alloc]
      initWithContentRect:NSMakeRect(0, 0, 0, 0)
                styleMask:windowStyleMask
                  // You should use this mode.
                  // It supports hardware acceleration, Quartz drawing,
                  // and takes advantage of the GPU when possible.
                  backing:NSBackingStoreBuffered
                    // When defer is set to YES, the window server postpones the
                    // creation of the window device (the low-level resources
                    // for rendering) until the window is moved onscreen. This
                    // can optimize performance by delaying the allocation of
                    // graphics resources until they are needed.
                    defer:YES];

  // By default, we don't want the title to be visible
  [window setTitleVisibility:NSWindowTitleHidden];

  // By default, we don't want the title bar to be transparent
  // as we hide the title. It lets the window's content extend to the
  // top of the window.
  [window setTitlebarAppearsTransparent:YES];

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

  if (internal_) {
    CFBridgingRelease(internal_);
  }
}

auto Window::size(const unsigned int width, const unsigned int height) -> void {
  NSWindow *window = static_cast<NSWindow *>(internal_);
  NSRect frame = [window frame];

  frame.size.width = width;
  frame.size.height = height;

  [window setFrame:frame display:YES animate:YES];
}

auto Window::show() -> void {
  NSWindow *window = static_cast<NSWindow *>(internal_);
  WindowController *controller = [window windowController];
  [controller showWindow:nil];
  [window makeKeyAndOrderFront:controller];
}

auto Window::handle() -> void * { return internal_; }
} // namespace sourcemeta::native
