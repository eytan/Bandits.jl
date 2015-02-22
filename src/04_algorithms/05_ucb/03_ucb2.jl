immutable UCB2{L <: Learner} <: Algorithm
    learner::L
    α::Float64
    r::Vector{Int64}
    current_arm::Vector{Int64}
    plays_left::Vector{Int64}
    num_plays::Vector{Integer}
end

function UCB2(learner::Learner, α::Real)
    return UCB2(
        learner,
        float64(α),
        Array(Int64, 0),
        [0],
        [0],
        Array(Integer, 0)
    )
end

τ_func(α::Real, r::Integer) = iceil((1 + α)^r)

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
    resize!(algorithm.num_plays, K)
    fill!(algorithm.r, 0)
    fill!(algorithm.num_plays, 0)
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
        if algorithm.num_plays[a] == 0
            algorithm.num_plays[a] += 1
            return a
        end
    end

    # Use preselected arm
    if algorithm.plays_left[1] > 0
        algorithm.plays_left[1] -= 1
        algorithm.num_plays[algorithm.current_arm[1]] += 1
        return algorithm.current_arm[1]
    end

    # Pick a random arm with the maximum score
    max_score, max_arms, num_max_arms = -Inf, Array(Integer, context.K), 1
    for a in 1:context.K
        score = μs[a] + a_func(α, context.t, algorithm.r[a])
        if score > max_score
            max_score = score
            max_arms[1] = a
            num_max_arms = 1
        elseif max_score == score
            num_max_arms += 1
            max_arms[num_max_arms] = a
        end
    end
    chosen_a = max_arms[rand(1:num_max_arms)]

    # Precommit to playing arm n times.
    # We use up the first play immediately.
    algorithm.current_arm[1] = chosen_a
    algorithm.plays_left[1] = max(
        0,
        τ_func(α, algorithm.r[chosen_a] + 1) -
        τ_func(α, algorithm.r[chosen_a]) - 1
    )
    algorithm.r[chosen_a] += 1
    algorithm.num_plays[chosen_a] += 1

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
