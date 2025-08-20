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

function bergman_transverse(M,F1,F2)
    # todo: create the matrix with columns F1 and F2 and check whether it is of full rank
end

function coupling(F1,F2)
    # todo: create the coupling as an undirected multigraph
end

function is_tree(GG::UndirectedMultigraph)
    # todo: implement dfs test
end
