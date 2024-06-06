set(TARGET_NAME example_hello_world)
set(CODESIGN_IDENTITY "W4MF6H9XZ6")

add_executable("${TARGET_NAME}" MACOSX_BUNDLE hello_world.cc)
target_link_libraries("${TARGET_NAME}" sourcemeta::native::application)
target_link_libraries("${TARGET_NAME}" sourcemeta::native::window)

set(CMAKE_MACOSX_BUNDLE YES)
set_target_properties("${TARGET_NAME}" PROPERTIES
  MACOSX_BUNDLE_BUNDLE_NAME "example_hello_world"
  MACOSX_BUNDLE_GUI_IDENTIFIER "com.native.example_hello_world"
  MACOSX_BUNDLE_BUNDLE_VERSION "1.0.0")

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist.in
    ${CMAKE_CURRENT_BINARY_DIR}/Info.plist
    @ONLY
)
set_target_properties("${TARGET_NAME}" PROPERTIES
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_BINARY_DIR}/Info.plist
)

add_custom_command(
    TARGET "${TARGET_NAME}"
    POST_BUILD
    COMMAND codesign --force --verbose --timestamp --options=runtime --entitlements "${CMAKE_CURRENT_SOURCE_DIR}/entitlements.plist" --sign "${CODESIGN_IDENTITY}" $<TARGET_BUNDLE_DIR:${TARGET_NAME}>
)

add_custom_command(
    TARGET "${TARGET_NAME}"
    POST_BUILD
    COMMAND codesign --verify -R='anchor trusted' --verbose --strict=all --all-architectures $<TARGET_BUNDLE_DIR:${TARGET_NAME}>
)
