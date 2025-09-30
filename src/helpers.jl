# Packages we rely on
# using Revise
# using Oscar
# using Plots
# using Graphs
# using GraphRecipes
# using OrderedCollections

# # Functions we extend
# import Base: -
# import Base: *
# import Oscar: rank

# Source files
# include("oscar_wishlist.jl")
# include("undirected_multigraph.jl")
# include("laman_ds.jl")

function indicator_vector(m::Int, Fj::Vector{Int})
    v = zeros(Int, m)
    for j in Fj
        v[j] = 1
    end
    return v
end

function is_bergman_transverse(F1::Vector{Vector{Int}},F2::Vector{Vector{Int}})
    indicatorVectors = Vector{Int}[]
    m = length(last(F1))
    for f1 in F1
        push!(indicatorVectors, indicator_vector(m, f1))
    end
    for f2 in F2
        push!(indicatorVectors, indicator_vector(m, f2))
    end
    indicatorVectorsMatrix = hcat(indicatorVectors...)
    return rank(indicatorVectorsMatrix) == nrows(indicatorVectorsMatrix)
end


function coupling(F1::Vector{Vector{Int64}},F2::Vector{Vector{Int64}})
    n = length(F1) + length(F2) - 2
    m = sum(length.(F1))
    couplingEdges = Vector{Tuple{Int,Int}}()
    shift = length(F1) - 1
    for i in 1:m
        j = findfirst(f1 -> (i in f1), F1)
        k = findfirst(f2 -> (i in f2), F2) + shift
        # j = findfirst(f1 -> (i in f1), F1) - 1
        # k = findfirst(f2 -> (i in f2), F2) + shift - 1
        push!(couplingEdges, (j,k))
    end
    #println(couplingEdges)
    return undirected_multigraph(n+1, couplingEdges)
end

function intersection_graph(T1::Vector{Vector{Int}}, T2::Vector{Vector{Int}})
    flats1 = [Set(f) for f in T1]
    flats2 = [Set(f) for f in T2]
    E = union(reduce(union, flats1), reduce(union, flats2))
    reduced_flats1 = [f for f in flats1 if f != E]
    reduced_flats2 = [f for f in flats2 if f != E]

    # Number of vertices: reduced flats from both chains
    n1 = length(reduced_flats1)
    n2 = length(reduced_flats2)
    n = n1 + n2

    # Edges: connect vertex i in T1 to vertex j in T2 if both contain e
    edges = Tuple{Int,Int}[]
    for e in E
        for (i, f1) in enumerate(reduced_flats1)
            if e in f1
                for (j, f2) in enumerate(reduced_flats2)
                    if e in f2
                        # Vertices are indexed 1..n1 for T1, n1+1..n for T2
                        push!(edges, (i, n1 + j))
                    end
                end
            end
        end
    end

    return undirected_multigraph(n, edges)
end