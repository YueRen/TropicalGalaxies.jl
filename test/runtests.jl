using TropicalGalaxies
using Test

@testset "TropicalGalaxy.jl" begin
    # Write your tests here.

    # testing excisions and excision related functions
    G = undirected_multigraph(4, [(1, 2), (1, 3), (2, 3), (2, 4), (3, 4)])
    HH = undirected_multigraph(5, [(1, 5), (1, 5), (2, 3), (4, 5), (4, 5)])

    @test HH == excise(G, [2,3])
    @test is_fully_excised(HH) == false
    @test is_almost_fully_excised(HH) == true

    FF = undirected_multigraph(6, [(1, 5), (1, 5), (2, 3), (4, 6), (4, 6)])
    @test FF == excise(HH, [1,5])
    @test is_almost_fully_excised(FF) == false
    @test is_fully_excised(FF) == true

end
