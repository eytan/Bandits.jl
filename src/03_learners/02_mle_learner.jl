@doc """
A MLELearner object stores the online estimated mean and variance of all
arms. Arms with zero counts use a default mean and standard deviation.
""" ->
immutable MLELearner <: Learner
    ns::Vector{Int64}
    oldMs::Vector{Float64}
    newMs::Vector{Float64}
    Ss::Vector{Float64}
    μs::Vector{Float64}
    σs::Vector{Float64}
    μ₀::Float64
    σ₀::Float64
end

@doc """
Create an MLELearner object specifying only a default mean and standard
deviation.
""" ->
function MLELearner(μ₀::Real, σ₀::Real)
    return MLELearner(
      Array(Int64, 0),
      Array(Float64, 0),
      Array(Float64, 0),
      Array(Float64, 0),
      Array(Float64, 0),
      Array(Float64, 0),
      Float64(μ₀),
      Float64(σ₀),
    )
end

@doc """
Return the counts for each arm.
""" ->
counts(learner::MLELearner) = learner.ns

@doc """
Return the means for each arm.
""" ->
means(learner::MLELearner) = learner.μs

@doc """
Return the standard deviations for each arm.
""" ->
stds(learner::MLELearner) = learner.σs

@doc """
Reset the MLELearner object for K arms.
""" ->
function initialize!(learner::MLELearner, K::Integer)
    resize!(learner.ns, K)
    resize!(learner.oldMs, K)
    resize!(learner.newMs, K)
    resize!(learner.Ss, K)
    resize!(learner.μs, K)
    resize!(learner.σs, K)

    fill!(learner.ns, 0)
    fill!(learner.μs, learner.μ₀)
    fill!(learner.σs, learner.σ₀)

    return
end

@doc """
Learn about arm a on trial t from reward r.
""" ->
function learn!(
    learner::MLELearner,
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
    else
        learner.newMs[a] = learner.oldMs[a] + (r - learner.oldMs[a]) / nᵢ
        learner.Ss[a] += (r - learner.oldMs[a]) * (r - learner.newMs[a])
        learner.oldMs[a] = learner.newMs[a]
        learner.μs[a] = learner.newMs[a]
        learner.σs[a] = sqrt(learner.Ss[a] / (nᵢ - 1))
    end

    return
end

function Base.show(io::IO, learner::MLELearner)
    @printf(io, "MLELearner(%f, %f)", learner.μ₀, learner.σ₀)
end


@doc """
Draw a sample from the posterior for arm a.
""" ->
function Base.rand(learner::MLELearner, a::Integer)
    return rand(Normal(learner.μs[a], sqrt(max(learner.σs[a], 0.1))))
end
