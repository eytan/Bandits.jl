immutable ReinforcementComparison{L <: Learner} <: Algorithm
    learner::L
    α::Float64
    β::Float64
    r0::Float64
    r_bar::Vector{Float64}
    π::Vector{Float64}
    p::Vector{Float64}
end

function ReinforcementComparison(
    learner::Learner,
    α::Real,
    β::Real,
    r0::Real,
)
    return ReinforcementComparison(
        learner,
        float64(α),
        float64(β),
        float64(r0),
        Array(Float64, 1),
        Array(Float64, 0),
        Array(Float64, 0),
    )
end

function initialize!(algorithm::ReinforcementComparison, K::Integer)
    initialize!(algorithm.learner, K)
    resize!(algorithm.π, K)
    resize!(algorithm.p, K)
    fill!(algorithm.π, 1.0) # π0
    fill!(algorithm.p, 1.0 / K)
    algorithm.r_bar[1] = algorithm.r0
    return
end

function choose_arm(algorithm::ReinforcementComparison, context::Context)
    return rand(Categorical(algorithm.p))
end

function learn!(
    algorithm::ReinforcementComparison,
    context::Context,
    a::Integer,
    r::Real,
)
    learn!(algorithm.learner, context, a, r)
    α = algorithm.α
    algorithm.r_bar[1] = (1 - α) * algorithm.r_bar[1] + α * r
    algorithm.π[a] += algorithm.β * (r - algorithm.r_bar[1])
    softmax!(algorithm.p, algorithm.π)
    return
end

function Base.show(io::IO, algorithm::ReinforcementComparison)
    @printf(
        io,
        "ReinforcementComparison(%f, %f, %f, %s)",
        algorithm.α,
        algorithm.β,
        algorithm.r0,
        string(algorithm.learner),
    )
end
