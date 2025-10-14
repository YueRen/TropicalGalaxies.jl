using TropicalGalaxies

G = triangle_chain(4)
visualize_graph(G)
visualize_excision_graph(gamma)

# arboreal pairs 
# find int = 1 

G1 = laman_graph(5,2)
tropical_linear_space(tropical_star(G1))
gamma1 = tropical_galaxy(G1)
F1 = last(stars(gamma1))

G2 = laman_graph(5,3)
tropical_linear_space(tropical_star(G1))
gamma2 = tropical_galaxy(G2)
F2 = last(stars(gamma2))


arboreal_pair(F1, F2)

visualize_graph(F1)
visualize_graph(F2)


non_zero_int = Vector{Int}()
for (i, j) in enumerate(HHs) 
    TropH = TropicalGalaxy.tropical_linear_space(j)
    @time n = TropicalGalaxy.tropical_intersection_number(TropF, -TropH)
    if n >= 1
        push!(non_zero_int, i)
    end
end


TropF = TropicalGalaxy.Oscar.tropical_linear_space(TropicalGalaxy.vertex_edge_matrix(F1))
TropF2 = TropicalGalaxy.tropical_linear_space(F1)
for i in v 
    TropH = TropicalGalaxy.Oscar.tropical_linear_space(TropicalGalaxy.vertex_edge_matrix(FFs[i]))
    @time n1 = TropF * (-TropH)
    @time n2 = TropF2 * (-TropH)
    println("($i: $n1, $n2)")
end 


