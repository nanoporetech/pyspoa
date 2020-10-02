build:
	mkdir -p spoa/build
	cd spoa/build && cmake -D spoa_generate_dispatch=ON -DCMAKE_BUILD_TYPE=Release -D CMAKE_CXX_FLAGS="-fPIC" .. && make
	python3 setup.py develop

test: build
	python3 tests/test_pyspoa.py

clean:
	rm -rf spoa/build build tmp *~
