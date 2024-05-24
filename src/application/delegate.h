#ifndef SOURCEMETA_NATIVE_APPLICATION_APPKIT_DELEGATE_H
#define SOURCEMETA_NATIVE_APPLICATION_APPKIT_DELEGATE_H

#import <AppKit/AppKit.h>         // NSApplicationDelegate
#import <Foundation/Foundation.h> // NSObject

#include <exception> // std::exception

@interface AppDelegate : NSObject <NSApplicationDelegate>
@end

namespace sourcemeta::native {
struct ApplicationInternals {
  static auto on_ready() -> void;
  static auto on_error(std::exception_ptr error) noexcept -> void;
};
} // namespace sourcemeta::native

#endif
