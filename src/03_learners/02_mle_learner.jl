using StreamStats
import Base.mean, Base.std

import StreamStats.update!

@doc """
A MLELearner object stores the online estimated mean and variance of all
arms. Arms with zero counts use a default mean and standard deviation.
""" ->
type MLELearner <: Learner
    stats::Vector{StreamStats.Variance}
    μ₀::Float64
    σ₀::Float64
end

@doc """
Create an MLELearner object specifying only a default mean and standard
deviation.
""" ->
function MLELearner(μ₀::Real, σ₀::Real)
    return MLELearner(
      Array(StreamStats.Variance, 0),
      μ₀,
      σ₀
    )
end

@doc """
Return the count for an arm.
""" ->
counts(learner::MLELearner, a::Int64) = nobs(learner.stats[i])

@doc """
Return the counts for each arm.
""" ->
counts(learner::MLELearner) = [nobs(i) for i in learner.stats]

@doc """
Return the estimated mean of an arm.
""" ->
function mean(learner::MLELearner, a::Int64)
    return mean(learner.stats[a])
end

@doc """
Return the estimated means for each arms.
""" ->
function means(learner::MLELearner)
    return [mean(i) for i in learner.stats]
end

@doc """
Return the estimated standard deviation of an arm.
""" ->
function std(learner::MLELearner, a::Int64)
    return std(learner.stats[a])
end

@doc """
Return the estimated standard deviations for each arm.
""" ->
function stds(learner::MLELearner)
    return [std(i) for i in learner.stats]
end

@doc """
Reset the MLELearner object for K arms.
""" ->
function initialize!(learner::MLELearner, K::Integer)
    resize!(learner.replicates, K)
    for a in 1:K
        learner.stats[a] = StreamStats.Variance(learner.μ₀, 0.0, learner.σ₀, 0)
    end
    return
end

@doc """
Learn about arm a on trial t from reward r.
""" ->
function learn!(
    learner::MLELearner,
    context::Context,
    a::Integer,
    r::Real,
)
    update!(learner.stats[a], r)
    return
end

function Base.show(io::IO, learner::MLELearner)
    @printf(io, "MLELearner(%f, %f)", learner.μ₀, learner.σ₀)
end
