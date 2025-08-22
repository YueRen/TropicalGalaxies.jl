struct Undirected_MultiGraph
    n_vertices::Int
    edges::Vector{Tuple{Int, Int}}

end

function n_vertices(g::Undirected_MultiGraph)
    return g.n_vertices
end

function n_edges(g::Undirected_MultiGraph)
    return length(g.edges)
end

function edges(g::Undirected_MultiGraph)
    return g.edges
end

function undirected_multigraph(n_vertices::Int, edges::Vector{Tuple{Int, Int}})
    @assert all(e->(collect(e)==sort(collect(e))), edges) "Edges must be sorted, e.g., (1,2) instead of (2,1)"
    Undirected_MultiGraph(n_vertices, edges)
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
    
    return undirected_multigraph(n,edges)
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


function excise(graph::Undirected_MultiGraph, excisedVertices::Vector{Int})
    n = n_vertices(graph)
    newEdges = Vector{Tuple{Int, Int}}()
    for e in edges(graph)
        if e[1] ∈ excisedVertices && e[2] ∈ excisedVertices
            push!(newEdges, e)
        elseif e[1] ∉ excisedVertices && e[2] ∉ excisedVertices
            push!(newEdges,e)
        elseif e[1] ∈ excisedVertices
            push!(newEdges, (e[2], n+1))
        else 
            push!(newEdges, (e[1], n+1))
        end
    
    end

    return Undirected_MultiGraph(n + 1, newEdges)
end 

function vertex_edge_matrix(multigraph::Undirected_MultiGraph)
    m = length(edges(multigraph))
    n = n_vertices(multigraph)
    graph_matrix = zero_matrix(QQ, n, m)
    for (j,edge) in enumerate(edges(multigraph))
        graph_matrix[edge[1],j] = -1
        graph_matrix[edge[2],j] = 1
    end
    return graph_matrix
end


function is_tree(GG::Undirected_MultiGraph)
    if n_edges(GG) != n_vertices(GG) - 1
        return false
    end
    e = edges(GG)
    
    # Check every vertex is contained in some edge
    
    for v in 1:n_vertices(GG)
        findfirst(u -> (v in u), e) === nothing && return false
    end
    return true




    # Adjacency list 
    #adj = Dict{Int, Vector{Int}}()
    #for (u, v) in e
    #    push!(get!(adj, u, Int[]), v)
    #    push!(get!(adj, v, Int[]), u)
    #end

    # Recursive algorithm
    #function dfs(v, parent, visited)
    #    push!(visited, v)
    #    for neighbor in adj[v]
    #        if neighbor ∉ visited
    #            if !dfs(neighbor, v, visited)
    #                return false
    #            end
    #        elseif neighbor != parent
    #            return false
    #        end
    #    end
    #    return true
    #end
    #visited = Set{Int}()
end
