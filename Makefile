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

test-cli: build
	$(CMAKE) --build build --target cli_run --config $(PRESET)

test-hello-world: build
	$(CMAKE) --build build --target hello_world_run --config $(PRESET)

test: test-cli test-hello-world

clean:
	$(CMAKE) -E rm -R -f build

# For NMake, which doesn't support .PHONY
.always:
