@doc """
A BootstrapLearner object stores R replicates of learner instances.
Learning happens on half the replicates (on average) for each trial.
This object is intended for use with Bootstrap Thompson Sampling (BTS)
""" ->
abstract BootstrapLearner <: Learner

@doc """
A BootstrapMLELearner object is a MLELearner-based BootstrapLearner
""" ->
immutable BootstrapMLELearner <: BootstrapLearner
    replicates::Vector{StreamStats.Bootstrap}
    grand_means::Vector{StreamStats.Mean}
    R::Int64
    μ₀::Float64
end

@doc """
Constructs a BootstrapMLELearner with R replicates and some initial mean and standard deviation
""" ->
function BootstrapMLELearner(R::Int64, μ₀::Float64, bootstrap_type=:half_sample)
    if bootstrap_type == :half_sample
        b = Array(StreamStats.BernoulliBootstrap{StreamStats.Mean}, 0)
    else:
        error("unrecognized bootstrap type: ", bootstrap_type)
    end
    BootstrapMLELearner(b, Array(StreamStats.Mean, 0), R, μ₀)
end

@doc """
Return the total number of trials.
""" ->
counts(learner::BootstrapLearner) = [nobs(i) for i in learner.grand_means]

@doc """
Return the grand means for each arm.
""" ->
means(learner::BootstrapLearner) = [mean(i) for i in learner.grand_means]

@doc """
Return the standard deviations for each arm.
""" ->
function stds(learner::BootstrapLearner)
    return [std(i) for i in learner.replicates]
end

@doc """
Reset constituent replicates.
""" ->
function initialize!(learner::BootstrapMLELearner, K::Integer)
    resize!(learner.grand_means, K)
    resize!(learner.replicates, K)
    for a in 1:K
        learner.grand_means[a] = StreamStats.Mean(learner.μ₀, 0)
        learner.replicates[a] =
            StreamStats.BernoulliBootstrap(StreamStats.Mean(learner.μ₀, 0), learner.R)
    end
end

@doc """
Learn about arm a on trial t from reward r.
""" ->
function learn!(learner::BootstrapLearner, context::Context, a::Integer, r::Real)
    StreamStats.update!(learner.grand_means[a], r)
    StreamStats.update!(learner.replicates[a], r)
end

@doc """
Draw a sample from the bootstrap distribution of the mean for arm a.
""" ->
function Base.rand(learner::BootstrapLearner, a::Integer)
    Base.rand(learner.replicates[a])
end

function Base.show(io::IO, learner::BootstrapLearner)
    @printf(io, "BootstrapMLELearner(%u)", length(learner.replicates))
end
