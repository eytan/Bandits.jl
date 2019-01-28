"""
A DiscLearner object stores the online estimated discounted mean.
The number of observations for each arm is also discounted and stored.
In addition, undiscounted mean and standard deviation are also stored.
Arms with zero counts use a default mean and standard deviation.
"""
struct DiscLearner <: Learner
    ns::Vector{Int64}
    oldMs::Vector{Float64}
    newMs::Vector{Float64}
    Ss::Vector{Float64}
    μs::Vector{Float64}
    σs::Vector{Float64}
    μ₀::Float64
    σ₀::Float64
    gamma::Float64
    discNs::Vector{Float64}
    discMs::Vector{Float64}
end

"""
Create an DiscLearner object specifying only a default mean, standard
deviation, and the discount parameter gamma.
"""
function DiscLearner(μ₀::Real, σ₀::Real, gamma::Real)
    return DiscLearner(
      Array{Int64}(undef, 0),
      Array{Float64}(undef, 0),
      Array{Float64}(undef, 0),
      Array{Float64}(undef, 0),
      Array{Float64}(undef, 0),
      Array{Float64}(undef, 0),
      Float64(μ₀),
      Float64(σ₀),
      Float64(gamma),
      Array{Float64}(undef, 0),
      Array{Float64}(undef, 0),
    )
end

"""
Return the discounted counts for each arm.
"""
counts(learner::DiscLearner) = learner.discNs

"""
Return the discounted means for each arm.
"""
means(learner::DiscLearner) = learner.discMs ./ learner.discNs

"""
Return the standard deviations for each arm.
"""
stds(learner::DiscLearner) = learner.σs

"""
Return the (undiscounted) counts for each arm.
"""
num_pulls(learner::DiscLearner) = learner.ns

"""
Reset the DiscLearner object for K arms.
"""
function initialize!(learner::DiscLearner, K::Integer)
    resize!(learner.ns, K)
    resize!(learner.oldMs, K)
    resize!(learner.newMs, K)
    resize!(learner.Ss, K)
    resize!(learner.μs, K)
    resize!(learner.σs, K)
    resize!(learner.discNs, K)
    resize!(learner.discMs, K)

    fill!(learner.ns, 0)
    fill!(learner.μs, learner.μ₀)
    fill!(learner.σs, learner.σ₀)
    fill!(learner.discNs, 1)
    fill!(learner.discMs, 1)    

    return
end


"""
Learn about arm a on trial t from reward r.
"""
function learn!(
    learner::DiscLearner,
    context::Context,
    a::Integer,
    r::Real,
)
    K = length(learner.ns)
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

    for i=1:K
        learner.discNs[i] *= learner.gamma
        learner.discMs[i] *= learner.gamma
    end
    learner.discNs[a] += 1  
    learner.discMs[a] += r
    
    return
end

function Base.show(io::IO, learner::DiscLearner)
    @printf(io, "DiscLearner(%f, %f, %f)", learner.μ₀, learner.σ₀, learner.gamma)
end
