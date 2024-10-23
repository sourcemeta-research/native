CMAKE = cmake
PRESET = Debug

all: configure build install

configure: .always
	$(CMAKE) -S . -B ./build \
		-DCMAKE_BUILD_TYPE:STRING=$(PRESET) \
		-DCMAKE_INSTALL_PREFIX=./build/dist

build: configure .always
	$(CMAKE) --build ./build --config $(PRESET)

install: build
	$(CMAKE) --install ./build --prefix ./build/dist --config $(PRESET)

test: build
	cmake --build build --target hello_world_build --config $(PRESET)
	# cmake --build build --target cli_run --config $(PRESET)

clean:
	$(CMAKE) -E rm -R -f build

# For NMake, which doesn't support .PHONY
.always:
