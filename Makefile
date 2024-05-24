CMAKE = cmake

all: configure build

configure: .always
	$(CMAKE) -S . -B ./build -G "Xcode"

build: configure .always
	$(CMAKE) --build ./build

clean:
	rm -rf ./build

.always:
