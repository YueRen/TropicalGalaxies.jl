include("helpers.jl")

G = triangle_chain(7)
@time Gexcisions = all_excisions(G);
FFs = Gexcisions[5]
HHs = Gexcisions[4]
HHsSortedDict = triangle_group(triangle_sort(HHs))
fixedTriangle = collect(keys(HHsSortedDict))

TropF = tropical_linear_space(FFs[5])
for (i, j) in enumerate(HHs) 
    TropH = tropical_linear_space(j)
    n = TropF * (-TropH)
    if n >= 1
        println("$i: ", n)
    end
end
