struct UCB2{L <: Learner} <: Algorithm
    learner::L
    α::Float64
    r::Vector{Int64}
    current_arm::Vector{Int64}
    plays_left::Vector{Int64}
end

function UCB2(learner::Learner, α::Real)
    return UCB2(
        learner,
        Float64(α),
        Array{Int64}(undef, 0),
        [0],
        [0],
    )
end

τ_func(α::Real, r::Integer) = ceil(Integer, (1 + α)^r)

function a_func(α::Real, t::Integer, r::Integer)
    return sqrt(
        /(
            (1 + α) * log(e * t / τ_func(α, r)),
            2 * τ_func(α, r)
        )
    )
end

function initialize!(algorithm::UCB2, K::Integer)
    initialize!(algorithm.learner, K)
    resize!(algorithm.r, K)
    fill!(algorithm.r, 0)
    algorithm.current_arm[1] = 0
    algorithm.plays_left[1] = 0
    return
end

function choose_arm(algorithm::UCB2, context::Context)
    μs = means(algorithm.learner)
    ns = counts(algorithm.learner)
    α = algorithm.α

    # Sweep through all arms at the start
    for a in 1:context.K
        if ns[a] == 0
            return a
        end
    end

    # Use preselected arm
    if algorithm.plays_left[1] > 0
        algorithm.plays_left[1] -= 1
        return algorithm.current_arm[1]
    end

    # Chose current arm afresh
    max_score, chosen_a = -Inf, 0
    for a in 1:context.K
        score = μs[a] + a_func(α, context.t, algorithm.r[a])
        if score > max_score
            max_score = score
            chosen_a = a
        end
    end

    # Precommit to playing arm n times.
    # We use up the first play immediately.
    algorithm.current_arm[1] = chosen_a
    algorithm.plays_left[1] = max(
        0,
        τ_func(α, algorithm.r[chosen_a] + 1) -
        τ_func(α, algorithm.r[chosen_a]) - 1
    )
    algorithm.r[chosen_a] += 1

    return chosen_a
end

function Base.show(io::IO, algorithm::UCB2)
    @printf(
        io,
        "UCB2(%f, %s)",
        algorithm.α,
        string(algorithm.learner),
    )
end
