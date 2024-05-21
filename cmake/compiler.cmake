# Specify the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_OBJCXX_STANDARD 20)
set(CMAKE_OBJCXX_STANDARD_REQUIRED ON)
set(CMAKE_OBJCXX_EXTENSIONS OFF)

# Hide symbols from shared libraries by default
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_OBJCXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

# Export compile commands by default.
# It is very useful for IDE integration, linting, etc
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(APPLE)
  set(CMAKE_XCODE_ATTRIBUTE_MACOSX_DEPLOYMENT_TARGET "13"
    CACHE STRING "Minimum macOS deployment version")
  set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "14"
    CACHE STRING "Minimum iOS/iPadOS deployment version")
endif()

if(APPLE)
  # Xcode handles this itself
  if(NOT CMAKE_GENERATOR STREQUAL "Xcode")
    # See https://developer.apple.com/documentation/objectivec/objc_old_dispatch_prototypes?language=objc
    add_compile_definitions(OBJC_OLD_DISPATCH_PROTOTYPES=0)
  endif()

  set(CMAKE_OBJC_FLAGS "${CMAKE_OBJC_FLAGS} -fobjc-arc")
  set(CMAKE_OBJC_FLAGS "${CMAKE_OBJC_FLAGS} -fobjc-weak")
  set(CMAKE_OBJC_FLAGS "${CMAKE_OBJC_FLAGS} -fno-common")
  set(CMAKE_OBJC_FLAGS "${CMAKE_OBJC_FLAGS} -fstrict-aliasing")
  set(CMAKE_OBJC_FLAGS "${CMAKE_OBJC_FLAGS} -fpascal-strings")

  set(CMAKE_OBJCXX_FLAGS "${CMAKE_OBJCXX_FLAGS} -fobjc-arc")
  set(CMAKE_OBJCXX_FLAGS "${CMAKE_OBJCXX_FLAGS} -fobjc-weak")
  set(CMAKE_OBJCXX_FLAGS "${CMAKE_OBJCXX_FLAGS} -fno-common")
  set(CMAKE_OBJCXX_FLAGS "${CMAKE_OBJCXX_FLAGS} -fstrict-aliasing")
  set(CMAKE_OBJCXX_FLAGS "${CMAKE_OBJCXX_FLAGS} -fpascal-strings")
endif()

add_compile_definitions($<$<CONFIG:Debug>:DEBUG=1>)

if(APPLE)
  add_compile_definitions(
    # Disable NSAssert on builds other than debug
    $<$<NOT:$<CONFIG:Debug>>:NS_BLOCK_ASSERTIONS=1>)

  # Generate separate .dSYM debugging symbols
  # See https://developer.apple.com/documentation/xcode/building-your-app-to-include-debugging-information
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
  set(CMAKE_OBJC_FLAGS "${CMAKE_OBJC_FLAGS} -g")
  set(CMAKE_OBJCXX_FLAGS "${CMAKE_OBJCXX_FLAGS} -g")
  set(CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym")
endif()

# See https://developers.redhat.com/articles/2023/07/04/developers-guide-secure-coding-fortifysource
if(NOT UNIX AND (NOT CMAKE_BUILD_TYPE STREQUAL "Debug"))
  add_compile_definitions($<$<CONFIG:Debug>:_FORTIFY_SOURCE=2>)
endif()

add_compile_options(
  -Wall
  -Wextra
  -Werror
  -Wpedantic
  -Wshadow
  -Wconversion
  -Wunused-parameter
  -Wtrigraphs
  -Wunreachable-code
  -Wmissing-braces
  -Wparentheses
  -Wswitch
  -Wunused-function
  -Wunused-label
  -Wunused-parameter
  -Wunused-variable
  -Wunused-value
  -Wempty-body
  -Wuninitialized
  -Wshadow
  -Wconversion
  -Wenum-conversion
  -Wfloat-conversion
  -Wimplicit-fallthrough
  -Wsign-compare
  -Wsign-conversion
  -Wunknown-pragmas)

# C++ warnings
add_compile_options(
  -Wnon-virtual-dtor
  -Woverloaded-virtual
  -Wno-exit-time-destructors
  -Winvalid-offsetof
)

if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
  add_compile_options(
    # Common warnings
    -Wbool-conversion
    -Wint-conversion
    -Wpointer-sign
    -Wconditional-uninitialized
    -Wconstant-conversion
    -Wnon-literal-null-conversion
    -Wshorten-64-to-32
    -Wdeprecated-implementations
    -Winfinite-recursion
    -Wnewline-eof
    -Wfour-char-constants
    -Wselector
    -Wundeclared-selector
    # C++ warnings
    -Wdocumentation
    -Wmove
    -Wc++11-extensions
    -Wrange-loop-analysis)
endif()

if(APPLE)
  # Objective-C warnings
  add_compile_options(
    -Wdeprecated-objc-isa-usage
    -Wno-objc-interface-ivars
    -Wobjc-root-class
    -Wobjc-literal-conversion
    -Warc-repeated-use-of-weak
    -Wnon-modular-include-in-framework-module
    -Werror=non-modular-include-in-framework-module
    -Wmissing-field-initializers
    -Wmissing-prototypes
    -Wreturn-type
    -Wquoted-include-in-framework-header
    -Wimplicit-atomic-properties
    -Wimplicit-retain-self
    -Wduplicate-method-match
    -Wblock-capture-autoreleasing
    -Wstrict-prototypes
    -Wsemicolon-before-method-body
    -Wprotocol
    -Wdeprecated-declarations)
endif()
