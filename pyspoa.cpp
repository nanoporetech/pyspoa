#include "spoa.hpp"
#include <pybind11/stl.h>
#include <pybind11/pybind11.h>

using namespace std;
using namespace spoa;
using namespace pybind11;
using namespace pybind11::literals;


auto poa(vector<string> sequences, int algorithm, bool genmsa,
	 int m, int n, int g, int e, int q, int c) -> pybind11::tuple
{
    auto alignment_engine = createAlignmentEngine(
       static_cast<AlignmentType>(algorithm), m, n, g, e, q, c
    );

    auto graph = createGraph();

    for (const auto& it: sequences) {
	auto alignment = alignment_engine->align(it, graph);
	graph->add_alignment(alignment, it);
    }

    string consensus = graph->generate_consensus();
    vector<string> msa;
    if (genmsa) graph->generate_multiple_sequence_alignment(msa);
    return make_tuple(consensus, msa);
}

PYBIND11_MODULE(spoa, m) {

    m.def(
       "poa", &poa, "",
       "sequences"_a, "algorithm"_a=0, "genmsa"_a=true,
       "m"_a=5, "n"_a=-4, "g"_a=-8, "e"_a=-6, "q"_a=-10, "c"_a=-4
    );

    m.attr("__version__") = VERSION_INFO;

}
