type Hedge{L <: Learner} <: Algorithm
    learner::L
    η::Float64
    sums::Vector{Float64}
    wsums::Vector{Float64}
    ps::Vector{Float64}
end

Hedge(learner::Learner, η::Real) = Hedge(
    learner,
    Float64(η),
    Array(Float64, 0),
    Array(Float64, 0),
    Array(Float64, 0),
)

function initialize!(algorithm::Hedge, K::Integer)
    initialize!(algorithm.learner, K)
    resize!(algorithm.sums, K)
    resize!(algorithm.wsums, K)
    resize!(algorithm.ps, K)
    fill!(algorithm.sums, 0.0)
    fill!(algorithm.wsums, 0.0)
    fill!(algorithm.ps, 1 / K)
    return
end

function choose_arm(algorithm::Hedge, context::Context)
    rand(Categorical(algorithm.ps))
end

function learn!(algorithm::Hedge, context::Context, a::Integer, r::Real)
    learn!(algorithm.learner, context, a, r)
    algorithm.sums[a] += r
    for i in 1:context.K
        algorithm.wsums[i] = algorithm.η * algorithm.sums[i]
    end
    softmax!(algorithm.ps, algorithm.wsums)
    return
end

function Base.show(io::IO, algorithm::Hedge)
    @printf(
        io,
        "Hedge(%f, %s)",
        algorithm.η,
        string(algorithm.learner),
    )
end
