CMAKE = cmake

all: configure build

configure: .always
	$(CMAKE) -S . -B ./build

build: configure .always
	$(CMAKE) --build ./build

test: build
	./build/example/hello_world/example_hello_world
	@if [ $$? -eq 0 ]; then \
		echo "Success: The program exited with status code 0"; \
	else \
		echo "Error: The program did not exit with status code 0"; \
		exit 1; \
	fi

clean:
	rm -rf ./build

.always:
