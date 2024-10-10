#include <sourcemeta/native/args.h>

#import <Foundation/Foundation.h> // NSProcessInfo

#include <string>
#include <vector>

namespace sourcemeta::native::sysmod::args {
auto args() -> const std::vector<std::string> & {
  static std::vector<std::string> args;
  static bool cached = false;

  if (cached) {
    return args;
  }

  @autoreleasepool {
    auto ns_args = [[NSProcessInfo processInfo] arguments];
    args.reserve(ns_args.count);
    for (NSString *arg in ns_args) {
      args.push_back([arg UTF8String]);
    }
  }

  cached = true;

  return args;
}
} // namespace sourcemeta::native::sysmod::args
