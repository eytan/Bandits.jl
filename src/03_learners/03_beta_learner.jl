"""
A BetaLearner object stores a Beta posterior over all arms.
"""
struct BetaLearner <: Learner
    αs::Vector{Float64}
    βs::Vector{Float64}
    α₀::Float64
    β₀::Float64
    ns::Vector{Int64}
    μs::Vector{Float64}
    σs::Vector{Float64}
end

"""
Create a BetaLearner object specifying the prior parameters. Defaults to
the Jeffreys prior.
"""
function BetaLearner(α₀::Float64 = 0.5, β₀::Float64 = 0.5)
    return BetaLearner(
      Array{Float64}(undef, 0),
      Array{Float64}(undef, 0),
      Float64(α₀),
      Float64(β₀),
      Array{Int64}(undef, 0),
      Array{Float64}(undef, 0),
      Array{Float64}(undef, 0),
    )
end

"""
Return the counts for each arm.
"""
counts(learner::BetaLearner) = learner.ns

"""
Return the means for each arm.
"""
means(learner::BetaLearner) = learner.μs

"""
Return the standard deviations for each arm.
"""
stds(learner::BetaLearner) = learner.σs

"""
Reset the BetaLearner object for K arms.
"""
function initialize!(learner::BetaLearner, K::Integer)
    resize!(learner.αs, K)
    resize!(learner.βs, K)
    resize!(learner.ns, K)
    resize!(learner.μs, K)
    resize!(learner.σs, K)

    fill!(learner.αs, learner.α₀)
    fill!(learner.βs, learner.β₀)
    fill!(learner.ns, 0)

    for a in 1:K
        learner.μs[a] = mean(Beta(learner.αs[a], learner.βs[a]))
        learner.σs[a] = std(Beta(learner.αs[a], learner.βs[a]))
    end

    return
end

"""
Learn about arm a on trial t from reward r.
"""
function learn!(
    learner::BetaLearner,
    context::Context,
    a::Integer,
    r::T,
) where T <: Real
    if r == one(T)
        learner.αs[a] += 1
    elseif r == zero(T)
        learner.βs[a] += 1
    else
        throw(DomainError())
    end
    learner.ns[a] += 1
    learner.μs[a] = mean(Beta(learner.αs[a], learner.βs[a]))
    learner.σs[a] = std(Bernoulli(mean(Beta(learner.αs[a], learner.βs[a]))))

    return
end

"""
Draw a sample from the posterior for arm a.
"""
function Base.rand(learner::BetaLearner, a::Integer)
    return rand(Beta(learner.αs[a], learner.βs[a]))
end

function Base.show(io::IO, learner::BetaLearner)
    @printf(io, "BetaLearner(%f, %f)", learner.α₀, learner.β₀)
end
