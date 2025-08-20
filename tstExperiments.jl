include("helpers.jl")

###
# 1. Create constructors for all Laman graphs with small number of vertices
###

G = triangle_wheel(6)
MG = matroid_from_matrix_columns(vertex_edge_matrix(G))
LG = lattice_of_flats(MG)
CFG = maximal_chains(LG)

# # currently does not work, wait for answer on slack
# F1 = reduce_chain(CFG[1])
# F2 = reduce_chain(CFG[2])

F1 = [[1], [2,3], [4,5], [6,7], [8,9]]
F2 = [[1], [2,3], [4,5], [8], [7,8,9]]
