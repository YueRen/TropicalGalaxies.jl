struct Undirected_MultiGraph
    n_vertices::Int
    edges::Vector{Tuple{Int, Int}}
    function undirected_multigraph(n_vertices::Int, edges::Vector{Tuple{Int, Int}})
        @assert all(e->(e==sort(e)), edges) "Edges must be sorted, e.g., (1,2) instead of (2,1)"
        new(n_vertices, edges)
    end

end

function n_vertices(g::Undirected_MultiGraph)
    return g.n_vertices
end

function edges(g::Undirected_MultiGraph)
    return g.edges
end



"""
Example usage:
triangle_graph = Undirected_MultiGraph(
    [1, 2, 3],
    [(2, 1), (3, 1), (3, 2), (3,2)]
)

e = edge_labels(triangle_graph)

returns
    (3, 1, 1) => 2
    (3, 2, 2) => 4
    (2, 1, 1) => 1
    (3, 2, 1) => 3
"""

function triangle_chain(n::Int)
 
    @assert n > 2 "the input number of vertices must be greater than 2 to form a wheel graph"

    # Build the edge dictionary with  labels
    edges = [(1, 2), (1, 3), (2, 3)]
    
    for i in 4:n
        # Add edge from vertex 1 to new vertex i
        push!(edges, (i-1, i))
        push!(edges, (i-2, i)) 
    end
    
    return Undirected_MultiGraph(n, edges)
end


function triangle_wheel(n)
    
    @assert n > 2 "the input number of vertices must be greater than 2 to form a wheel graph"

    # Build the edge dictionary with  labels
    edges = [(1, 2), (1, 3), (2, 3)]
    
    for i in 4:n
        # Add edge from vertex 1 to new vertex i
        push!(edges, (1, i))
        push!(edges, (i-1, i))    
    end
    
    return Undirected_MultiGraph(n,edges)
end


function visualize_graph(multigraph)
    # Visualize the underlying simple graph, adds edge labels to graph

    # Removes duplicate edges 
    simple_edges = Set(Tuple(e) for e in edges(multigraph))
    
    g = SimpleGraph(n_vertices(multigraph))

    for (u,v) in simple_edges
        Graphs.add_edge!(g, u, v)
    end

    # Edge labels 
    label_dict = Dict{Tuple{Int,Int}, String}()

    for (label, (u, v)) in enumerate(edges(multigraph))
        if haskey(label_dict, (u, v))
            label_dict[(u, v)] *= ", " * string(label)
            label_dict[(v, u)] = label_dict[(u, v)] 
        else
            label_dict[(u, v)] = string(label)
            label_dict[(v, u)] = string(label)
        end
    end

    graphplot(
        g,
        names = 1:n_vertices(multigraph),
        edgelabel = label_dict,
        nodeshape = :circle,
        curves = false)
end


