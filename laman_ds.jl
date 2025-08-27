# using SortingAlgorithms

# Reading text files 

# Creates a Dict of vectors from text files in folder LamanGraphs3-10

function load_vectors(folder::String)
    vectors = Dict{String, Vector{Int}}()
    # files = filter(f -> endswith(f, ".txt"), readdir(folder; join=true))
    files = readdir(folder; join=true)
    sort!(files)

    for (i, file) in enumerate(files)
        if endswith(file, ".txt")
            content = read(file, String)
            clean = replace(content, ['[', ']'] => "") |> strip
            vec = parse.(Int, split(clean, ","))
            vectors[basename(file)] = vec
        end
    end
    return vectors
end

lam_dict = load_vectors("LamanGraphs3-10")

laman_graphs_dict = Dict{Int, Vector{Int}}()
for n in 3:10
    key = "LamanGraphs$(n).txt"
    laman_graphs_dict[n] = lam_dict[key]
end
 
function laman_graph(n::Int, k::Int)
    # Returns the k-th Laman graph on n vertices
    return laman_graphs_dict[n][k]
end

laman_graph(5, 3)

