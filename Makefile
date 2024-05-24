CMAKE = cmake

all: configure build

configure: .always
	$(CMAKE) -S . -B ./build -G "Xcode" -DCMAKE_BUILD_TYPE=Debug

build: configure .always
	$(CMAKE) --build ./build

clean:
	rm -rf ./build

.always:
