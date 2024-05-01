<p align="center"><img src="./logo.png" alt="native framework logo"/></p>
<h1 align="center">native</h1>
<h3 align="center">Build your macOS app with C++</h3>

Native is a robust C++ framework designed to streamline the development of native applications for C++ developers.

> ✋ Native is currently available for macOS. Support for Windows and Linux is under development and will be coming soon.

## ✨ Features

-  🚀 **Modern C++ API**: Streamlined API for modern C++.
-  🛠 **CMake Integration**: Seamless integration with CMake projects.
-  📦 **Packaging Ready**: Includes code signing and notarization.
-  🧩 **Modular Architecture**: Opt-in modules for tailored functionality.


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
   #include "native/ui/text.h"
   #include "native/ui/containers.h"
   #include "native/ui/window.h"
   #include "native/app.h"

   int main() {
       Window window{800, 600};
       Text text{"Hello, world!"};
       
       Container::HStack h_stack{};
       h_stack.add(&text);
       h_stack.position(Container::Centered);

       window.add(&h_stack);

       Application app = Application();
       app.setWindow(&window);
       app.run();

       return 0;
   }
   ```

2. Configure!

   ```json
   {
       "main": "main.cc",
       "version": "1.0.0",
       "name": "My application",
       "description": "This is the description of my app.",
       "modules": ["ui"]
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
   #include "native/ui/text.h"
   #include "native/ui/containers.h"
   #include "native/ui/window.h"
   #include "native/app.h"

   int main() {
       Window window{800, 600};
       Text text{"Hello, world!"};
       
       Container::HStack h_stack{};
       h_stack.add(&text);
       h_stack.position(Container::Centered);

       window.add(&h_stack);

       Application app = Application();
       app.setWindow(&window);
       app.run();

       return 0;
   }
   ```

2. Configure!

   ```cmake
   find_package(Native VERSION 1.0)

   # This macro generates custom CMake targets!!!!
   # native-app-develop
   # native-app-package
   native_add_app(
     TARGET app
     PLATFORM desktop 
     SOURCES main.cc)

   native_set_profile(app NAME "My App")
   native_set_profile(app DESCRIPTION "My first Native app")
   native_set_profile(app VERSION 1.0.0)
   native_set_profile(app MODULES "ui")

   # Then you can link whatever existing tragets to the `app` target. 
   ```

3. Develop!

   ```shell
   cmake --build . --config Debug --target native-app-develop
   ```

4. Release!

   ```shell
   cmake --build . --config Debug --target native-app-package
   ```
