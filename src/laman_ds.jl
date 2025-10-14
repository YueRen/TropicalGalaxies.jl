function n_laman_graphs(n::Int)
    LGD = include("../data/LamanGraphDatabase/LamanGraphs"*string(n)*".txt")
    return length(LGD)
end

function int_to_binary_vector(n::Int, num_bits::Int = 0)
    if n < 0
        throw(ArgumentError("Input integer must be non-negative."))
    end

    if n == 0
        if num_bits == 0
            return [0]
        else
            return zeros(Int, num_bits)
        end
    end

    binary_digits = Vector{Int}()
    while n > 0
        pushfirst!(binary_digits, n % 2)
        n ÷= 2  # Integer division
    end

    required_bits = length(binary_digits)
    if num_bits > required_bits
        padding = zeros(Int, num_bits - required_bits)
        return vcat(padding, binary_digits)
    else
        return binary_digits
    end
end

function adjacency_matrix_size(Gint::Int)
    triangularNumber = 0
    n = 0
    while triangularNumber < Gint
        n += 1
        triangularNumber += n
    end
    return n+1
end

function binary_vector_to_adjacency_matrix(Gbin::Vector{Int})
    n = adjacency_matrix_size(length(Gbin))
    adjacencyMatrix = zeros(Int, n, n)
    GbinRev = reverse(Gbin)
    k = 1
    for i in reverse(1:n-1)
        for j in reverse(i+1:n)
            adjacencyMatrix[i, j] = GbinRev[k]
            adjacencyMatrix[j, i] = GbinRev[k]
            k += 1
            if k > length(Gbin)
                return adjacencyMatrix
            end
        end
    end
end

function adjacency_matrix_to_undirected_multigraph(Gadj::Matrix{Int})
    Gedges = Vector{Tuple{Int, Int}}()
    n = nrows(Gadj)
    for i in 1:n-1
        for j in i+1:n
            if Gadj[i,j]>0
                push!(Gedges, (i,j))
            end
        end
    end
    return undirected_multigraph(nrows(Gadj), Gedges)
end

function laman_graph(n::Int, k::Int)
    @assert 1 <= k <= n_laman_graphs(n)
    LGD = include("../data/LamanGraphDatabase/LamanGraphs"*string(n)*".txt")
    Gint = LGD[k]
    Gbin = int_to_binary_vector(Gint)
    Gadj = binary_vector_to_adjacency_matrix(Gbin)
    return adjacency_matrix_to_undirected_multigraph(Gadj)
end
