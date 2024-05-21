CMAKE = cmake

all: configure build

configure:
	$(CMAKE) -S . -B ./build -G "Xcode" -DCMAKE_BUILD_TYPE=Debug

build: configure
	$(CMAKE) --build ./build

clean:
	rm -rf ./build
