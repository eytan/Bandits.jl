@doc """
A DecreasingEpsilonGreedy object represents a variant of the constant-ε bandit
algorithm in which ε decreases according to two parameters, c and d.
""" ->
immutable DecreasingEpsilonGreedy{L <: Learner} <: Algorithm
    learner::L
    c::Float64
    d::Float64
    policy::Vector{Float64}
end

@doc """
Update policy based on belief about best arm.
""" ->
function update_policy!(algorithm::DecreasingEpsilonGreedy, context::Context)
    ε = min(1.0, (algorithm.c * context.K) / (algorithm.d^2 * context.t))
    K = length(algorithm.policy)
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
1 - ε, choose the preferred arm. Compute ε using a fixed rule.
""" ->
function choose_arm(algorithm::DecreasingEpsilonGreedy, context::Context)
    ε = min(1.0, (algorithm.c * context.K) / (algorithm.d^2 * context.t))
    if rand() < ε
        return rand(1:context.K)
    else
        return preferred_arm(algorithm, context)
    end
end

function Base.show(io::IO, algorithm::DecreasingEpsilonGreedy)
    @printf(
        io,
        "DecreasingEpsilonGreedy(%f, %f, %s)",
        algorithm.c,
        algorithm.d,
        string(algorithm.learner),
    )
end
