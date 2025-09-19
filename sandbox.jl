using TropicalGalaxy

G = TropicalGalaxy.triangle_chain(7)
@time Gexcisions = TropicalGalaxy.all_excisions(G);
FFs = Gexcisions[5]
HHs = Gexcisions[4]
F1 = FFs[5]
F2 = HHs[52]
TropicalGalaxy.visualize_graph(F1)
TropicalGalaxy.visualize_graph(F2)

# 52 56 59
v = [128, 129, 131, 132, 137, 138, 143, 144, 146, 147, 149, 150, 155, 156, 161, 162]

TropF = TropicalGalaxy.Oscar.tropical_linear_space(TropicalGalaxy.vertex_edge_matrix(F1))
TropF2 = TropicalGalaxy.tropical_linear_space(F1)
TropH = TropicalGalaxy.Oscar.tropical_linear_space(TropicalGalaxy.vertex_edge_matrix(F2))
n = TropF * (-TropH)
n1 = TropF2 * (-TropH)

u = TropicalGalaxy.Oscar.QQ.(rand(Int, TropicalGalaxy.Oscar.ambient_dim(TropF)))

TropF_shifted = TropicalGalaxy.Oscar.tropical_variety(TropF) + u
TropF2_shifted = TropicalGalaxy.Oscar.tropical_variety(TropF2) + u

for sigma in TropicalGalaxy.Oscar.maximal_polyhedra(TropF_shifted)
    for tau in TropicalGalaxy.Oscar.maximal_polyhedra(-TropH)
        sigma_tau = intersect(sigma, tau)
        if TropicalGalaxy.Oscar.dim(sigma_tau) > -1
            println(TropicalGalaxy.Oscar.minimal_faces(sigma_tau), TropicalGalaxy.Oscar.dim(sigma_tau))
        end
    end
end

TropicalGalaxy.Oscar.minimal_faces(TropicalGalaxy.Oscar.stable_intersection(TropF_shifted, -TropH))

for sigma in TropicalGalaxy.Oscar.maximal_polyhedra(TropF2_shifted)
    for tau in TropicalGalaxy.Oscar.maximal_polyhedra(-TropH)
        sigma_tau = intersect(sigma, tau)
        if TropicalGalaxy.Oscar.dim(sigma_tau) > -1
            println(TropicalGalaxy.Oscar.minimal_faces(sigma_tau), TropicalGalaxy.Oscar.dim(sigma_tau))
        end
    end
end

# TODO fix stable intersection in Oscar, should not be empty
TropicalGalaxy.Oscar.minimal_faces(TropicalGalaxy.Oscar.stable_intersection(TropF2_shifted, -TropH))


for (i, j) in enumerate(HHs) 
    TropH = TropicalGalaxy.Oscar.tropical_linear_space(TropicalGalaxy.vertex_edge_matrix(j))
    n = TropF * (-TropH)
    n1 = TropF2 * (-TropH)
    if n >= 1
        println("$i: ", n, " ", n1)
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




TropF = TropicalGalaxy.Oscar.tropical_linear_space(TropicalGalaxy.vertex_edge_matrix(F1))
TropH = TropicalGalaxy.Oscar.tropical_linear_space(TropicalGalaxy.vertex_edge_matrix(F2))

TropF2 = TropicalGalaxy.tropical_linear_space(F1)
TropH2 = TropicalGalaxy.tropical_linear_space(F2)

TropF * (-TropH)
TropF2 * (-TropH)

TropicalGalaxy.Oscar.dim(TropF)
TropicalGalaxy.Oscar.dim(TropF2)

poly_F = TropicalGalaxy.Oscar.polyhedral_complex(TropF)
poly_F2 = TropicalGalaxy.Oscar.polyhedral_complex(TropF2)

TropicalGalaxy.Oscar.vertices_and_rays(TropF)
TropicalGalaxy.Oscar.maximal_polyhedra(TropicalGalaxy.Oscar.IncidenceMatrix, TropF)
TropicalGalaxy.Oscar.vertices_and_rays(TropF2)   
TropicalGalaxy.Oscar.maximal_polyhedra(TropicalGalaxy.Oscar.IncidenceMatrix, TropF2)


W = TropicalGalaxy.Oscar.relative_interior_point.(TropicalGalaxy.Oscar.maximal_polyhedra(TropF))
R = TropicalGalaxy.Oscar.minimal_faces.(TropicalGalaxy.Oscar.maximal_polyhedra(TropF))
sigma = TropicalGalaxy.Oscar.maximal_polyhedra(TropF)[1]
R, _ = TropicalGalaxy.Oscar.rays_modulo_lineality(sigma)

for (j, sigma) in enumerate(TropicalGalaxy.Oscar.maximal_polyhedra(TropF)) 
    R, _ = TropicalGalaxy.Oscar.rays_modulo_lineality(sigma)
    for (i, r) in enumerate(R)
        println(j," ", i," ", findfirst(sigma -> (r in sigma), TropicalGalaxy.Oscar.maximal_polyhedra(TropF2)) )
    end
end

L = TropicalGalaxy.Oscar.lineality_space(TropF)

for (i, l) in enumerate(L)
    println(i," ", findfirst(sigma -> (l in sigma), TropicalGalaxy.Oscar.maximal_polyhedra(TropF2)) )
end

for (i, w) in enumerate(W)
    println(i," ", findfirst(sigma -> (w in sigma), TropicalGalaxy.Oscar.maximal_polyhedra(TropF2)) )
end


W = TropicalGalaxy.Oscar.relative_interior_point.(TropicalGalaxy.Oscar.maximal_polyhedra(TropF2))

for (i, w) in enumerate(W)
    println(i," ", findfirst(sigma -> (w in sigma), TropicalGalaxy.Oscar.maximal_polyhedra(TropF)) )
end

for (j, sigma) in enumerate(TropicalGalaxy.Oscar.maximal_polyhedra(TropF2)) 
    R, _ = TropicalGalaxy.Oscar.rays_modulo_lineality(sigma)
    for (i, r) in enumerate(R)
        println(j," ", i," ", findfirst(sigma -> (r in sigma), TropicalGalaxy.Oscar.maximal_polyhedra(TropF)) )
    end
end

L = TropicalGalaxy.Oscar.lineality_space(TropF2)

for (i, l) in enumerate(L)
    println(i," ", findfirst(sigma -> (l in sigma), TropicalGalaxy.Oscar.maximal_polyhedra(TropF)) )
end





TropicalGalaxy.Oscar.lineality_dim(poly_F)
TropicalGalaxy.Oscar.lineality_dim(poly_F2)




f1 = TropicalGalaxy.Oscar.f_vector(poly_F)
f2 = TropicalGalaxy.Oscar.f_vector(poly_H) 

