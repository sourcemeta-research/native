#include <sourcemeta/native/window.h>

#import <AppKit/AppKit.h> // NSWindowController

namespace sourcemeta::native {

class Window::Internal {
public:
  Internal() {
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
                      // When defer is set to YES, the window server postpones
                      // the creation of the window device (the low-level
                      // resources for rendering) until the window is moved
                      // onscreen. This can optimize performance by delaying the
                      // allocation of graphics resources until they are needed.
                      defer:YES];

    // By default, we don't want the title to be visible
    [window setTitleVisibility:NSWindowTitleHidden];

    // By default, we don't want the title bar to be transparent
    // as we hide the title. It lets the window's content extend to the
    // top of the window.
    [window setTitlebarAppearsTransparent:YES];

    [window.contentView setAutoresizesSubviews:YES];

    window_ = window;
  }

  ~Internal() { [[window_ windowController] close]; }

  auto show() -> void {
    NSWindowController *controller = [window_ windowController];
    [controller showWindow:nil];
    [window_ makeKeyAndOrderFront:controller];
    [window_ center];
  }

  auto size(const unsigned int width, const unsigned int height) -> void {
    NSRect frame = [window_ frame];

    frame.size.width = width;
    frame.size.height = height;

    [window_ setFrame:frame display:YES animate:YES];
  }

  auto handle() -> void * { return window_; }

private:
  NSWindow *window_;
};

Window::Window() { internal_ = new Window::Internal(); }

Window::~Window() { delete internal_; }

auto Window::size(const unsigned int width, const unsigned int height) -> void {
  if (width == 0 || height == 0) {
    return;
  }

  internal_->size(width, height);
}

auto Window::show() -> void { internal_->show(); }

auto Window::handle() -> void * { return internal_->handle(); }
} // namespace sourcemeta::native
