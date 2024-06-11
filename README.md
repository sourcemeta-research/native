<p align="center"><img width="300px" src="./logo.png" alt="native framework logo"/></p>
<h1 align="center">native</h1>
<h3 align="center">Build your macOS app with C++</h3>

Native is a robust C++ framework designed to streamline the development of native applications for C++ developers.

> ✋ Native is currently available for macOS. Support for Windows and GNU/Linux is under development and will be coming soon.

## ✨ Features

-  🚀 **Modern C++ API**: Streamlined API for modern C++.
-  🛠 **CMake Integration**: Seamless integration with CMake projects.
-  📦 **Packaging Ready**: Includes code signing and notarization.
-  🧩 **Modular Architecture**: Opt-in modules for tailored functionality.

## Install

### macOS

```
brew install native
```

## Getting Started with Native

Native can be seamlessly integrated into your projects in two distinct ways, depending on your setup and preferences:

- **Command Line Interface (CLI)**: Ideal for developers beginning a new project from scratch. 
  The CLI provides a simplified, straightforward method to scaffold and manage your application 
  without manual setup complexities.

- **CMake Macros**: Best suited for developers looking to integrate Native into an existing CMake project.
  This method leverages custom CMake macros to facilitate integration, ensuring that you can easily include 
  Native without disrupting your project's existing structure.

### CLI

1. Code!
   
   ```cc
   #include <sourcemeta/native/ui/text.h>
   #include <sourcemeta/native/ui/container.h>
   #include <sourcemeta/native/ui/window.h>
   #include <sourcemeta/native/app.h>

   using sourcemeta::native::ui;

   class App: public sourcemeta::native::Application {
   public:
       auto on_start() -> void override {}

       auto on_ready() -> void override {
           container.position(Container::Position::Horizontal);
           text.set("Hello, world!");
           container.add(text);

           window.add(container);
           window.size(800, 600);
           window.show();
       }

       auto on_error(std::exception_ptr) noexcept -> void override {}

   private:
       Window window;
       Container container;
       Text text;
   };

   NATIVE_RUN(App);
   ```

2. Configure!

   ```json
   {
       "sources": [ "main.cc" ],
       "version": "1.0.0",
       "name": "My application",
       "description": "This is the description of my app.",
       "modules": [ "ui/text", "ui/container", "ui/window" ]
   }
   ```

3. Develop!

   ```shell
   native desktop develop
   ```

4. Release!

   ```shell
   native desktop package
   ```

### CMake

1. Code!
   
   ```cc
   #include <sourcemeta/native/ui/text.h>
   #include <sourcemeta/native/ui/container.h>
   #include <sourcemeta/native/ui/window.h>
   #include <sourcemeta/native/app.h>

   using sourcemeta::native::ui;

   class App: public sourcemeta::native::Application {
   public:
       auto on_start() -> void override {}

       auto on_ready() -> void override {
           container.position(Container::Position::Horizontal);
           text.set("Hello, world!");
           container.add(text);

           window.add(container);
           window.size(800, 600);
           window.show();
       }

       auto on_error(std::exception_ptr) noexcept -> void override {}

   private:
       Window window;
       Container container;
       Text text;
   };

   NATIVE_RUN(App);
   ```

2. Configure!

   ```cmake
   cmake_minimum_required(VERSION 3.26)

   project(my_native_app LANGUAGES CXX)

   find_package(Native VERSION 1.0)

   # This macro generates the following CMake targets:
   # - native-app-develop
   # - native-app-package
   native_add_app(
     TARGET app
     PLATFORM desktop 
     SOURCES main.cc)

   native_set_profile(
     TARGET app
     NAME "My App"
     GUI_IDENTIFIER "com.native.my_app"
     VERSION "1.0.0"
     DESCRIPTION "My app first native app"
     CODESIGN_IDENTITY "W4MF6H9XZ6"
     MODULES "ui/window" "ui/container" "ui/text")

   # Then you can link whatever existing tragets to the `app` target. 
   ```

3. Develop!

   ```shell
   cd build

   cmake .. --config Debug

   cmake --build . --config Debug --target native-app-develop
   ```

4. Release!

   ```shell
   cmake --build . --config Debug --target native-app-package
   ```

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

2. **Configure and build the project**:
    We use a Makefile to handle the build process, which in turn uses CMake. Simply run:
    ```sh
    make
    ```

    This will configure the project, build the necessary files, and run the executable.

3. **Running the Executable**:
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
