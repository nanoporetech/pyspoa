buildenv/bin/activate:
	python3 -m venv buildenv

build: buildenv/bin/activate
	mkdir -p src/build
	. ./buildenv/bin/activate && pip install cmake && cd src/build && cmake -D spoa_generate_dispatch=ON -DCMAKE_BUILD_TYPE=Release -D CMAKE_CXX_FLAGS="-fPIC" .. && make
	python3 setup.py develop

test: build
	python3 tests/test_pyspoa.py

clean:
	rm -rf src/build build tmp *~
