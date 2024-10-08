CMAKE = cmake

all: configure build install

configure: .always
	$(CMAKE) -DCMAKE_INSTALL_PREFIX=./build/dist -S . -B ./build

build: configure .always
	$(CMAKE) --build ./build

install: build
	$(CMAKE) --install ./build --prefix ./build/dist

test: build
	open ./build/example/hello_world/hello_world_app.app

clean:
	$(CMAKE) -E rm -R -f build

.always:
