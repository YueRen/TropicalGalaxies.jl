include("helpers.jl")

# TODO: investigate duplicates in excisions:
G = triangle_chain(6)
@time Gexcisions = all_excisions(G);
HHH5 = Gexcisions[5]
HHH4 = Gexcisions[4]
HHH3 = Gexcisions[3]
for i in 2:length(HHH3)
    println(HHH3[i] in HHH3[1:i-1])
end

visualize_graph(HHH5[1])
visualize_graph(HHH4[10])
visualize_graph(HHH3[7])
visualize_graph(HHH3[8])
HHH3[7]==HHH3[8]
edge_adjacency_matrix(HHH3[1]) == edge_adjacency_matrix(HHH3[8])

G = laman_graph(6,1)
Gexcisions = all_excisions(G);

triangle_sort(HHH4)
visualize_graph(HHH2[3])
triangle_group(triangle_sort(HHH4))

for i in 1:length(HHH4)
    HHH4i=HHH4[i]
    println(has_isolated_triangle(HHH4i))
end

has_isolated_triangle(HHH4[2])

tropical_linear_space(vertex_edge_matrix(HHH3[1])) * (-tropical_linear_space(vertex_edge_matrix(HHH2[3])))

tropical_intersection_product(HHH4[10], HHH3)




HHH = Gexcisions[length(Gexcisions)-1]
TTT = []
for HH in HHH
    b, TT = has_isolated_triangle(HH)
    if b == true
        push!(TTT, TT)
    end
end


HH = first(HHH)
NegTropHH = -tropical_linear_space(vertex_edge_matrix(HH))
FF = first(Gexcisions[end])
TropFF = tropical_linear_space(vertex_edge_matrix(FF))


MatG = vertex_edge_matrix(G)
MG = matroid_from_matrix_columns(MatG)
LG = lattice_of_flats(MG)
CFG = maximal_chains(LG)

# # currently does not work, wait for answer on slack
F1 = data.(CFG[1])
F2 = data.(CFG[2])

is_bergman_transverse(F1,F2)
