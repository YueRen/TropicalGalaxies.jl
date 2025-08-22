include("helpers.jl")

###
# 1. Create constructors for all Laman graphs with small number of vertices
###

G = triangle_wheel(6)
MatG = vertex_edge_matrix(G)
MG = matroid_from_matrix_columns(MatG)
LG = lattice_of_flats(MG)
CFG = maximal_chains(LG)

# # currently does not work, wait for answer on slack
F1 = data.(CFG[1])
F2 = data.(CFG[2])

is_bergman_transverse(F1,F2)
