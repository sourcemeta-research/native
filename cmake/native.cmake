function(native_add_app)
  if(APPLE)
    _native_add_app_apple(${ARGN})
  elseif(WIN32)
    _native_add_app_win32(${ARGN})
  else()
    message(FATAL_ERROR "We only support Apple and Win32 platforms")
  endif()
endfunction()

# Function to set profile properties for the app, including code signing identity
function(native_set_profile)
    if(APPLE)
        _native_set_profile_apple(${ARGN})
    elseif(WIN32)
        _native_set_profile_win32(${ARGN})
    else()
        message(FATAL_ERROR "We only support Apple and Win32 platforms")
    endif()
endfunction()

#
#
#
# Apple platform private functions
#
#
#

function(_native_add_app_apple)
  cmake_parse_arguments(NATIVE "" "TARGET;PLATFORM" "SOURCES" ${ARGN})

    if("${NATIVE_PLATFORM}" STREQUAL "desktop")
        add_executable(${NATIVE_TARGET} ${NATIVE_SOURCES})
        set_target_properties(${NATIVE_TARGET} PROPERTIES
            MACOSX_BUNDLE TRUE
        )
        target_link_libraries(${NATIVE_TARGET} sourcemeta::native::application::appkit)
    elseif ("${NATIVE_PLATFORM}" STREQUAL "cli")
        add_executable(${NATIVE_TARGET} ${NATIVE_SOURCES})
        target_link_libraries(${NATIVE_TARGET} sourcemeta::native::application::foundation)
    else()
      message(FATAL_ERROR "Unsupported platform: ${NATIVE_PLATFORM}")
    endif()
endfunction()

function(_native_set_profile_apple)
    set(INFO_PLIST_PATH "${CMAKE_PREFIX_PATH}/lib/cmake/native/Info.plist")
    if(NOT EXISTS "${INFO_PLIST_PATH}")
        message(FATAL_ERROR "Info.plist file not found: ${INFO_PLIST_PATH}")
    endif()

    cmake_parse_arguments(NATIVE_PROPERTIES "" "TARGET;NAME;IDENTIFIER;VERSION;DESCRIPTION;CODESIGN_IDENTITY" "MODULES" ${ARGN})

    if (NATIVE_PROPERTIES_NAME)
        set_target_properties(${NATIVE_PROPERTIES_TARGET} PROPERTIES MACOSX_BUNDLE_BUNDLE_NAME ${NATIVE_PROPERTIES_NAME})
    endif()

    if (NATIVE_PROPERTIES_IDENTIFIER)
        set_target_properties(${NATIVE_PROPERTIES_TARGET} PROPERTIES MACOSX_BUNDLE_GUI_IDENTIFIER ${NATIVE_PROPERTIES_IDENTIFIER})
    endif()

    if (NATIVE_PROPERTIES_VERSION)
        set_target_properties(${NATIVE_PROPERTIES_TARGET} PROPERTIES MACOSX_BUNDLE_BUNDLE_VERSION ${NATIVE_PROPERTIES_VERSION})
        set_target_properties(${NATIVE_PROPERTIES_TARGET} PROPERTIES MACOSX_BUNDLE_SHORT_VERSION_STRING ${NATIVE_PROPERTIES_VERSION})
        set_target_properties(${NATIVE_PROPERTIES_TARGET} PROPERTIES MACOSX_BUNDLE_LONG_VERSION_STRING ${NATIVE_PROPERTIES_VERSION})
    endif()

    if (NATIVE_PROPERTIES_DESCRIPTION)
        set_target_properties(${NATIVE_PROPERTIES_TARGET} PROPERTIES MACOSX_BUNDLE_COPYRIGHT ${NATIVE_PROPERTIES_DESCRIPTION})
    endif()

    if (NATIVE_PROPERTIES_CODESIGN_IDENTITY)
        set_target_properties(${NATIVE_PROPERTIES_TARGET} PROPERTIES CODESIGN_IDENTITY ${NATIVE_PROPERTIES_CODESIGN_IDENTITY})
        _native_codesign_apple(TARGET "${NATIVE_PROPERTIES_TARGET}")
    endif()

    set_target_properties(${NATIVE_PROPERTIES_TARGET} PROPERTIES MACOSX_BUNDLE_INFO_PLIST ${INFO_PLIST_PATH})

    # Iterate over the modules and link them
    foreach(module IN LISTS NATIVE_PROPERTIES_MODULES)
        _native_link_modules_apple(TARGET ${NATIVE_PROPERTIES_TARGET} MODULE ${module})
    endforeach()
endfunction()

