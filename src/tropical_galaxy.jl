################################################################################
#
#  Tropical Galaxies
#
################################################################################

mutable struct TropicalGalaxy
    stars::Vector{TropicalStar}
    excision_graph::UndirectedMultigraph
    excision_graph_edge_labels
end


stars(Γ::TropicalGalaxy) = Γ.stars
excision_graph(Γ::TropicalGalaxy) = Γ.excision_graph
excision_graph_edge_labels(Γ::TropicalGalaxy) = Γ.excision_graph_edge_labels
laman_graph(Γ::TropicalGalaxy) = graph(first(stars(Γ)))

function Base.show(io::IO, Γ::TropicalGalaxy)
    println(io, "A tropical galaxy with $(length(stars(Γ))) stars and $(length(edges(excision_graph(Γ)))) edges of the graph")
    println(io, laman_graph(Γ))
end


@doc raw"""
    tropical_galaxy(G::UndirectedMultigraph)

Return the tropical galaxy of a Laman graph `G`.

See `visualize_excision_graph` for visualizing tropical galaxies.

Set `Oscar.set_verbosity_level(:TropicalGalaxy,1)` to see progress of the
construction.

!!! Warning
    Does not check if `G` is Laman.

# Examples
```jldoctest
julia> G = triangle_chain(4)
UndirectedMultigraph(4, [(1, 2), (1, 3), (2, 3), (3, 4), (2, 4)])

julia> gamma = tropical_galaxy(G)
A tropical galaxy with 15 stars and 18 edges of the graph
UndirectedMultigraph(4, [(1, 2), (1, 3), (2, 3), (3, 4), (2, 4)])

```
"""
function tropical_galaxy(G::UndirectedMultigraph)
    excisions = [G]
    excisionGraph = undirected_multigraph(1, Tuple{Int, Int}[])
    edgeLabels = Vector{Vector{Int}}[]
    workingList = [1] # indices of stars to be excised
    l = 0
    while !isempty(workingList) && !is_fully_excised(excisions[first(workingList)])
        l += 1
        @vprintln :TropicalGalaxy "Excision round $l, working list size: $(length(workingList))"
        newWorkingList = Int[]
        for oldStarIndex in workingList
            GG = excisions[oldStarIndex]
            GGexcisions, GGmultiedges = all_multiedge_excisions(GG)
            for (HH, ee) in zip(GGexcisions, GGmultiedges)
                i = findfirst(isequal(HH), excisions)
                if isnothing(i)
                    # new star found
                    push!(excisions, HH)
                    newStarIndex = add_vertex!(excisionGraph)
                    add_edge!(excisionGraph, (oldStarIndex,newStarIndex))
                    push!(edgeLabels, [ee]) 
                    push!(newWorkingList, newStarIndex)
                else
                    oldEdgeIndex = findfirst(isequal((oldStarIndex, i)), edges(excisionGraph))
                    if isnothing(oldEdgeIndex)
                        # old star new edge
                        add_edge!(excisionGraph, (oldStarIndex, i))
                        push!(edgeLabels, [ee])
                    else
                        # old star old edge
                        push!(edgeLabels[oldEdgeIndex], ee)
                    end
                end
            end
        end
        workingList = newWorkingList
    end
    return TropicalGalaxy(tropical_star.(excisions), excisionGraph, edgeLabels)
end


@doc raw"""
    visualize_excision_graph(Γ::TropicalGalaxy)

Visualize excision graph of a Tropical Galaxy Γ.

See `visualize_graph` for visualizing undirected multigraphs.
"""
function visualize_excision_graph(Γ::TropicalGalaxy)
    edgeLabels = Dict(edges(excision_graph(Γ))[i] => string(excision_graph_edge_labels(Γ)[i])
                    for i in 1:length(edges(excision_graph(Γ))))

    visualize_graph(excision_graph(Γ), edgeLabels = edgeLabels)
end