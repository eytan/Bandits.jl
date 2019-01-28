# Two differences from documented algorithm:
# (1) Play all arms twice, not once
# (2) Use unbiased sample variance, not biased sample variance

struct UCBV{L <: Learner} <: Algorithm
    learner::L
    b::Float64 # Upper bound on rewards
    c::Float64
    ζ::Float64
end

function UCBV(
    learner::Learner,
    b::Real = 1.0,
    c::Real = 1.0,
    ζ::Real = 1.2,
)
    return UCBV(learner, Float64(b), Float64(c), Float64(ζ))
end

function initialize!(algorithm::UCBV, K::Integer)
    initialize!(algorithm.learner, K)
    return
end

function choose_arm(algorithm::UCBV, context::Context)
    μs = means(algorithm.learner)
    σs = stds(algorithm.learner)
    ns = counts(algorithm.learner)

    b = algorithm.b
    c = algorithm.c
    ζ = algorithm.ζ

    # Play all machines twice to get proper variance estimates
    for a in 1:context.K
        if ns[a] < 2
            return a
        end
    end

    max_score, chosen_a = -Inf, 0
    for a in 1:context.K
        bonus1 = sqrt(2 * ζ * σs[a]^2 * log(context.t) / ns[a])
        bonus2 = c * (3 * b * ζ * log(context.t) / ns[a])
        score = μs[a] + bonus1 + bonus2
        if score > max_score
            max_score = score
            chosen_a = a
        end
    end

    return chosen_a
end

function Base.show(io::IO, algorithm::UCBV)
    @printf(
        io,
        "UCBV(%f, %f, %f, %s)",
        algorithm.b,
        algorithm.c,
        algorithm.ζ,
        string(algorithm.learner),
    )
end
