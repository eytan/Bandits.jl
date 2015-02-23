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
    nobs::Vector{Integer}
    means::Vector{Float64}
    stds::VecOrMat{Float64}
end

@doc """
Create an MLELearner object specifying only a default mean and standard
deviation.
""" ->
function MLELearner(μ₀::Real, σ₀::Real)
    return MLELearner(
      Array(StreamStats.Variance, 0),
      μ₀,
      σ₀,
      Array(Integer, 0),
      Array(Float64, 0),
      Array(Float64, 0)
    )
end

@doc """
Return the count for an arm.
""" ->
counts(learner::MLELearner, a::Int64) = nobs(learner.stats[a])

@doc """
Return the counts for each arm.
""" ->
function counts(learner::MLELearner)
  for a in 1:length(learner.stats)
    learner.nobs[a] = nobs(learner.stats[a])
  end
  return learner.nobs
end

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
  for a in 1:length(learner.stats)
    learner.means[a] = mean(learner.stats[a])
  end
  return learner.means
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
  for a in 1:length(learner.stats)
    learner.stds[a] = std(learner.stats[a])
  end
  return learner.stds
end

@doc """
Reset the MLELearner object for K arms.
""" ->
function initialize!(learner::MLELearner, K::Integer)
    resize!(learner.stats, K)
    resize!(learner.nobs, K)
    resize!(learner.means, K)
    resize!(learner.stds, K)

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
