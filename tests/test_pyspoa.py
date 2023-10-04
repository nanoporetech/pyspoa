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

    def test_bindings_min_coverage(self):
        """ simple poa to check bindings with `min_coverage` param"""
        consensus, msa = poa(['AACTTATA', 'AACTTATG', 'AACTATA'], min_coverage=3)
        self.assertEqual(consensus, 'AACTAT')
        self.assertEqual(len(msa), 3)

    def test_bindings_min_coverage_None(self):
        """ simple poa to check bindings with `min_coverage=None`"""
        consensus, msa = poa(['AACTTATA', 'AACTTATG', 'AACTATA'], min_coverage=None)
        self.assertEqual(consensus, 'AACTTATA')
        self.assertEqual(len(msa), 3)

    def test_bindings_min_coverage_wrong_type_string(self):
        """ check that bindings with `min_coverage=str` throw error"""
        self.assertRaises(
            RuntimeError, poa, ["AACTTATA", "AACTTATG", "AACTATA"], min_coverage="x"
        )

    def test_bindings_min_coverage_wrong_type_float(self):
        """ check that bindings with `min_coverage=float` throw error"""
        self.assertRaises(
            RuntimeError, poa, ["AACTTATA", "AACTTATG", "AACTATA"], min_coverage=1.5
        )


if __name__ == '__main__':
    main()
