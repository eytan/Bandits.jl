"""
A Softmax object represents the standard, constant temperature softmax
algorithm.
"""
struct Softmax{L <: Learner} <: Algorithm
    learner::L
    τ::Float64
    tmeans::Vector{Float64}
    probs::Vector{Float64}
end

"""
Construct a Softmax object given a learner and a temperature.
"""
function Softmax(learner::Learner, τ::Real)
    return Softmax(
        learner,
        Float64(τ),
        Array{Float64}(undef, 0),
        Array{Float64}(undef, 0),
    )
end

"""
Initialize a Softmax object.
"""
function initialize!(algorithm::Softmax, K::Integer)
    initialize!(algorithm.learner, K)
    resize!(algorithm.tmeans, K)
    resize!(algorithm.probs, K)
    return
end

"""
Select an arm according to the softmax rule. Recompute temperature adjusted
means to make sure that the softmax selection probabilities are correct.
"""
function choose_arm(algorithm::Softmax, context::Context)
    μs = means(algorithm.learner)
    τ = algorithm.τ
    for i in 1:context.K
        algorithm.tmeans[i] = μs[i] / τ
    end
    softmax!(algorithm.probs, algorithm.tmeans)
    return rand(Categorical(algorithm.probs))
end

function Base.show(io::IO, algorithm::Softmax)
    @printf(
        io,
        "Softmax(%f, %s)",
        algorithm.τ,
        string(algorithm.learner),
    )
end
