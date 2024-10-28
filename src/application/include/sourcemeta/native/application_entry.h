#ifndef SOURCEMETA_NATIVE_APPLICATION_ENTRY_H
#define SOURCEMETA_NATIVE_APPLICATION_ENTRY_H

#ifdef _WIN32
#include <Windows.h>
#endif

#ifdef _WIN32
#define NATIVE_RUN(class)                                                      \
  int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,             \
                     LPSTR lpCmdLine, int nCmdShow) {                          \
    static_assert(std::is_base_of_v<sourcemeta::native::Application, class>,   \
                  "You must pass a subclass of Application");                  \
    return (class {}).run();                                                   \
  }
#else
#define NATIVE_RUN(class)                                                      \
  int main(const int, char *[]) {                                              \
    static_assert(std::is_base_of_v<sourcemeta::native::Application, class>,   \
                  "You must pass a subclass of Application");                  \
    return (class {}).run();                                                   \
  }
#endif

#endif // SOURCEMETA_NATIVE_APPLICATION_ENTRY_H
