# Two differences from documented algorithm:
# (1) Play all arms twice, not once
# (2) Use unbiased sample variance, not biased sample variance

immutable UCBV{L <: Learner} <: Algorithm
    learner::L
    b::Float64 # Upper bound on rewards
    c::Float64
    ζ::Float64
    num_plays::Vector{Integer}
end

function UCBV(
    learner::Learner,
    b::Real = 1.0,
    c::Real = 1.0,
    ζ::Real = 1.2,
)
    return UCBV(learner, float64(b), float64(c), float64(ζ), Array(Integer, 0))
end

function initialize!(algorithm::UCBV, K::Integer)
    initialize!(algorithm.learner, K)
    resize!(algorithm.num_plays, K)
    fill!(algorithm.num_plays, 0)
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
        if algorithm.num_plays[a] < 2
            algorithm.num_plays[a] += 1
            return a
        end
    end

    # Pick a random arm with the maximum score
    max_score, max_arms, num_max_arms = -Inf, Array(Integer, context.K), 1
    for a in 1:context.K
        bonus1 = sqrt(2 * ζ * σs[a]^2 * log(context.t) / ns[a])
        bonus2 = c * (3 * b * ζ * log(context.t) / ns[a])
        score = μs[a] + bonus1 + bonus2
        if score > max_score
            max_score = score
            max_arms[1] = a
            num_max_arms = 1
        elseif score == max_score
            num_max_arms += 1
            max_arms[num_max_arms] = a
        end
    end
    chosen_arm = max_arms[rand(1:num_max_arms)]
    algorithm.num_plays[chosen_arm] += 1
    return chosen_arm
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
