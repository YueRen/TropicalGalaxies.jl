################################################################################
#
#  Functions related to arboreal pairs
#
################################################################################

function intersection_graph(T1::Vector{Vector{Int}}, T2::Vector{Vector{Int}})
    flats1 = [Set(f) for f in T1]
    flats2 = [Set(f) for f in T2]
    E = union(reduce(union, flats1), reduce(union, flats2))
    reduced_flats1 = [f for f in flats1 if f != E]
    reduced_flats2 = [f for f in flats2 if f != E]

    # Number of vertices: reduced flats from both chains
    n1 = length(reduced_flats1)
    n2 = length(reduced_flats2)
    n = n1 + n2

    # Edges: connect vertex i in T1 to vertex j in T2 if both contain e
    edges = Tuple{Int,Int}[]
    for e in E
        for (i, f1) in enumerate(reduced_flats1)
            if e in f1
                for (j, f2) in enumerate(reduced_flats2)
                    if e in f2
                        # Vertices are indexed 1..n1 for T1, n1+1..n for T2
                        push!(edges, (i, n1 + j))
                    end
                end
            end
        end
    end

    return undirected_multigraph(n, edges)
end

@doc raw"""
    intersection_graph(HH1::TropicalStar, HH2::TropicalStar)

Return the intersection graph of the two fully excised Tropical Stars `HH1` and `HH2`.
"""
function intersection_graph(HH1::TropicalStar, HH2::TropicalStar)
    F1 = graph(HH1)
    F2 = graph(HH2)
    @assert is_fully_excised(F1) && is_fully_excised(F2) "Tropical Stars must be fully excised"

    T1 = extract_edge_labels(F1)
    T2 = extract_edge_labels(F2)
    return intersection_graph(T1, T2)
end


function is_connected(GG::UndirectedMultigraph)
    simpleEdges = Set(Tuple(e) for e in edges(GG))
    GG = Oscar.graph(Undirected, n_vertices(GG))
    for (u,v) in simpleEdges
        Oscar.add_edge!(GG, u, v)
    end
    return Oscar.is_connected(GG)
end


function is_tree(GG::UndirectedMultigraph)
    n_vert = n_vertices(GG)
    n_edge = n_edges(GG)
    return is_connected(GG) && (n_edge == n_vert - 1)
end


@doc raw"""
    arboreal_pair(H1::TropicalStar, H2::TropicalStar)

Return true if the intersection graph of the two fully excised Tropical Stars `H1` and `H2` is a tree.
"""
function arboreal_pair(HH1::TropicalStar, HH2::TropicalStar)
    return is_tree(intersection_graph(HH1, HH2))
end
