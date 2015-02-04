@doc """
A RandomChoice algorithm is like an A/B test: it selects between all arms
uniformly at random.
""" ->
immutable RandomChoice{L <: Learner} <: Algorithm
    learner::L
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
