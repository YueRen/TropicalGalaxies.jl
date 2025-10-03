using OrderedCollections

abstract type AbstractMultigraph end

mutable struct UndirectedMultigraph <: AbstractMultigraph
    n_vertices::Int
    edges::Vector{Tuple{Int, Int}}
end

function n_vertices(g::UndirectedMultigraph)
    return g.n_vertices
end

function n_edges(g::UndirectedMultigraph)
    return length(g.edges)
end

function edges(g::UndirectedMultigraph)
    return g.edges
end

function add_vertex!(G::UndirectedMultigraph)
    G.n_vertices += 1 
    return G.n_vertices
end

function add_edge!(G::UndirectedMultigraph, edge::Tuple{Int, Int})
    push!(G.edges, edge)
end

function edge_adjacency_matrix(g::UndirectedMultigraph)
    edge_list = edges(g)
    m = length(edge_list)
    edge_adj_matrix = zeros(Int, m, m)
    
    for i in 1:m-1
        for j in i+1:m
            edge_i = edge_list[i]
            edge_j = edge_list[j]
            # Two edges are adjacent if they share a common vertex
            if edge_i[1] == edge_j[1] || edge_i[1] == edge_j[2] || 
                edge_i[2] == edge_j[1] || edge_i[2] == edge_j[2]
                edge_adj_matrix[i, j] = 1
                edge_adj_matrix[j, i] = 1
            end
        end
    end
    
    return edge_adj_matrix
end

function undirected_multigraph(n_vertices::Int, edges::Vector{Tuple{Int, Int}})
    @assert all(e->(collect(e)==sort(collect(e))), edges) "Edges must be sorted, e.g., (1,2) instead of (2,1)"
    UndirectedMultigraph(n_vertices, edges)
end


function Base.:(==)(g1::UndirectedMultigraph, g2::UndirectedMultigraph)
    return n_vertices(g1) == n_vertices(g2) && edge_adjacency_matrix(g1) == edge_adjacency_matrix(g2)
end


function triangle_chain(n::Int)
    # constructs the triangle chain with n vertices
    @assert n > 2 "the input number of vertices must be greater than 2 to form a wheel graph"

    # Build the edge dictionary with  labels
    edges = [(1, 2), (1, 3), (2, 3)]
    
    for i in 4:n
        # Add edge from vertex 1 to new vertex i
        push!(edges, (i-1, i))
        push!(edges, (i-2, i)) 
    end
    
    return UndirectedMultigraph(n, edges)
end


function triangle_wheel(n)
    # constructs the triangle wheel with n vertices
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


function edge_labels(multigraph::UndirectedMultigraph)
    label_dict = Dict{Tuple{Int, Int}, String}()
    for (label, (u, v)) in enumerate(edges(multigraph))
            if haskey(label_dict, (u, v))
                label_dict[(u, v)] *= ", " * string(label)
                label_dict[(v, u)] = label_dict[(u, v)] 
            else
                label_dict[(u, v)] = string(label)
                label_dict[(v, u)] = string(label)
            end
    end
    return label_dict 
end


function visualize_graph(multigraph::UndirectedMultigraph;
    vertexLabels::Vector = collect(1:n_vertices(multigraph)),
    edgeLabels::Dict = edge_labels(multigraph)
    )
    # Visualize the underlying simple graph, adds edge labels to graph

    # Removes duplicate edges 
    simple_edges = Set(Tuple(e) for e in edges(multigraph))
    
    g = SimpleGraph(n_vertices(multigraph))

    for (u,v) in simple_edges
        Graphs.add_edge!(g, u, v)
    end

    graphplot(
        g,
        names = vertexLabels,
        edgelabel = edgeLabels,
        nodeshape = :circle,
        fontsize = 10,
        curves = false)
end


function excise(graph::UndirectedMultigraph, excisedVertices::Vector{Int})
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

    return UndirectedMultigraph(n + 1, newEdges)
end 


