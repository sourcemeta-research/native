function(add_example EXAMPLE_NAME)
    set(EXAMPLE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${EXAMPLE_NAME}")
    set(EXAMPLE_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/${EXAMPLE_NAME}")
    set(EXAMPLE_APP_NAME "${EXAMPLE_NAME}_app")

    # Configure target
    add_custom_target(${EXAMPLE_NAME}_configure
        COMMAND "${CMAKE_COMMAND}"
        -S "${EXAMPLE_SOURCE_DIR}"
        -B "${EXAMPLE_BINARY_DIR}"
        "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
        "-DCMAKE_PREFIX_PATH:PATH=${PROJECT_SOURCE_DIR}/build/dist"
        "-DCMAKE_TOOLCHAIN_FILE:PATH=${CMAKE_TOOLCHAIN_FILE}"
        "-DCODESIGN_IDENTITY:STRING=${CODESIGN_IDENTITY}"
        COMMENT "Configuring ${EXAMPLE_NAME} example"
    )

    # Build target
    add_custom_target(${EXAMPLE_NAME}_build
        COMMAND "${CMAKE_COMMAND}"
        --build "${EXAMPLE_BINARY_DIR}"
        COMMENT "Building ${EXAMPLE_NAME} example"
    )
    add_dependencies(${EXAMPLE_NAME}_build ${EXAMPLE_NAME}_configure)

    # Run target
    if(EXISTS "${EXAMPLE_BINARY_DIR}/${EXAMPLE_APP_NAME}.app")
        add_custom_target(${EXAMPLE_NAME}_run
            COMMAND "${EXAMPLE_BINARY_DIR}/${EXAMPLE_APP_NAME}.app/Contents/MacOS/${EXAMPLE_APP_NAME}"
            COMMENT "Running ${EXAMPLE_NAME} example"
        )
    else()
        add_custom_target(${EXAMPLE_NAME}_run
            COMMAND "${EXAMPLE_BINARY_DIR}/${EXAMPLE_APP_NAME}"
            COMMENT "Running ${EXAMPLE_NAME} example"
        )
    endif()
    add_dependencies(${EXAMPLE_NAME}_run ${EXAMPLE_NAME}_build)
endfunction()
