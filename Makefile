CMAKE = cmake

all: configure build install

configure: .always
	$(CMAKE) -DCMAKE_INSTALL_PREFIX=./build/dist -S . -B ./build

build: configure .always
	$(CMAKE) --build ./build

install: build
	$(CMAKE) --install ./build --prefix ./build/dist

test: build
	cmake --build build --target hello_world_run
	# cmake --build build --target cli_run

clean:
	$(CMAKE) -E rm -R -f build

.always:
