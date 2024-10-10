function(native_add_app)
  cmake_parse_arguments(NATIVE "" "TARGET;PLATFORM" "SOURCES" ${ARGN})

    # TODO(tony-go): Add support for CLI
    if("${NATIVE_PLATFORM}" STREQUAL "desktop")
        add_executable(${NATIVE_TARGET} ${NATIVE_SOURCES})

        set_target_properties(${NATIVE_TARGET} PROPERTIES
            MACOSX_BUNDLE TRUE # TODO(tony-go): should be only for desktop not cli 
        )

        target_link_libraries(${NATIVE_TARGET} sourcemeta::native::application)
    else()
      message(FATAL_ERROR "Unsupported platform: ${NATIVE_PLATFORM}")
    endif()
endfunction()

# Function to set profile properties for the app, including code signing identity
function(native_set_profile)
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
        _native_codesign(TARGET "${NATIVE_PROPERTIES_TARGET}")
    endif()

    set_target_properties(${NATIVE_PROPERTIES_TARGET} PROPERTIES MACOSX_BUNDLE_INFO_PLIST ${INFO_PLIST_PATH})

    # Iterate over the modules and link them
    foreach(module IN LISTS NATIVE_PROPERTIES_MODULES)
        _native_link_module(TARGET ${NATIVE_PROPERTIES_TARGET} MODULE ${module})
    endforeach()
endfunction()

# Internal function to link a module
function(_native_link_module)
    cmake_parse_arguments(NATIVE_MODULE "" "TARGET;MODULE" "" ${ARGN})

    # Link the module to the target
    if(${NATIVE_MODULE_MODULE} STREQUAL "ui/window")
        target_link_libraries(${NATIVE_MODULE_TARGET} sourcemeta::native::window)
    else()
        message(WARNING "Unknown module: ${NATIVE_MODULE_MODULE}")
    endif()
endfunction()

# Function to embed code signing into the build process
function(_native_codesign)
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

    add_custom_command(
        TARGET ${NATIVE_TARGET}
        POST_BUILD
        COMMAND /usr/bin/codesign --deep --force --verbose --timestamp --options=runtime --entitlements ${ENTITLEMENTS_PATH} --sign ${CODESIGN_IDENTITY} $<TARGET_BUNDLE_DIR:${NATIVE_TARGET}>
    )
    add_custom_command(
        TARGET ${NATIVE_TARGET}
        POST_BUILD
        COMMAND /usr/bin/codesign --verify -R='anchor trusted' --verbose --strict=all --all-architectures $<TARGET_BUNDLE_DIR:${NATIVE_TARGET}>
        )
endfunction()
