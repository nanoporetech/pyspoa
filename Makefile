build:
	pip wheel . -w dist

install: build
	pip install dist/pyspoa*.whl

test: install
	python3 tests/test_pyspoa.py

clean:
	rm -rf src/build build tmp var *~ *.whl __pycache__
	python setup.py clean
	pip uninstall -y pyspoa
