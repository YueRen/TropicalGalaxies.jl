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
        HH.linearSpace = tropical_linear_space(HH.graph)
    end
    return HH.linearSpace
end


@doc raw"""
    visualize_graph(HH::TropicalStar)

Plot the graph of a Tropical Star HH.
"""
function visualize_graph(HH::TropicalStar)
    visualize_graph(HH.graph)
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
    g_excised = excise(HH.graph, excisedVertices) 
    return tropical_star(g_excised.n_vertices, g_excised.edges)  
end


@doc raw"""
    tropical_intersection_product(HH1::TropicalStar, HH2::TropicalStar)

Return the tropical intersection product of Tropical Stars 'HH1' and 'HH2'.
"""
function tropical_intersection_product(HH1::TropicalStar, HH2::TropicalStar)
    # TODO: add basic assertions to check that TropV1 and TropV2 are as expected
    # (of complementary dimension modulo lineality)
    Trop_HH1 = tropical_linear_space(HH1.graph)
    Trop_HH2 = tropical_linear_space(HH2.graph)
    @assert ambient_dim(Trop_HH1) == ambient_dim(Trop_HH2) "different ambient dimensions"
    return tropical_intersection_number(Trop_HH1, Trop_HH2)
end