function(_native_codesign_apple)
    cmake_parse_arguments(NATIVE ""
      "TARGET" "" ${ARGN})

    get_target_property(CODESIGN_IDENTITY ${NATIVE_TARGET} "CODESIGN_IDENTITY")
    if(NOT CODESIGN_IDENTITY)
        message(FATAL_ERROR "You must specify a code sign identity")
    endif()
    
    set(ENTITLEMENTS_PATH "${CMAKE_PREFIX_PATH}/lib/cmake/native/entitlements.plist")
    if(NOT EXISTS "${ENTITLEMENTS_PATH}")
        message(FATAL_ERROR "Entitlements file not found: ${ENTITLEMENTS_PATH}")
    endif()

    get_target_property(TARGET_TYPE ${NATIVE_TARGET} TYPE)
    if(TARGET_TYPE STREQUAL "EXECUTABLE")
        get_target_property(IS_BUNDLE ${NATIVE_TARGET} MACOSX_BUNDLE)
    else()
        set(IS_BUNDLE FALSE)
    endif()

    if(IS_BUNDLE)
        set(TARGET_PATH $<TARGET_BUNDLE_DIR:${NATIVE_TARGET}>)
    else()
        set(TARGET_PATH $<TARGET_FILE:${NATIVE_TARGET}>)
    endif()

    if(IS_BUNDLE)
        add_custom_command(
            TARGET ${NATIVE_TARGET}
            POST_BUILD
            COMMAND /usr/bin/codesign --deep --force --verbose --timestamp --options=runtime --entitlements ${ENTITLEMENTS_PATH} --sign ${CODESIGN_IDENTITY} ${TARGET_PATH}
        )
    else()
        add_custom_command(
            TARGET ${NATIVE_TARGET}
            POST_BUILD
            COMMAND /usr/bin/codesign --force --verbose --timestamp --options=runtime --sign ${CODESIGN_IDENTITY} ${TARGET_PATH}
        )
    endif()
    add_custom_command(
        TARGET ${NATIVE_TARGET}
        POST_BUILD
        COMMAND /usr/bin/codesign --verify -R='anchor trusted' --verbose --strict=all --all-architectures ${TARGET_PATH}
    )
endfunction()

function(_native_link_modules_apple)
    cmake_parse_arguments(NATIVE_MODULE "" "TARGET;MODULE" "" ${ARGN})

    # Link the module to the target
    if(${NATIVE_MODULE_MODULE} STREQUAL "ui/window")
        target_link_libraries(${NATIVE_MODULE_TARGET} sourcemeta::native::window::appkit)
    elseif(${NATIVE_MODULE_MODULE} STREQUAL "sysmod/args")
        target_link_libraries(${NATIVE_MODULE_TARGET} sourcemeta::native::args::foundation)
    else()
        message(WARNING "Unknown module: ${NATIVE_MODULE_MODULE}")
    endif()
endfunction()


#
#
#
# Windows platform private functions
#
#
#

function(_native_add_app_win32)
  cmake_parse_arguments(NATIVE "" "TARGET;PLATFORM" "SOURCES;MODULES" ${ARGN})

  add_executable(${NATIVE_TARGET} WIN32 ${NATIVE_SOURCES})

  target_link_libraries(${NATIVE_TARGET} sourcemeta::native::application::win32)
endfunction()

function(_native_set_profile_win32)
    set(RESOURCE_RC_PATH "${CMAKE_PREFIX_PATH}/lib/cmake/native/resource.rc.in")
    if(NOT EXISTS "${RESOURCE_RC_PATH}")
        message(FATAL_ERROR "Resource.rc file not found: ${RESOURCE_RC_PATH}")
    endif()

    cmake_parse_arguments(NATIVE_PROPERTIES ""
        "TARGET;NAME;IDENTIFIER;DESCRIPTION;VERSION"
        "MODULES" ${ARGN})

    # TODO(tonygo): check that the .rc file is filled out properly
    configure_file(
        "${RESOURCE_RC_PATH}"
        "${CMAKE_CURRENT_BINARY_DIR}/resource.rc"
        @ONLY
    )

    target_sources(${NATIVE_PROPERTIES_TARGET} PRIVATE
        "${CMAKE_CURRENT_BINARY_DIR}/resource.rc"
    )

    # Iterate over the modules and link them
    foreach(module IN LISTS NATIVE_PROPERTIES_MODULES)
        _native_link_modules_win32(TARGET ${NATIVE_PROPERTIES_TARGET} MODULE ${module})
    endforeach()
endfunction()

function(_native_link_modules_win32)
    cmake_parse_arguments(NATIVE_MODULE "" "TARGET;MODULE" "" ${ARGN})

    # Link the module to the target
    if(${NATIVE_MODULE_MODULE} STREQUAL "ui/window")
        target_link_libraries(${NATIVE_MODULE_TARGET} sourcemeta::native::window::win32)
    else()
        message(WARNING "Unknown module: ${NATIVE_MODULE_MODULE}")
    endif()
endfunction()
