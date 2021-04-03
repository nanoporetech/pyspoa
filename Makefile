build:
	python3 setup.py develop

test: build
	python3 tests/test_pyspoa.py

clean:
	rm -rf src/build build tmp dist *so *egg-info/ *~
	python setup.py clean
