function is_connected(g::UndirectedMultigraph)
    simpleEdges = Set(Tuple(e) for e in edges(g))
    g = Oscar.graph(Undirected, n_vertices(g))
    for (u,v) in simpleEdges
        Oscar.add_edge!(g, u, v)
    end
    return Oscar.is_connected(g)
end


function is_tree(g::UndirectedMultigraph)
    n_vert = n_vertices(g)
    n_edge = n_edges(g)
    return is_connected(g) && (n_edge == n_vert - 1)
end


@doc raw"""
    arboreal_pair(H1::TropicalStar, H2::TropicalStar)

Return true if the intersection graph of the two fully excised Tropical Stars `H1` and `H2` is a tree.
"""
function arboreal_pair(H1::TropicalStar, H2::TropicalStar)
    F1 = graph(H1)
    F2 = graph(H2)
    @assert is_fully_excised(F1) && is_fully_excised(F2) "Tropical Stars must be fully excised"

    T1 = extract_edge_labels(F1)
    T2 = extract_edge_labels(F2)
    C = intersection_graph(T1, T2)
    return is_tree(C)
end


# function arboreal_pair_experiment(n_vertices::Int, graph_indices::Vector{Int} = collect(1:n_laman_graphs(n_vertices)))
#     LGD = include("../data/LamanGraphDatabase/LamanGraphs"*string(n_vertices)*".txt")
#     # k -> kth laman graph with n_vertices
#     non_tree = Vector{Vector{Int}}()
#     for k in graph_indices
#         Gadj =  binary_vector_to_adjacency_matrix( int_to_binary_vector(LGD[k]))
#         G =  adjacency_matrix_to_undirected_multigraph(Gadj)

#         Gexcisions =  all_multiedge_excisions(G);
#         FFs = Gexcisions[n_vertices-1]


#         for j in 1:length(FFs)
#             FF = FFs[j]
#             TropF_neg = -(tropical_linear_space(FF[1]))
#             for i in j+1:length(FFs)
#                 HH = FFs[i]
#                 TropH =  tropical_linear_space(HH[1])
#                 n =  tropical_intersection_number(TropF_neg, TropH)
#                 ans = "$n_vertices vertices: $k/$(length(graph_indices)): $j/$(length(FFs)), $i/$(length(FFs))"
#                 println(ans)
#                 open("arboreal_pair_exp.txt", "a") do file 
#                     write(file, ans * "\n")
#                 end
#                 if n >= 1
#                     if arboreal_pair(FF[1], HH[1]) == false
#                         push!(non_tree, [k, j, i])
#                         println("NOT A TREE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
#                     end
#                 end
#             end
#         end
#     end
#     return non_tree
# end

