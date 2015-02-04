@doc """
An EpsilonGreedy object represents the standard, constant-ε bandit algorithm.
""" ->
immutable EpsilonGreedy{L <: Learner} <: Algorithm
    learner::L
    ε::Float64
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
