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
    # TODO: implement this function
end
