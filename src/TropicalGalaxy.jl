module TropicalGalaxy

using Revise
using Oscar
using Plots
using Graphs
using GraphRecipes
using OrderedCollections    

import Base: -
import Base: *
import Oscar: rank

include("laman_ds.jl")
include("oscar_wishlist.jl")
include("undirected_multigraph.jl")
include("helpers.jl")

end
