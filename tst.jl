include("helpers.jl") 

triangle_graph = Undirected_MultiGraph(
    3,
    [(1, 2), (2,3), (1, 3)]
)

visualize_graph(triangle_graph)

MG = vertex_edge_matrix(triangle_graph)

TropG = tropical_linear_space(MG)