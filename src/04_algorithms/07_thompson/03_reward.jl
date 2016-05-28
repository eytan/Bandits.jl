immutable RewardSampling{L <: Learner} <: Algorithm
    learner::L
end

function choose_arm(algorithm::RewardSampling, context::Context)
    arms = 1:context.K
    est_rewards = [rand(algorithm.learner, a) for a in arms]
    return sample(arms, WeightVec(est_rewards))
end

function Base.show(io::IO, algorithm::RewardSampling)
    @printf(
        io,
        "RewardSampling(%s)",
        string(algorithm.learner),
    )
end
