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

    return sum(multiplicities(stable_intersection((TropV1, TropV2))))
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


function tropical_intersection_multiplicity(sigma1::Polyhedron, sigma2::Polyhedron)
    B1 = kernel(affine_equation_matrix(affine_hull(sigma1))[:,2:end], side = :right)
    B1 = matrix(ZZ,[ numerator.(B1[:, i] .* lcm(denominator.(B1[:, i]))) for i in 1:ncols(B1) ])
    B1 = saturate(B1)

    B2 = kernel(affine_equation_matrix(affine_hull(sigma2))[:,2:end], side = :right)
    B2 = matrix(ZZ,[ numerator.(B2[:, i] .* lcm(denominator.(B2[:, i]))) for i in 1:ncols(B2) ])
    B2 = saturate(B2)

    @req ncols(B1) == ncols(B2) && nrows(B1)+nrows(B2) >= ncols(B1) "polyhedra do not span ambient space"

    return abs(prod(elementary_divisors(vcat(B1,B2))))
end


function tropical_intersection_number(T1, T2)
    polys_T1 = TropicalGalaxy.Oscar.maximal_polyhedra(T1)
    polys_T2 = TropicalGalaxy.Oscar.maximal_polyhedra(T2)
    if length(polys_T1) < length(polys_T2)
        T1, T2 = T2, T1
        polys_T1, polys_T2 = polys_T2, polys_T1
    end

    ambient_dim = TropicalGalaxy.Oscar.ambient_dim(T2)
    u = TropicalGalaxy.Oscar.QQ.(rand(Int, ambient_dim))
    # T2_shifted = TropicalGalaxy.Oscar.tropical_variety(T2) + u
    T2_shifted = T2 + u

    mult = 0

    for sigma in polys_T1
        for tau in TropicalGalaxy.Oscar.maximal_polyhedra(T2_shifted)
            inter = intersect(sigma, tau)
            if TropicalGalaxy.Oscar.dim(inter) >= 0
                m = TropicalGalaxy.tropical_intersection_multiplicity(sigma, tau)
                mult += m
            end
        end
    end
    return mult
end