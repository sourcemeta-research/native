#ifndef NATIVE_SYSMOD_ARGS_H_
#define NATIVE_SYSMOD_ARGS_H_

#include <string>
#include <vector>

namespace sourcemeta::native::sysmod::args {
auto args() -> const std::vector<std::string> &;
}

#endif // NATIVE_SYSMOD_ARGS_H_
