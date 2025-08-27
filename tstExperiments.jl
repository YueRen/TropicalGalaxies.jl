include("helpers.jl")

# TODO: investigate duplicates in excisions:
G = triangle_chain(4)
@time Gexcisions = all_excisions(G);
HHH3 = Gexcisions[3]
HHH3[9] in HHH3[1:8]

for i in 2:length(HHH3)
    println(HHH3[i] in HHH3[1:i-1])
end


G = laman_graph(6,1)
Gexcisions = all_excisions(G);


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
