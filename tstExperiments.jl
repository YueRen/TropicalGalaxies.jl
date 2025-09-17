# include("helpers.jl")

G = triangle_chain(7)
@time Gexcisions = all_excisions(G);
FFs = Gexcisions[6]
HHs = Gexcisions[5]

HHsSortedDict = triangle_group(triangle_sort(HHs))

# we see that i=15 and i=18 contain many graphs
for (i,(key,value)) in enumerate(HHsSortedDict)
    println(i," ",length(value))
end

fixedTriangle = collect(keys(HHsSortedDict))

# j index for fixed triangle
# i index for graphs with that fixed triangle
TropF = tropical_linear_space(FFs[5])
for j in 1:36 
    for (i, HH) in enumerate(HHsSortedDict[fixedTriangle[j]])
        TropH = tropical_linear_space(HH)
        n = TropF * (-TropH)
        if n >= 1
            println("($i, $j): ", TropF * (-TropH))
            println("($i, $j): ", n)
        end
    end
end


tropical_linear_space(vertex_edge_matrix(HHH3[1])) * (-tropical_linear_space(vertex_edge_matrix(HHH2[3])))

tropical_intersection_product(HHH5[10], HHH4)

HHH = Gexcisions[length(Gexcisions)-1]
TTT = []
for HH in HHH
    b, TT = has_isolated_triangle(HH)
    if b == true
        push!(TTT, TT)
    end
end



G = triangle_chain(7)
check_chain(G, 6) # 243 excisions

