module TropicalGalaxies

using Oscar
using Plots # TODO: check which of the following are actually needed
using Graphs
using GraphRecipes
using OrderedCollections    

include("import.jl")
include("laman_ds.jl")
include("oscar_wishlist.jl")
include("undirected_multigraph.jl")
include("tropical_star.jl")
include("tropical_galaxy.jl")
include("helpers.jl")
include("arboreal.jl")
include("export.jl")

function __init__()
    # scope for constructing tropical galaxies
    add_verbosity_scope(:TropicalGalaxy)
    add_assertion_scope(:TropicalGalaxy)
end

end

