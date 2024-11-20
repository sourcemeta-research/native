<p align="center"><img width="300px" src="./assets/logo.png" alt="native framework logo"/></p>
<h1 align="center">native</h1>
<h3 align="center">Build your Desktop application with C++</h3>

Native is a C++ framework designed to streamline the development of native applications for C++ developers.

> ✋ Native is currently available in alpha for macOS and Windows, but *it is not production ready*!

## ✨ Features

-  🚀 **Modern C++ API**: Streamlined API for modern C++.
-  🛠 **CMake Integration**: Seamless integration with CMake projects.
-  📦 **Packaging Ready**: Includes code signing for macOS (notarization is comming)
-  🧩 **Modular Architecture**: Opt-in modules for tailored functionality.

### Roadmap

#### `ui`

| Module       | macOS Support       | Win32 Support       | Notes                                                           |
|--------------|---------------------|---------------------|-----------------------------------------------------------------|
| **Window**   | ✅ Supported        | ✅ Supported        | Basic window creation and management                            |
| **WebView**  | ✅ Supported        | ✅ Supported        | Embeds web content in a native app                              |
| **Menu**     | 🚧 Planned          | 🚧 Planned          | Application menus                                               |
| **IPC**      | 🚧 Planned          | 🚧 Planned          | Communication channel between the main process and the Webview. |
| **Tray**     | 🚧 Planned          | 🚧 Planned          | System tray icons and context menus                             |

#### `sysmod`

| Module           | macOS Support       | Win32 Support       | Notes                                         |
|------------------|---------------------|---------------------|-----------------------------------------------|
| **Open**         | 🚧 Planned          | 🚧 Planned          | Open URLs, URIs, and files                    |
| **Storage**      | 🚧 Planned          | 🚧 Planned          | Key-value storage for app data                |
| **HTTP Client**  | 🚧 Planned          | 🚧 Planned          | Send HTTP requests, handle responses          |

## Getting Started with Native using CMake

1. Code!

Create these three files at the root of your project.
   
```cc
// main.cc
#include <sourcemeta/native/application.h>
#include <sourcemeta/native/webview.h>
#include <sourcemeta/native/window.h>

#include <exception>
#include <iostream>

class App : public sourcemeta::native::Application {
public:
  auto on_start() -> void override { std::cout << "Starting!" << std::endl; }

  auto on_ready() -> void override {
    std::cout << "Ready!" << std::endl;

    window.size(1200, 900);
    window.show();

    webview.load_html("index.html");
    window.add(webview);

    this->exit();
  }

  auto on_error(std::exception_ptr) noexcept -> void override {}

private:
  sourcemeta::native::Window window;
  sourcemeta::native::WebView webview;
};

NATIVE_RUN(App)
```

```html
<!-- index.html -->
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Native Framework</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <h1>Welcome to Native</h1>
  <p>This is a simple example to demonstrate loading HTML with CSS styling.</p>
</body>
</html>
```

```css
/* style.css */
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100vh;
    background-color: #f0f0f0;
}
h1 {
    color: #333;
}
p {
    color: #666;
}
```

2. Configure!

```cmake
cmake_minimum_required(VERSION 3.14)

project(my_hello_world)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Native REQUIRED)

native_add_app(
    TARGET hello_world_app
    PLATFORM desktop
    SOURCES hello_world.cc)

native_add_assets(
    TARGET hello_world_app
    ASSETS index.html style.css)

native_set_profile(
    TARGET hello_world_app
    NAME "example_hello_world"
    IDENTIFIER "com.native.example_hello_world"
    VERSION "1.0.0"
    DESCRIPTION "My app ..."
    CODESIGN_IDENTITY "W4MF6H9XZ6"
    MODULES "ui/window" "ui/webview")
```


3. Build!

```shell
cmake -S . -B ./build 

cmake --build ./build
```

4. Enjoy!

The application is available in the `/dist` folder of your current directory.

![macos application build with native](./assets/macos_example.mov)

## Contributing

We welcome contributions to this project! To get started, please follow these steps.

### Prerequisites

Make sure you have the following tools installed:

- [CMake](https://cmake.org/)

### Building the Project

1. **Clone the repository**:
    ```sh
    git clone https://github.com/sourcemeta-research/native.git
    cd native
    ```
    
2. **Install dependencies**:
    ```sh
    git clone https://github.com/sourcemeta-research/native.git
    cd native
    ```

3. **Configure and build the project**:
    We use a Makefile to handle the build process, which in turn uses CMake. Simply run:
    ```sh
    make
    ```

    This will configure the project, build the necessary files, and run the executable.

4. **Running the Executable**:
    After building the project, you can run the executable to ensure everything is working as expected:
    ```sh
    make test
    ```

    The `make` command will handle this for you and check the exit status of the executable.

We highly advise you to explore and play with the project inside the `/example` folder.

### Cleaning Up

To clean the build directory, run:
```sh
make clean
```
