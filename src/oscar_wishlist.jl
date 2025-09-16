###
# Functions that should be in OSCAR
###

function Base.:(-)(TropV::Oscar.TropicalVarietySupertype)
    maximalPolyhedra = maximal_polyhedra(IncidenceMatrix,TropV)
    verticesAndRays = vertices_and_rays(TropV)
    rayIndices = findall(vr -> (vr isa RayVector), verticesAndRays)
    lineality = lineality_space(TropV)
    verticesAndRaysMatrix = matrix(QQ,Vector.(verticesAndRays))
    polyhedralComplex = polyhedral_complex(maximalPolyhedra, -verticesAndRaysMatrix, rayIndices, lineality)
    mults = multiplicities(TropV)
    return tropical_variety(polyhedralComplex, mults, convention(TropV))
end

function Base.:(*)(TropV1::Oscar.TropicalVarietySupertype, TropV2::Oscar.TropicalVarietySupertype)

    # TODO: add basic assertions to check that TropV1 and TropV2 are as expected
    # (of complementary dimension modulo lineality)

    return sum(multiplicities(stable_intersection(TropV1, TropV2)))
end

function reduce_chain(F)
    i = 0
    n = length(F)
    Fred = Vector{Int}[ [] for _ in 1:n ]
    while true
        i += 1
        j = findfirst(j -> (i in data(F[j])), 1:n)
        if isnothing(j)
            return Fred
        end
        Fred[j] = push!(Fred[j], i)
    end
end
