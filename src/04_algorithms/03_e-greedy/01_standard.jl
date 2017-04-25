@doc """
An EpsilonGreedy object represents the standard, constant-ε bandit algorithm.
""" ->
immutable EpsilonGreedy{L <: Learner} <: Algorithm
    learner::L
    ε::Float64
    policy::Vector{Float64}
end

@doc """
Update policy based on belief about best arm.
""" ->
function update_policy!(algorithm::EpsilonGreedy, context::Context)
    ε, K = algorithm.ε, length(algorithm.policy)
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
1 - ε, choose the preferred arm.
""" ->
function choose_arm(algorithm::EpsilonGreedy, context::Context)
    if rand() < algorithm.ε
        return rand(1:context.K)
    else
        return preferred_arm(algorithm, context)
    end
end

function Base.show(io::IO, algorithm::EpsilonGreedy)
    @printf(
        io,
        "EpsilonGreedy(%f, %s)",
        algorithm.ε,
        string(algorithm.learner),
    )
end
