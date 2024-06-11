CMAKE = cmake

all: configure build

configure: .always
	$(CMAKE) -S . -B ./build

build: configure .always
	$(CMAKE) --build ./build

test: build
	open ./build/example/hello_world/hello_world_app.app

clean:
	$(CMAKE) -E rm -R -f build

.always:
