#!/usr/env/bin python3

from spoa import poa
from unittest import TestCase, main


class Tests(TestCase):

    def test_bindings(self):
        """ simple poa to check bindings"""
        consensus, msa = poa(['AACTTATA', 'AACTTATG', 'AACTATA'])
        self.assertEqual(consensus, 'AACTTATA')
        self.assertEqual(len(msa), 3)

    def test_bindings_no_msa(self):
        """ simple poa to check bindings with msa generation"""
        consensus, msa = poa(['AACTTATA', 'AACTTATG', 'AACTATA'], genmsa=False)
        self.assertEqual(consensus, 'AACTTATA')
        self.assertEqual(len(msa), 0)


if __name__ == '__main__':
    main()
