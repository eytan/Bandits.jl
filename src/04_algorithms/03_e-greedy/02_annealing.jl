@doc """
An AnnealingEpsilonGreedy object represents a variant of the constant-ε bandit
algorithm in which ε decreases with a logarithmic annealing schedule.
""" ->
immutable AnnealingEpsilonGreedy{L <: Learner} <: Algorithm
    learner::L
    policy::Vector{Float64}
end

@doc """
Update policy based on belief about best arm.
""" ->
function update_policy!(algorithm::AnnealingEpsilonGreedy, context::Context)
    ε, K = 1 / log(e + context.t - 1), length(algorithm.policy)
    a_star = preferred_arm(algorithm, context)
    for i in 1:K
        if i != a_star
            algorithm.policy[i] = ε / K
        else
            algorithm.policy[i] = (1 - ε) + ε / K
        end
    end
    return
end

@doc """
With probability ε, choose from all arms uniformly at random. With probability
1 - ε, choose the preferred arm. Compute ε using a logarithmic annealing
schedule.
""" ->
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
