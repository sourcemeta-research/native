noa_library(
  NAMESPACE sourcemeta
  PROJECT native
  NAME window
  VARIANT win32
  FOLDER "Native/Ui/Window"
  SOURCES window_win32.cc)

noa_library_install(
  NAMESPACE sourcemeta
  PROJECT native
  NAME window
  VARIANT win32)
