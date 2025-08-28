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

function edge_adjacency_matrix(g::Undirected_MultiGraph)
    edge_list = edges(g)
    m = length(edge_list)
    edge_adj_matrix = zeros(Int, m, m)
    
    for i in 1:m
        for j in 1:m
            if i != j
                edge_i = edge_list[i]
                edge_j = edge_list[j]
                # Two edges are adjacent if they share a common vertex
                if edge_i[1] == edge_j[1] || edge_i[1] == edge_j[2] || 
                   edge_i[2] == edge_j[1] || edge_i[2] == edge_j[2]
                    edge_adj_matrix[i, j] = 1
                end
            end
        end
    end
    
    return edge_adj_matrix
end

function undirected_multigraph(n_vertices::Int, edges::Vector{Tuple{Int, Int}})
    @assert all(e->(collect(e)==sort(collect(e))), edges) "Edges must be sorted, e.g., (1,2) instead of (2,1)"
    Undirected_MultiGraph(n_vertices, edges)
end

# define == for Undirected_MultiGraph:
# more complicated because we need to be agnostic towards vertex relabelings
function Base.:(==)(g1::Undirected_MultiGraph, g2::Undirected_MultiGraph)
    return n_vertices(g1) == n_vertices(g2) && edge_adjacency_matrix(g1) == edge_adjacency_matrix(g2)
end



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

    @assert length(excisedVertices) == 2 "Currently, only multi-edge excisions supported"

    # quick and dirty test to check whether multi-edge is isolated
    V = flatten_tuple_vector(unique(edges(graph)))
    if count(isequal(excisedVertices[1]), V) == 1 && count(isequal(excisedVertices[2]), V) == 1
        return graph
    end

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


# function is_tree(GG::Undirected_MultiGraph)
#     if n_edges(GG) != n_vertices(GG) - 1
#         return false
#     end
#     e = edges(GG)
    
#     # Check every vertex is contained in some edge
    
#     for v in 1:n_vertices(GG)
#         findfirst(u -> (v in u), e) === nothing && return false
#     end
#     return true
# end

function is_forest(g::Undirected_MultiGraph)
    """
    is_forest checks if an undirected multigraph is a tree, forest or neither
    tree -> connected and acyclic
    forest -> acyclic but not connected
    neither -> has cycles
    """

    n = n_vertices(g)
    e = edges(g)

    # Adjacency list
    adj = Dict{Int, Vector{Int}}()
    for (u, v) in e
        push!(get!(adj, u, Int[]), v)
        push!(get!(adj, v, Int[]), u)
    end
    
    has_cycle = Ref(false)
    components = 0
    visited = fill(false, n)
    
    function dfs(current, visited, parent)
        visited[current] = true
        for i in adj[current]
            if !visited[i]
                dfs(i, visited, current)
            elseif i != parent
                has_cycle[] = true
                return false # cycle detected
            end
        end
    end

    for v in 1:n
        if !visited[v]
            components += 1
            dfs(v, visited, -1)

        end
    end

    if has_cycle[]
        return "neither"
       
    elseif components == 1
        return "tree"
    else 
        return "forest"
    end
        
end


function rank(G::Undirected_MultiGraph)
    MG = vertex_edge_matrix(G)
    return rank(MG)
end


function flatten_tuple_vector(v::Vector{Tuple{Int64, Int64}})::Vector{Int64}
    result = Vector{Int64}()
    sizehint!(result, 2 * length(v))  # Pre-allocate space for efficiency

    for tup in v
        push!(result, tup[1])
        push!(result, tup[2])
    end

    return result
end

function is_fully_excised(G::Undirected_MultiGraph)
    E = flatten_tuple_vector(unique(edges(G)))
    return length(E)==length(unique(E))
end

function all_single_excisions(G::Undirected_MultiGraph)
    if is_fully_excised(G)
        return Undirected_MultiGraph[]
    end
    Gexcisions = Undirected_MultiGraph[]
    for e in unique(edges(G))
        Gexcision = excise(G, [e[1], e[2]])
        if Gexcision != G && !(Gexcision in Gexcisions)
            push!(Gexcisions, Gexcision)
        end
    end
    return Gexcisions
end

function all_excisions(G::Undirected_MultiGraph)
    allExcisions = Vector{Undirected_MultiGraph}[]
    workingList = [G]
    i = 0
    while !isempty(workingList)
        i += 1
        println("Excision round $i, working list size: $(length(workingList))")
        push!(allExcisions, workingList)
        newExcisions = Undirected_MultiGraph[]
        for HH in workingList
            for HHnew in all_single_excisions(HH)
                if !(HHnew in newExcisions)
                    push!(newExcisions, HHnew)
                end
            end
        end
        workingList = newExcisions
    end
    return allExcisions
end


function has_isolated_triangle(G::Undirected_MultiGraph)

    # find all vertices that are in the triangle
    E = edges(G)
    Esimple = unique(E)
    nonIsolatedVertices = Int[]
    for v in 1:n_vertices(G)
        if count(e-> (v in e), Esimple) > 1
            push!(nonIsolatedVertices, v)
        end
    end
    if length(nonIsolatedVertices) != 3
        return false, Vector{Int}[]
    end

    # remove all edges from Esimple that are not in the triangle
    Etriangle = []
    for e in Esimple
        if all(v -> (v in nonIsolatedVertices), e)
            push!(Etriangle, e)
        end
    end
    @assert length(Etriangle) == 3

    triangleLabels = Vector{Int}[ Int[] for _ in 1:3 ]
    for (i,e) in enumerate(E)
        if all(v -> (v in nonIsolatedVertices), e)
            j = findfirst(isequal(e), Etriangle)
            push!(triangleLabels[j], i)
        end
    end

    return true, sort(triangleLabels)
end


function triangle_sort(G::Vector{Undirected_MultiGraph})
    triangles = Dict{Undirected_MultiGraph,Vector{Vector{Int}}}()
    for g in G
        key = g 
        value = has_isolated_triangle(g)[2]
        triangles[key] = value
    end

    # Sort triangles by their numerical values
    sorted_triangles = sort(collect(triangles), by = x -> x[2])
    # Return just the graphs in sorted order
    return sorted_triangles
end

function triangle_group(triangles::Vector{Pair{Undirected_MultiGraph, Vector{Vector{Int64}}}})
   
end

function tropical_intersection_product(G1::Undirected_MultiGraph, G2::Vector{Undirected_MultiGraph})
   MF = vertex_edge_matrix(G1)
   TropF = tropical_linear_space(MF)
   product = Vector{}()
   for i in 1:length(G2)
       MHHI = vertex_edge_matrix(G2[i])
       TropHHI =  tropical_linear_space(MHHI)
         push!(product, TropF * (-TropHHI))
   end

   return product
end