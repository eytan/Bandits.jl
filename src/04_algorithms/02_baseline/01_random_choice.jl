@doc """
A RandomChoice algorithm is like an A/B test: it selects between all arms
uniformly at random.
""" ->
immutable RandomChoice{L <: Learner} <: Algorithm
    learner::L
    policy::Vector{Float64}
end

@doc """
Prepare to choose an arm uniformly at random.
""" ->
function update_policy!(algorithm::RandomChoice, context::Context)
    K = context.K
    for i in 1:K
        algorithm.policy[i] = 1 / K
    end
    return
end

@doc """
Choose an arm uniformly at random.
""" ->
function choose_arm(algorithm::RandomChoice, context::Context)
    return rand(1:context.K)
end

function Base.show(io::IO, algorithm::RandomChoice)
    @printf(io, "RandomChoice")
end
