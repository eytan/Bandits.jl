@doc """
A EBMLELearner object stores the online estimated mean and variance of all
arms. Arms with zero counts use a default mean and standard deviation.
""" ->
immutable EBMLELearner <: Learner
    ns::Vector{Int64}
    oldMs::Vector{Float64}
    newMs::Vector{Float64}
    Ss::Vector{Float64}
    μs::Vector{Float64}
    σs::Vector{Float64}
    μ₀::Float64
    σ₀::Float64
    K::Int64
end

@doc """
Create an EBMLELearner object specifying only a default mean and standard
deviation.
""" ->
function EBMLELearner(μ₀::Real, σ₀::Real)
    return EBMLELearner(
      Array(Int64, 0),
      Array(Float64, 0),
      Array(Float64, 0),
      Array(Float64, 0),
      Array(Float64, 0),
      Array(Float64, 0),
      Float64(μ₀),
      Float64(σ₀),
      Int64(1)
    )
end

@doc """
Return the counts for each arm.
""" ->
counts(learner::EBMLELearner) = learner.ns

@doc """
Return the means for each arm.
""" ->
means(learner::EBMLELearner) = learner.μ̃s

@doc """
Return the standard deviations for each arm.
""" ->
stds(learner::EBMLELearner) = learner.σ̃s

@doc """
Reset the EBMLELearner object for K arms.
""" ->
function initialize!(learner::EBMLELearner, K::Integer)
    learner.K = K
    resize!(learner.ns, K)
    resize!(learner.oldMs, K)
    resize!(learner.newMs, K)
    resize!(learner.Ss, K)
    resize!(learner.μs, K)
    resize!(learner.σs, K)

    fill!(learner.ns, 0)
    fill!(learner.μs, learner.μ₀)
    fill!(learner.μ̃s, learner.μ₀)
    fill!(learner.σs, learner.σ₀)
    fill!(learner.σ̃s, learner.σ̃₀)

    return
end

@doc """
Learn about arm a on trial t from reward r.
""" ->
function learn!(
    learner::EBMLELearner,
    context::Context,
    a::Integer,
    r::Real,
)
    learner.ns[a] += 1
    nᵢ = learner.ns[a]

    if nᵢ == 1
        learner.oldMs[a] = r
        learner.Ss[a] = 0.0
        learner.μs[a] = r
        learner.μ̃s[a] = r
    else
        learner.newMs[a] = learner.oldMs[a] + (r - learner.oldMs[a]) / nᵢ
        learner.Ss[a] += (r - learner.oldMs[a]) * (r - learner.newMs[a])
        learner.oldMs[a] = learner.newMs[a]
        learner.μs[a] = learner.newMs[a]
        learner.σs[a] = sqrt(learner.Ss[a] / (nᵢ - 1))
        y̅ = mean(learner.μs)
        φs = min(1.0, learner.σs / (sumabs2(learner.μs - y̅) / (learner.K - 3)))
        learner.μ̃s = learner.μs + φs .* (y̅ - learner.μs)
        learner.σ̃s = sqrt(
          (1 - φs) .* learner.σs +
          learner.σs / learner.K +
          2 .* φs .* (learner.μs - y̅).^2 / (learner.K - 3)
        )
    end

    return
end

function Base.show(io::IO, learner::EBMLELearner)
    @printf(io, "EBMLELearner(%f, %f)", learner.μ₀, learner.σ₀)
end
