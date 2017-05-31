@doc """
A JamesSteinLearner object stores the online estimated mean and variance of all
arms. Arms with zero counts use a default mean and standard deviation.
""" ->
immutable JamesSteinLearner <: Learner
    ns::Vector{Int64}
    oldMs::Vector{Float64}
    newMs::Vector{Float64}
    Ss::Vector{Float64}
    ys::Vector{Float64}
    ss::Vector{Float64}
    μs::Vector{Float64}
    σs::Vector{Float64}
    μ₀::Float64
    σ₀::Float64
    K::Int64
end

@doc """
Create an JamesSteinLearner object specifying only a default mean and standard
deviation.
""" ->
function JamesSteinLearner(μ₀::Real, σ₀::Real)
    return JamesSteinLearner(
      Array(Int64, 0),
      Array(Float64, 0),
      Array(Float64, 0),
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
counts(learner::JamesSteinLearner) = learner.ns

@doc """
Return the means for each arm.
""" ->
means(learner::JamesSteinLearner) = learner.μs

@doc """
Return the standard deviations for each arm.
""" ->
stds(learner::JamesSteinLearner) = learner.σs

@doc """
Reset the JamesSteinLearner object for K arms.
""" ->
function initialize!(learner::JamesSteinLearner, K::Integer)
    resize!(learner.ns, K)
    resize!(learner.oldMs, K)
    resize!(learner.newMs, K)
    resize!(learner.Ss, K)
    resize!(learner.ys, K)
    resize!(learner.ss, K)
    resize!(learner.μs, K)
    resize!(learner.σs, K)

    fill!(learner.ns, 0)
    fill!(learner.ys, learner.μ₀)
    fill!(learner.μs, learner.μ₀)
    fill!(learner.ss, learner.σ₀)
    fill!(learner.σs, learner.σ₀)

    return
end

@doc """
Learn about arm a on trial t from reward r.
""" ->
function learn!(
    learner::JamesSteinLearner,
    context::Context,
    a::Integer,
    r::Real,
)
    learner.ns[a] += 1
    nᵢ = learner.ns[a]

    if nᵢ == 1
        learner.oldMs[a] = r
        learner.Ss[a] = learner.σ₀
        learner.ys[a] = r
        learner.μs[a] = r
    else
        learner.newMs[a] = learner.oldMs[a] + (r - learner.oldMs[a]) / nᵢ
        learner.Ss[a] += (r - learner.oldMs[a]) * (r - learner.newMs[a])
        learner.oldMs[a] = learner.newMs[a]
        learner.ys[a] = learner.newMs[a]
        learner.ss[a] = learner.Ss[a] / (nᵢ - 1) / nᵢ
        y̅ = mean(learner.ys)
        φs = min(1.0, learner.ss ./ (sumabs2(learner.ys - y̅) ./ (learner.K - 3)))
        learner.μs[:] = y̅ + (1 - φs) .* (learner.ys - y̅)
        learner.σs[:] = sqrt(
            (1 - φs) .* learner.ss +
            φs .* learner.ss ./ learner.K +
            2 .* φs.^2 .* (learner.ys - y̅).^2 ./ (learner.K - 3)
        )
    end

    return
end

@doc """
Draw a sample from the posterior for arm a.
""" ->
function Base.rand(learner::JamesSteinLearner, a::Integer)
    return rand(Normal(learner.μs[a], learner.σs[a]))
end

function Base.show(io::IO, learner::JamesSteinLearner)
    @printf(io, "JamesSteinLearner(%f, %f)", learner.μ₀, learner.σ₀)
end
