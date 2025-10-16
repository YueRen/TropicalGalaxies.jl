module TropicalGalaxies

using Revise
using Oscar
using Plots
using Graphs
using GraphRecipes
using OrderedCollections


include("import.jl")
include("oscar_wishlist.jl")
include("undirected_multigraph.jl")
include("laman_graph.jl")
include("tropical_star.jl")
include("tropical_galaxy.jl")
include("arboreal.jl")
include("export.jl")

function __init__()
    # scope for logging and testing during tropical galaxy construction
    add_verbosity_scope(:TropicalGalaxy)
    add_assertion_scope(:TropicalGalaxy)
end

end
