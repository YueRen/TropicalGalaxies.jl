include("helpers.jl") 

triangle_graph = Undirected_MultiGraph(
    3,
    [(2, 1), (2,1), (3, 1), (3, 2), (3,2)]
)

visualize_graph(triangle_graph)


