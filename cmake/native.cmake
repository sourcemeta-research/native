function(native_add_app)
  cmake_parse_arguments(NATIVE "" "TARGET;PLATFORM" "SOURCES" ${ARGN})
  
    if("${NATIVE_PLATFORM}" STREQUAL "desktop")
        add_executable(${NATIVE_TARGET} ${NATIVE_SOURCES})

        set_target_properties(${NATIVE_TARGET} PROPERTIES
            MACOSX_BUNDLE TRUE # TODO(tony-go): should be only for desktop not cli 
        )

        target_link_libraries(${NATIVE_TARGET} sourcemeta::native::application)
        target_link_libraries(${NATIVE_TARGET} sourcemeta::native::window)
    else()
      message(FATAL_ERROR "Unsupported platform: ${NATIVE_PLATFORM}")
    endif()
endfunction()

# Function to set profile properties for the app, including code signing identity
function(native_set_profile)
    cmake_parse_arguments(NATIVE_PROPERTIES "" "TARGET;NAME;GUI_IDENTIFIER;VERSION;DESCRIPTION;CODESIGN_IDENTITY" "" ${ARGN})

    if (NATIVE_PROPERTIES_NAME)
        set_target_properties(${NATIVE_PROPERTIES_TARGET} PROPERTIES MACOSX_BUNDLE_BUNDLE_NAME ${NATIVE_PROPERTIES_NAME})
    endif()

    if (NATIVE_PROPERTIES_GUI_IDENTIFIER)
        set_target_properties(${NATIVE_PROPERTIES_TARGET} PROPERTIES MACOSX_BUNDLE_GUI_IDENTIFIER ${NATIVE_PROPERTIES_GUI_IDENTIFIER})
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
        _native_codesign(TARGET "${NATIVE_PROPERTIES_TARGET}")
    endif()

    set_target_properties(${NATIVE_PROPERTIES_TARGET} PROPERTIES MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist)
endfunction()

# Function to embed code signing into the build process
function(_native_codesign)
    cmake_parse_arguments(NATIVE ""
      "TARGET" "" ${ARGN})

    get_target_property(CODESIGN_IDENTITY ${NATIVE_TARGET} "CODESIGN_IDENTITY")
    if(NOT CODESIGN_IDENTITY)
        message(FATAL_ERROR "You must specify a code sign identity")
    endif()

    # Check if entitlements file exists
    set(ENTITLEMENTS_FILE "${CMAKE_CURRENT_SOURCE_DIR}/entitlements.plist")
    if(EXISTS ${ENTITLEMENTS_FILE})
        add_custom_command(
            TARGET ${NATIVE_TARGET}
            POST_BUILD
            COMMAND /usr/bin/codesign --deep --force --verbose --timestamp --options=runtime --entitlements ${ENTITLEMENTS_FILE} --sign ${CODESIGN_IDENTITY} $<TARGET_BUNDLE_DIR:${NATIVE_TARGET}>
        )
        add_custom_command(
            TARGET ${NATIVE_TARGET}
            POST_BUILD
            COMMAND /usr/bin/codesign --verify -R='anchor trusted' --verbose --strict=all --all-architectures $<TARGET_BUNDLE_DIR:${NATIVE_TARGET}>
        )
    else()
      message(ERROR "Entitlements file not found: ${ENTITLEMENTS_FILE}")
    endif()
endfunction()
