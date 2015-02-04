immutable Pursuit{L <: Learner} <: Algorithm
    learner::L
    β::Float64
    ps::Vector{Float64}
end

function Pursuit(learner::Learner, β::Real)
    return Pursuit(learner, float64(β), Array(Float64, 0))
end

function initialize!(algorithm::Pursuit, K::Integer)
    initialize!(algorithm.learner, K)
    resize!(algorithm.ps, K)
    fill!(algorithm.ps, 1 / K)
    return
end

function choose_arm(algorithm::Pursuit, context::Context)
    if context.t > 1
        μs = means(algorithm.learner)
        a_star = indmax(μs)
        for a in 1:context.K
            if a == a_star
                algorithm.ps[a] += algorithm.β * (1 - algorithm.ps[a])
            else
                algorithm.ps[a] -= algorithm.β * algorithm.ps[a]
            end
        end
    end

    return rand(Categorical(algorithm.ps))
end

function Base.show(io::IO, algorithm::Pursuit)
    @printf(
        io,
        "Pursuit(%f, %s)",
        algorithm.β,
        string(algorithm.learner),
    )
end
