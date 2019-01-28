struct RExp3{L <: Learner} <: Algorithm
    learner::L
    γ::Float64
    w::Vector{Float64}
    p::Vector{Float64}
    batch_size::Int64
end

function RExp3(learner::Learner, γ::Real, batch_size::Int64)
    RExp3(learner, Float64(γ), Array{Float64}(undef, 0), Array{Float64}(undef, 0), Int64(batch_size))
end

function initialize!(algorithm::RExp3, K::Integer)
    initialize!(algorithm.learner, K)
    resize!(algorithm.w, K)
    resize!(algorithm.p, K)
    fill!(algorithm.w, 1.0)
    fill!(algorithm.p, 1.0 / K)
    return
end

function choose_arm(algorithm::RExp3, context::Context)
    return rand(Categorical(algorithm.p))
end

function learn!(algorithm::RExp3, context::Context, a::Integer, r::Real)
    learn!(algorithm.learner, context, a, r)
    γ = algorithm.γ
    algorithm.w[a] *= exp((γ / context.K) * (r / algorithm.p[a]))
    z = sum(algorithm.w)
    for a in 1:context.K
        algorithm.p[a] = γ * (1 / context.K) + (1 - γ) * (algorithm.w[a] / z)
    end
    # reset step
    if context.t > 1 && context.t % algorithm.batch_size == 0
        initialize!(algorithm, context.K)
    end
    return
end

function Base.show(io::IO, algorithm::RExp3)
    @printf(
        io,
        "RSoftmax(%f, %s, %d)",
        algorithm.γ,
        string(algorithm.learner),
        algorithm.batch_size
    )
end