function vertex_edge_matrix(multigraph::UndirectedMultigraph)
    m = length(edges(multigraph))
    n = n_vertices(multigraph)
    graph_matrix = zero_matrix(QQ, n, m)
    for (j,edge) in enumerate(edges(multigraph))
        graph_matrix[edge[1],j] = -1
        graph_matrix[edge[2],j] = 1
    end
    return graph_matrix
end


function rank(G::UndirectedMultigraph)
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

# check if graph is fully excised, by checking if every vertex is contained in a single multiedge
function is_fully_excised(G::UndirectedMultigraph)
    V = flatten_tuple_vector(unique(edges(G)))
    return length(V)==length(unique(V))
end

function is_almost_fully_excised(G::UndirectedMultigraph)
    V = flatten_tuple_vector(unique(edges(G)))

    # identify vertices that appear more than once
    VHighDegree = [ v for v in unique(V) if count(isequal(v), V) > 1 ]

    # Case: only two adjacent multiedges
    if length(VHighDegree) == 1
        return true
    end

    # Case: a single multitriangle
    if length(VHighDegree) == 3
        edgesInvolvingHighDegreeVertices = [ e for e in unique(edges(G)) if any(v -> (v in VHighDegree), e) ]
        if length(edgesInvolvingHighDegreeVertices) == 3
            return true
        end
    end

    return false
end


# all_multiedge_excisions returns two vectors, 
# first is a vector of undirected multigraphs containing the multiedge excisions of G 
# second is a vector of vector of multiedges that led to the aforementioned excisions

function all_multiedge_excisions(G::UndirectedMultigraph)
    Gexcisions = Vector{UndirectedMultigraph}()
    Gmultiedges = Vector{Vector{Int}}()

    if is_fully_excised(G)
        return Gexcisions, Gmultiedges
    end
    uniqueEdges = unique(edges(G)) 
    nonIsolatedEdges = []
    for e in uniqueEdges
        if length(findall(edge -> ((e[1] in edge) || (e[2] in edge)), uniqueEdges)) > 1
            push!(nonIsolatedEdges, e)
        end
    end

    for e in nonIsolatedEdges
        Gexcision = excise(G, [e[1], e[2]])
        if (Gexcision != G) && Gexcision ∉ Gexcisions
            Gmultiedge = findall(isequal(e),edges(G)) # all edge indices connecting e[1] and e[2]
            push!(Gexcisions, Gexcision)
            push!(Gmultiedges, Gmultiedge)
        end
    end

    return Gexcisions, Gmultiedges
end


function has_isolated_triangle(G::UndirectedMultigraph)

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


function triangle_sort(Gs::Vector{UndirectedMultigraph})
    triangles = Dict{UndirectedMultigraph,Vector{Vector{Int}}}()
    for G in Gs
        key = G 
        value = has_isolated_triangle(G)[2]
        triangles[key] = value
    end

    # Sort triangles by their numerical values
    sorted_triangles = sort(collect(triangles), by = x -> x[2])
    # Return as OrderedDict to maintain sort order
    return OrderedDict(sorted_triangles)
end


function triangle_group(G::OrderedDict{UndirectedMultigraph,Vector{Vector{Int}}})
    triangleGroups = Dict{Vector{Vector{Int}}, Vector{UndirectedMultigraph}}()
    for (graph, triangle_labels) in G
        # Use the triangle labels directly as the key instead of converting to string
        if haskey(triangleGroups, triangle_labels)
            push!(triangleGroups[triangle_labels], graph)
        else
            triangleGroups[triangle_labels] = [graph]
        end
    end
    return triangleGroups
end


