using Revise
using Oscar

function excise(G,e,n)
    # TODO: create function
end

"""
    triangle_chain(k)

Creates a graph of `k` chained triangles.
Each triangle shares an edge with the next one.

Returns a SimpleGraph.
"""
function triangle_chain(k::Int)
    # Total number of vertices: 2 shared + 1 new per triangle
    num_vertices = k + 2
    g = graph(Undirected, num_vertices)

    # First triangle: vertices 1-2-3
    add_edge!(g, 1, 2)
    add_edge!(g, 2, 3)
    add_edge!(g, 3, 1)

    # Subsequent triangles
    for i in 1:k-1
        # Triangle i shares edge (i+1, i+2), add new node (i+3)
        u = i + 1
        v = i + 2
        w = i + 3

        # Safe to add edge since we preallocated num_vertices
        add_edge!(g, u, w)
        add_edge!(g, v, w)
    end

    return g
end

function triangle_wheel(k)
    # Build the edge dictionary with  labels
    edge_dict = Dict((1,2)=>1, (1,3)=>2, (2,3)=>3)
    edge_label = 4  # Start labeling new edges from 4
    
    if k > 3
        for i in 4:k
            # Add edge from vertex 1 to new vertex i
            edge_dict[(1,i)] = edge_label
            edge_label += 1
            
            # Add edge from new vertex i to previous vertex i-1
            edge_dict[(i,i-1)] = edge_label
            edge_label += 1
        end
    end
    
    return graph_from_labeled_edges(Undirected, edge_dict)
end
