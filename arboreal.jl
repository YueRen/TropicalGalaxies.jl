using TropicalGalaxy
using Oscar

function arboreal_pair(F1::TropicalGalaxy.Undirected_MultiGraph, F2::TropicalGalaxy.Undirected_MultiGraph)
    T1 = TropicalGalaxy.extract_edge_labels(F1)
    T2 = TropicalGalaxy.extract_edge_labels(F2)
    C = TropicalGalaxy.intersection_graph(T1, T2)
    return TropicalGalaxy.is_forest(C)
end

G = TropicalGalaxy.triangle_wheel(7)
@time Gexcisions = TropicalGalaxy.all_excisions(G);
FFs = Gexcisions[6]

non_tree = Vector{Int}()
for j in 1:length(FFs)
    FF = FFs[j]
    TropF_neg = -(TropicalGalaxy.tropical_linear_space(FF))
    for i in j+1:length(FFs)
        HH = FFs[i]
        TropH = TropicalGalaxy.tropical_linear_space(HH)
        n = TropicalGalaxy.tropical_intersection_number(TropF_neg, TropH)
        println("$j/$(length(FFs)), $i/$(length(FFs))")
        if n >= 1
            if arboreal_pair(FF, HH) != "tree"
                push!(non_tree, [j, i])
                println("NOT A TREE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            end
        end
    end
end