function tropical_linear_space(G::UndirectedMultigraph)

    isFullyExcised = is_fully_excised(G)
    isAlmostFullyExcised = is_almost_fully_excised(G)
    hasTriangle, triangle = has_isolated_triangle(G)

    if !isAlmostFullyExcised && !isFullyExcised && !hasTriangle
        return Oscar.tropical_linear_space(vertex_edge_matrix(G))
    end

    # @assert isFullyExcised || isAlmostFullyExcised "graph needs to be fully or almost fully excised"

    vertexEdgeMatrix = vertex_edge_matrix(G)
    vertexEdgeColumns = [vertexEdgeMatrix[:,c] for c in 1:ncols(vertexEdgeMatrix)]
    vertexEdgeColumnsUnique = unique(vertexEdgeColumns)
    multiedges = Vector{Int}[]
    for column in vertexEdgeColumnsUnique
        push!(multiedges, findall(isequal(column), vertexEdgeColumns))
    end

    nonTriangleMultiedges = Vector{Int}[]
    triangleMultiedges = Vector{Int}[]
    for multiedge in multiedges
        if multiedge in triangle
            push!(triangleMultiedges, multiedge)
        else
            push!(nonTriangleMultiedges, multiedge)
        end
    end

    # put all non-triangle multiedges into the lineality of TropG
    linealityBasis = zero_matrix(QQ, length(nonTriangleMultiedges)+1, n_edges(G))
    for (i, multiedge) in enumerate(nonTriangleMultiedges)
        for j in multiedge
            linealityBasis[i,j] = 1
        end
    end
    for j in 1:ncols(linealityBasis)
        linealityBasis[end,j] = 1
    end

    # put all triangle multiedges into the rays of TropG
    verticesAndRays = zero_matrix(QQ, length(triangleMultiedges)+1, n_edges(G))
    for (i, multiedge) in enumerate(triangleMultiedges)
        for j in multiedge
            verticesAndRays[i+1,j] = 1
        end
    end
    if length(triangleMultiedges) > 0
        incidenceMatrix = Oscar.incidence_matrix([[1,i+1] for i in 1:length(triangleMultiedges)])
        rayIndices = [i+1 for i in 1:length(triangleMultiedges)]
    else
        incidenceMatrix = Oscar.incidence_matrix([[1]])
        rayIndices = nothing
    end

    TropG = polyhedral_complex(incidenceMatrix,
                               verticesAndRays,
                               rayIndices,
                               linealityBasis)
    return Oscar.tropical_linear_space(TropG, ones(ZZRingElem,nrows(incidenceMatrix)))
end


function extract_edge_labels(multigraph)
    # Get unique edges (removes duplicates)
    simple_edges = unique(edges(multigraph))
    
    # Create a vector to store labels for each unique edge
    edge_labels = Vector{Vector{Int}}()

    for simple_edge in simple_edges
        # Find all edge indices that match this simple edge
        matching_indices = []
        for (i, edge) in enumerate(edges(multigraph))
            if edge == simple_edge
                push!(matching_indices, i)
            end
        end
        push!(edge_labels, matching_indices)
    end
    return sort(edge_labels)
end


function chains(G::UndirectedMultigraph)
    MatG = vertex_edge_matrix(G)
    MG = matroid_from_matrix_columns(MatG)
    LG = lattice_of_flats(MG)
    CFG = maximal_chains(LG)

    maxChains = Vector{Vector{Vector{Int}}}()
    for i in 1:length(CFG)
        F = data.(CFG[i])
        chain = Vector{Vector{Int}}()
        prev = Set{Int64}()
        for elem in F
            curr = Set(elem)
            new_elems = setdiff(curr, prev)
            if !isempty(new_elems)
                push!(chain, sort(collect(new_elems)))
            end
            prev = curr
        end
    push!(maxChains, sort(chain))
    end
    return maxChains
end


function check_chain(G::UndirectedMultigraph, n)
    Gexcisions = Vector{UndirectedMultigraph}() 
    maxChains = chains(G)
    g = all_excisions(G)
    for i in g[n]
        labels = extract_edge_labels(i)
        # is_chain_valid = any(chain -> isequal(Set(chain), Set(labels)), maxChains)
        is_chain_valid = labels in chains
        if is_chain_valid
            push!(Gexcisions, i)
        end
    end
    return Gexcisions
end
