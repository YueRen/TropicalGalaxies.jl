include("helpers.jl") 


g = triangle_wheel(6)


visualize_graph(g)

g1 = excise(g,[1,2])
visualize_graph(g1)

g2 = excise(g,[1,2,3])
visualize_graph(g2)


MG = vertex_edge_matrix(g)

TropG = tropical_linear_space(MG)

TropGNeg = -TropG

# TropG * (-TropG)


# # Tests 
# g1 = Undirected_MultiGraph(
#     5,
#     [(2, 1), (3, 1), (4, 3), (5, 3)]
# )

# g2 = Undirected_MultiGraph(
#     7,
#     [(2, 1), (3, 1), (5, 4), (6, 4), (7, 6)]
# )

# g3 = Undirected_MultiGraph(
#     7,
#     [(2, 1), (3, 1), (5, 4), (6, 4), (7, 6), (7, 5)]
# )


# is_forest(triangle_wheel(4)) # neither
# is_forest(g1) # tree
# is_forest(g2) # forest
# is_forest(g3) # neither

# g = laman_graphs(5)[1]
# visualize_graph(g)
