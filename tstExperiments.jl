include("helpers.jl")

G = triangle_chain(7)
@time Gexcisions = all_excisions(G);
FFs = Gexcisions[6]
HHs = Gexcisions[5]

HHsSortedDict = triangle_group(triangle_sort(HHs))

# we see that i=15 and i=18 contain many graphs
for (i,(key,value)) in enumerate(HHsSortedDict)
    println(i," ",length(value))
end

fixedTriangle = collect(keys(HHsSortedDict))[15]

for (i,FF) in enumerate(FFs)
    TropFF = tropical_linear_space(FF)
    for (j,HH) in enumerate(HHsSortedDict[fixedTriangle])
        TropHH = tropical_linear_space(HH)
        println("($i,$j): ", TropFF * -TropHH)
    end
end



tropical_linear_space(vertex_edge_matrix(HHH3[1])) * (-tropical_linear_space(vertex_edge_matrix(HHH2[3])))

tropical_intersection_product(HHH5[10], HHH4)




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
