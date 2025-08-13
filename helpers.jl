# Packages we rely on
using Revise
using Oscar
using Plots
using Graphs
using GraphRecipes

# Functions we extend
import Base: -
import Base: *

# Source files
include("oscar_wishlist.jl")
include("undirected_multigraph.jl")
