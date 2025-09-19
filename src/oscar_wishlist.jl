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

function translate_by_vector(
  u::PointVector{QQFieldElem}, v::Vector{QQFieldElem}
)
  return u + v
end

function translate_by_vector(
  u::RayVector{QQFieldElem}, ::Vector{QQFieldElem}
)
  return u
end

function +(v::Vector{QQFieldElem}, Sigma::PolyhedralComplex)
  @req length(v) == ambient_dim(Sigma) "ambient dimension mismatch"
  SigmaVertsAndRays = vertices_and_rays(Sigma)
  SigmaRayIndices = findall(vr -> vr isa RayVector, SigmaVertsAndRays)
  SigmaLineality = lineality_space(Sigma)
  SigmaIncidence = maximal_polyhedra(IncidenceMatrix, Sigma)
  return polyhedral_complex(
    coefficient_field(Sigma),
    SigmaIncidence,
    translate_by_vector.(SigmaVertsAndRays, Ref(v)),
    SigmaRayIndices,
    SigmaLineality,
  )
end
+(Sigma::PolyhedralComplex, v::Vector{QQFieldElem}) = v + Sigma

function +(v::Vector{QQFieldElem}, TropV::Oscar.TropicalVarietySupertype)
    @req length(v) == ambient_dim(TropV) "ambient dimension mismatch"
  return tropical_variety(
    polyhedral_complex(TropV) + v,
    multiplicities(TropV),
    convention(TropV)
  )
end

+(TropV::Oscar.TropicalVarietySupertype, v::Vector{QQFieldElem}) = v + TropV