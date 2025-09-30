using TropicalGalaxy
using Oscar

function arboreal_pair(G, F1, F2) 
    maxChains = TropicalGalaxy.chains(G)
    T1 = TropicalGalaxy.extract_edge_labels(F1)
    T2 = TropicalGalaxy.extract_edge_labels(F2)
    C = TropicalGalaxy.intersection_graph(T1, T2)
    println(C)
    return TropicalGalaxy.is_forest(C)
end

G = TropicalGalaxy.triangle_wheel(7)
@time Gexcisions = TropicalGalaxy.all_excisions(G);
FFs = Gexcisions[6]
HHs = Gexcisions[6]


non_tree = Vector{Int}()

for (j, FF) in enumerate(FFs) 
    TropF_neg = -(TropicalGalaxy.tropical_linear_space(FF))
    for (i, HH) in enumerate(HHs) 
        TropH = TropicalGalaxy.tropical_linear_space(HH)
        @time n = TropicalGalaxy.tropical_intersection_number(TropF_neg, TropH)
        println("$j/$(length(FFs)), $i/$(length(HHs))")
        if n >= 1
            if arboreal_pair(G, FF, HH) != "tree"
                push!(non_tree, [j, i])
                println("NOT A TREE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            end
        end
    end
end


