noa_library(
  NAMESPACE sourcemeta
  PROJECT native
  NAME application
  VARIANT win32
  FOLDER "Native/Application"
  PRIVATE_HEADERS entry.h
  SOURCES app_win32.cc delegate_win32.h delegate_win32.cc)

noa_library_install(
  NAMESPACE sourcemeta
  PROJECT native
  NAME application
  VARIANT win32)

  target_link_libraries(sourcemeta_native_application_win32 PRIVATE
    user32
    gdi32
  )
