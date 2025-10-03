mutable struct TropicalStar <: AbstractMultigraph
    graph::UndirectedMultigraph
    linearSpace::Union{Nothing, Any} 
end

function tropical_star(g::UndirectedMultigraph)
    return TropicalStar(g, nothing)
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


function linear_space(HH::TropicalStar)
    if HH.linearSpace === nothing
        HH.linearSpace = tropical_linear_space(HH.graph)
    end
    return HH.linearSpace
end


function visualize_graph(HH::TropicalStar)
    visualize_graph(HH.graph)
end


function excise(HH::TropicalStar, excisedVertices::Vector{Int})
    g_excised = excise(HH.graph, excisedVertices) 
    return tropical_star(g_excised.n_vertices, g_excised.edges)  
end


function tropical_intersection_product(Γ1::TropicalStar, Γ2::TropicalStar)
    Trop_Γ1 = tropical_linear_space(Γ1.graph)
    Trop_Γ2 = tropical_linear_space(Γ2.graph)
    return tropical_intersection_number(Trop_Γ1, Trop_Γ2)
end