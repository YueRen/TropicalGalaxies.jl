include("helpers.jl")

using Oscar
G = Dict((1,2) => 1,
         (1,3) => 2,
         (2,3) => 3,
         (2,4) => 4,
         (3,4) => 5,
         (3,5) => 6,
         (4,5) => 7,
         (4,6) => 8,
         (5,6) => 9)
n = 6
edgeToRemove = (2,3)
verticesToExcise = [first(edgeToRemove), last(edgeToRemove)]
vertexToAdd = n + 1

# TODO: write the following function in helpers.jl:
excise(G,edgeToRemove,n)












# For bug report
using Oscar
g = graph_from_edges([[1,2], [1,3], [2,3], [2,4], [3,4], [3,5], [4,5], [4,6], [5,6]])
visualize(g)
