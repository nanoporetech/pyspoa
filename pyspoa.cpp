#include "spoa.hpp"
#include <pybind11/stl.h>
#include <pybind11/pybind11.h>

using namespace pybind11::literals;  // for _a in pybind def

auto poa(std::vector<std::string> sequences, int algorithm, bool genmsa,
	 int m, int n, int g, int e, int q, int c) -> pybind11::tuple
{
    auto alignment_engine = spoa::AlignmentEngine::Create(
      static_cast<spoa::AlignmentType>(algorithm), m, n, g, e, q, c
    );

    spoa::Graph graph{};

    for (const auto& it: sequences) {
	    auto alignment = alignment_engine->Align(it, graph);
	    graph.AddAlignment(alignment, it);
    }

    auto consensus = graph.GenerateConsensus();
    std::vector<std::string> msa;
    if (genmsa)
        msa = graph.GenerateMultipleSequenceAlignment();
    return pybind11::make_tuple(consensus, msa);
}

PYBIND11_MODULE(spoa, m) {

    m.def(
       "poa", &poa, "",
       "sequences"_a, "algorithm"_a=0, "genmsa"_a=true,
       "m"_a=5, "n"_a=-4, "g"_a=-8, "e"_a=-6, "q"_a=-10, "c"_a=-4
    );

    m.attr("__version__") = VERSION_INFO;

}
