"""
An AnnealingEpsilonGreedy object represents a variant of the constant-ε bandit
algorithm in which ε decreases with a logarithmic annealing schedule.
"""
struct AnnealingEpsilonGreedy{L <: Learner} <: Algorithm
    learner::L
end

"""
With probability ε, choose from all arms uniformly at random. With probability
1 - ε, choose the preferred arm. Compute ε using a logarithmic annealing
schedule.
"""
function choose_arm(algorithm::AnnealingEpsilonGreedy, context::Context)
    ε = 1 / log(e + context.t - 1)
    if rand() < ε
        return rand(1:context.K)
    else
        return preferred_arm(algorithm, context)
    end
end

function Base.show(io::IO, algorithm::AnnealingEpsilonGreedy)
    @printf(io, "AnnealingEpsilonGreedy(%s)", string(algorithm.learner))
end
