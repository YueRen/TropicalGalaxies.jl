mutable struct TropicalGalaxy <: AbstractMultigraph
    stars::Vector{TropicalStar}
    excision_graph::UndirectedMultigraph
    excision_graph_edge_labels
end


stars(Γ::TropicalGalaxy) = Γ.stars
excision_graph(Γ::TropicalGalaxy) = Γ.excision_graph
excision_graph_edge_labels(Γ::TropicalGalaxy) = Γ.excision_graph_edge_labels
laman_graph(Γ::TropicalGalaxy) = first(stars(Γ))


# function tropical_galaxy(g::UndirectedMultigraph)
#     return TropicalGalaxy([tropical_star(g)], UndirectedMultigraph(1, Tuple{Int, Int}[]), Vector{Int}[])
# end


function tropical_galaxy(G::UndirectedMultigraph)
    excisions = [G]
    excisionGraph = undirected_multigraph(1, Tuple{Int, Int}[])
    edgeLabels = Vector{Vector{Int}}[]
    workingList = [1] # indices of stars to be excised
    println(!isempty(workingList))
    println(!is_fully_excised(excisions[first(workingList)]))
    l = 0
    while !isempty(workingList) && !is_fully_excised(excisions[first(workingList)])
        l += 1
        if l > 2
            println(workingList)
            return excisions[first(workingList)]
        end
        println("Excision round $l, working list size: $(length(workingList))")
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
                        println("!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                        push!(edgeLabels[oldEdgeIndex], ee)
                    end
                end
            end
        end
        workingList = newWorkingList
    end
    println(tropical_star.(excisions))
    println(edgeLabels)
    println(excisionGraph)
    return TropicalGalaxy(tropical_star.(excisions), excisionGraph, edgeLabels)
end


# function explore_all(Γ::TropicalGalaxy)
#     if isempty(Γ.stars)
#         Gexcisions = all_excisions(Γ.source_graph)
#         Γ.stars = Vector{Vector{TropicalStar}}()
#         Γ.excision_graph_edge_labels = Vector{Vector{String}}()
#         n_vert = 1 
#         edges = Tuple{Int, Int}[]

#         # map each unique excised graph to a vertex in excised_graph 
#         vertex_map = Dict{Any, Int}()
#         vertex_map[Γ.source_graph] = 1
#         next_id = 2 
 

#         # add root node = source graph
#         # 
#         # vertex_map[Γ.source_graph] = next_id
#         # nextid += 1

#         for round in Gexcisions
#             star_rounds = Vector{TropicalStar}()
#             for (parent_graph, g, excised_labels) in round
#                 # if g is a new excised graph, add vertex in excision_graph
#                 if !haskey(vertex_map, g)
#                     n_vert += 1 
#                     vertex_map[g] = next_id
#                     next_id += 1
#                 end
#                 # parent = graph which g comes from
#                 if parent_graph !== nothing
#                     parent = vertex_map[parent_graph]
#                     child = vertex_map[g]
#                     push!(edges, (parent, child))
#                     push!(Γ.excision_graph_edge_labels, excised_labels)
#                 end
#                 push!(star_rounds, tropical_star(g.n_vertices, g.edges))
#             end
#             push!(Γ.stars, star_rounds)
#         end
#     end
#     Γ.excision_graph = undirected_multigraph(n_vert, edges)
#     return Γ.stars
# end


# function explore_rand(Γ::TropicalGalaxy)
#     if Γ.stars === nothing 
#         Γ.stars = explore_all(Γ)
#     end

#     exploration = Vector{TropicalStar}()

#     for round in Γ.stars
#         if !isempty(round)
#             n = rand(1:length(round))
#             push!(exploration, round[n])
#         end
#     end
#     return exploration
# end


function format_excision(excision_path::Vector{String})
    path = String["G"]
    edge_labels = String[]
    last_label = " " 

    for label in excision_path
        if label != last_label
            push!(edge_labels, " ↷ " * label)
            last_label = label
        end
    end

    for i in 1:length(edge_labels)
        push!(path, "S$i")
    end

    return path, edge_labels
end


function visualize_excision_graph(Γ::TropicalGalaxy)
    edgeLabels = Dict(edges(excision_graph(Γ))[i] => string(excision_graph_edge_labels(Γ)[i])
                    for i in 1:length(edges(excision_graph(Γ))))

    visualize_graph(excision_graph(Γ), edgeLabels = edgeLabels)
end 
