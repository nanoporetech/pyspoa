build:
	mkdir -p src/build
	cd src/build && cmake -DCMAKE_BUILD_TYPE=Release -D CMAKE_CXX_FLAGS="-fPIC" .. && make
	python3 setup.py develop

test: build
	python3 tests/test_pyspoa.py

clean:
	rm -rf src/build build tmp *~
