immutable Exp3{L <: Learner} <: Algorithm
    learner::L
    γ::Float64
    w::Vector{Float64}
    p::Vector{Float64}
end

function Exp3(learner::Learner, γ::Real)
    Exp3(learner, Float64(γ), Array(Float64, 0), Array(Float64, 0))
end

function initialize!(algorithm::Exp3, K::Integer)
    initialize!(algorithm.learner, K)
    resize!(algorithm.w, K)
    resize!(algorithm.p, K)
    fill!(algorithm.w, 1.0)
    fill!(algorithm.p, 1.0 / K)
    return
end

function choose_arm(algorithm::Exp3, context::Context)
    return rand(Categorical(algorithm.p))
end

function learn!(algorithm::Exp3, context::Context, a::Integer, r::Real)
    learn!(algorithm.learner, context, a, r)
    γ = algorithm.γ
    algorithm.w[a] *= exp((γ / context.K) * (r / algorithm.p[a]))
    z = sum(algorithm.w)
    for a in 1:context.K
        algorithm.p[a] = γ * (1 / context.K) + (1 - γ) * (algorithm.w[a] / z)
    end
    return
end

function Base.show(io::IO, algorithm::Exp3)
    @printf(
        io,
        "Softmax(%f, %s)",
        algorithm.γ,
        string(algorithm.learner),
    )
end
