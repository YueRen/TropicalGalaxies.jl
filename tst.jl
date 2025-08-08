include("helpers.jl") 


g = triangle_wheel(6)


visualize_graph(g)

g1 = excise(g,[1,2])
visualize_graph(g1)

g2 = excise(g,[1,2,3])
visualize_graph(g2)



