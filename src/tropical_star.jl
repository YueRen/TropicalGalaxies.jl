################################################################################
#
#  Tropical Stars
#
################################################################################

mutable struct TropicalStar
    graph::UndirectedMultigraph
    linearSpace::Union{Nothing, Any} 
end


function tropical_star(GG::UndirectedMultigraph)
    return TropicalStar(GG, nothing)
end


function tropical_star(n::Int, edges::Vector{Tuple{Int,Int}})
    return tropical_star(undirected_multigraph(n, edges))
end


function graph(HH::TropicalStar)
    return HH.graph
end


function is_fully_excised(HH::TropicalStar)
    return is_fully_excised(graph(HH))
end


@doc raw"""
    tropical_linear_space(HH::TropicalStar)

Return the tropical linear space of the Tropical Star `HH`.
"""
function tropical_linear_space(HH::TropicalStar)
    if HH.linearSpace === nothing
        HH.linearSpace = tropical_linear_space(graph(HH))
    end
    return HH.linearSpace
end


@doc raw"""
    visualize_graph(HH::TropicalStar)

Plot the graph of a Tropical Star HH.
"""
function visualize_graph(HH::TropicalStar)
    visualize_graph(graph(HH))
end


@doc raw"""
    excise(HH::TropicalStar, excisedVertices::Vector{Int})

Return a new Tropical Star obtained from `HH` by excising the vertices in `excisedVertices`.

# Examples
```jldoctest
julia> G
UndirectedMultigraph(4, [(1, 2), (1, 3), (2, 3), (3, 4), (2, 4)])

julia> T = tropical_star(G)
TropicalStar(UndirectedMultigraph(4, [(1, 2), (1, 3), (2, 3), (3, 4), (2, 4)]), nothing)

julia> excise(T, [1,3])
TropicalStar(UndirectedMultigraph(5, [(2, 5), (1, 3), (2, 5), (4, 5), (2, 4)]), nothing)
```
"""
function excise(HH::TropicalStar, excisedVertices::Vector{Int})
    FFgraph = excise(graph(HH), excisedVertices)
    return tropical_star(n_vertices(FFgraph), edges(FFgraph))
end


@doc raw"""
    galactic_pairing(HH1::TropicalStar, HH2::TropicalStar)

Return the galactic pairing of `HH1` and `HH2`, i.e., the tropical intersection product of the tropical linear space of `HH1` and the negated tropical linear space of `HH2`.
"""
function galactic_pairing(HH1::TropicalStar, HH2::TropicalStar)
    # TODO: add basic assertions to check that TropV1 and TropV2 are as expected
    # (of complementary dimension modulo lineality)
    TropHH1 = tropical_linear_space(graph(HH1))
    TropHH2 = tropical_linear_space(graph(HH2))
    @assert ambient_dim(TropHH1) == ambient_dim(TropHH2) "different ambient dimensions"
    if n_maximal_polyhedra(TropHH1) > n_maximal_polyhedra(TropHH2)
        TropHH2 = -TropHH2
    else
        TropHH1 = -TropHH1
    end
    return tropical_intersection_number(TropHH1, TropHH2)
end

