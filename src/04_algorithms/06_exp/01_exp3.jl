immutable Exp3 <: Algorithm
    γ::Float64
    w::Vector{Float64}
    p::Vector{Float64}
end

Exp3(γ::Real) = Exp3(float64(γ), Array(Float64, 0), Array(Float64, 0))

function initialize!(algorithm::Exp3, K::Integer)
    resize!(algorithm.w, K)
    resize!(algorithm.p, K)
    fill!(algorithm.w, 1.0)
    fill!(algorithm.p, 1.0 / K)
    return
end

# NB: Assumes p is set correctly
function choose_arm(algorithm::Exp3, context::Context)
    return rand(Categorical(algorithm.p))
end

# NB: Assumes p is set correctly
function learn!(algorithm::Exp3, context::Context, i::Integer, r::Real)
    γ = algorithm.γ
    algorithm.w[i] *= exp((γ / context.K) * (r / algorithm.p[i]))
    z = sum(algorithm.w)
    for i in 1:context.K
        algorithm.p[i] = γ * (1 / context.K) + (1 - γ) * (algorithm.w[i] / z)
    end
    return
end
