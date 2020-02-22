build:
	mkdir -p src/build
	cd src/build && cmake -DCMAKE_BUILD_TYPE=Release -D CMAKE_CXX_FLAGS="-fPIC" .. && make
	python setup.py develop

clean:
	rm -rf src/build build tmp *~
