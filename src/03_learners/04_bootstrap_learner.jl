"""
A BootstrapLearner object stores R replicates of learner instances.
Learning happens on half the replicates (on average) for each trial.
This object is intended for use with Bootstrap Thompson Sampling (BTS)
"""
abstract type BootstrapLearner <: Learner end

"""
A BootstrapMLELearner object is a MLELearner-based BootstrapLearner
"""
struct BootstrapMLELearner <: BootstrapLearner
    replicates::Vector{MLELearner}
    R::Int
    mle_learner::MLELearner
    bootstrap_learn!::Function
end

"""
Constructs a BootstrapMLELearner with R replicates and some initial mean and standard deviation
"""
function BootstrapMLELearner(R::Int64, μ₀::Float64, σ₀::Float64, bootstrap_type="half_sample")
    replicates = [MLELearner(μ₀, σ₀) for i in 1:R]
    if bootstrap_type == "half_sample"
        bl_func = half_sample_learn!
    else
        error("unrecognized bootstrap function: ", bootstrap_type)
    end
    BootstrapMLELearner(replicates, R, MLELearner(μ₀, σ₀), bl_func)
end

"""
Return the total number of trials.
"""
counts(learner::BootstrapLearner) = counts(learner.mle_learner)

"""
Return the grand means for each arm.
"""
means(learner::BootstrapLearner) = means(learner.mle_learner)

"""
Return the standard deviations for each arm.
"""
stds(learner::BootstrapLearner) = stds(learner.mle_learner)

"""
Reset constituent replicates.
"""
function initialize!(learner::BootstrapLearner, i_args...)
    initialize!(learner.mle_learner, i_args...)
    for i in 1:learner.R
        initialize!(learner.replicates[i], i_args...)
    end
    return
end

"""
Learn about arm a on trial t from reward r.
"""
function learn!(learner::BootstrapLearner, context::Context, a::Integer, r::Real)
    learner.bootstrap_learn!(learner, context, a, r)
end

"""
Learn about arm a on trial t from reward r for random subset of replicates.
"""
function half_sample_learn!(learner::BootstrapLearner, context::Context, a::Integer, r::Real)
    learn!(learner.mle_learner, context, a, r)
    for i in 1:learner.R
        # half sampling bootstrap
        if rand() > 0.5
            learn!(learner.replicates[i], context, a, r)
        end
    end
end

"""
Draw a sample from the bootstrap distribution of the mean for arm a.
"""
function Base.rand(learner::BootstrapLearner, a::Integer)
    means(learner.replicates[rand(1:learner.R)])[a]
end