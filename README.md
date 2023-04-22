# pyspoa

![test-pyspoa](https://github.com/nanoporetech/pyspoa/workflows/test-pyspoa/badge.svg) [![PyPI version](https://badge.fury.io/py/pyspoa.svg)](https://badge.fury.io/py/pyspoa)

Python bindings to [spoa](https://github.com/rvaser/spoa).

## Installation

```bash
$ pip install pyspoa
```

## Usage

```python
>>> from spoa import poa
>>>
>>> consensus, msa = poa(['AACTTATA', 'AACTTATG', 'AACTATA'])
>>> consensus
'AACTTATA'
>>> msa
['AACTTATA-', 'AACTTAT-G', 'AAC-TATA-']
>>> print(os.linesep.join(msa))
AACTTATA-
AACTTAT-G
AAC-TATA-
```

## Developer Quick Start

```bash
$ git clone --recursive https://github.com/nanoporetech/pyspoa.git
$ cd pyspoa
$ python3 -m venv pyspoa
$ source pyspoa/bin/activate
(pyspoa) $ make build
```

### Licence and Copyright
(c) 2019 Oxford Nanopore Technologies Ltd.

pyspoa is distributed under the terms of the MIT License.  If a copy of the License
was not distributed with this file, You can obtain one at https://github.com/nanoporetech/pyspoa

### Research Release

Research releases are provided as technology demonstrators to provide early access to features or stimulate Community development of tools. Support for this software will be minimal and is only provided directly by the developers. Feature requests, improvements, and discussions are welcome and can be implemented by forking and pull requests. However much as we would like to rectify every issue and piece of feedback users may have, the developers may have limited resource for support of this software. Research releases may be unstable and subject to rapid iteration by Oxford Nanopore Technologies.
