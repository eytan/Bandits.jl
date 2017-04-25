@doc """
An AnnealingSoftmax object represents a variant of the constant temperature
softmax algorithm in which the temperature decreases according to a
logarithmic annealing schedule.
""" ->
immutable AnnealingSoftmax{L <: Learner} <: Algorithm
    learner::L
    τ₀::Float64
    tmeans::Vector{Float64}
    probs::Vector{Float64}
end

@doc """
Construct an AnnealingSoftmax object given a learner and an initial
temperature.
""" ->
function AnnealingSoftmax(learner::Learner, τ₀::Real)
    return AnnealingSoftmax(
        learner,
        Float64(τ₀),
        Array(Float64, 0),
        Array(Float64, 0),
    )
end

@doc """
Initialize an AnnealingSoftmax object.
""" ->
function initialize!(algorithm::AnnealingSoftmax, K::Integer)
    initialize!(algorithm.learner, K)
    resize!(algorithm.tmeans, K)
    resize!(algorithm.probs, K)
    return
end

@doc """
Update policy based on empirical means and temperature.
""" ->
function update_policy!(algorithm::AnnealingSoftmax, context::Context)
    μs = means(algorithm.learner)
    τ = algorithm.τ₀ / log(e + context.t - 1)
    for i in 1:context.K
        algorithm.tmeans[i] = μs[i] / τ
    end
    softmax!(algorithm.probs, algorithm.tmeans)
    return
end

@doc """
Select an arm according to the softmax rule. First, the current temperature
is computed. Then we recompute temperature adjusted means to make sure that the
softmax selection probabilities are correct.
""" ->
function choose_arm(algorithm::AnnealingSoftmax, context::Context)
    μs = means(algorithm.learner)
    τ = algorithm.τ₀ / log(e + context.t - 1)
    for i in 1:context.K
        algorithm.tmeans[i] = μs[i] / τ
    end
    softmax!(algorithm.probs, algorithm.tmeans)
    return rand(Categorical(algorithm.probs))
end

function Base.show(io::IO, algorithm::AnnealingSoftmax)
    @printf(
        io,
        "AnnealingSoftmax(%f, %s)",
        algorithm.τ₀,
        string(algorithm.learner),
    )
end
