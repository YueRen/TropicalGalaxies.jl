using TropicalGalaxy

G = TropicalGalaxy.triangle_chain(7)
@time Gexcisions = TropicalGalaxy.all_excisions(G);
FFs = Gexcisions[5]
HHs = Gexcisions[4]
F1 = FFs[5]
F2 = HHs[52]

TropF = TropicalGalaxy.Oscar.tropical_linear_space(TropicalGalaxy.vertex_edge_matrix(F1))
TropH = TropicalGalaxy.tropical_linear_space(F1)

poly_F = TropicalGalaxy.Oscar.polyhedral_complex(TropF)
poly_H = TropicalGalaxy.Oscar.polyhedral_complex(TropH)

f1 = TropicalGalaxy.Oscar.f_vector(poly_F)
f2 = TropicalGalaxy.Oscar.f_vector(poly_H) 

