immutable UCB1{L <: Learner} <: Algorithm
    learner::L
    num_plays::Vector{Integer}
end

UCB1{L <: Learner}(learner::L) = UCB1{L}(learner, Array(Integer, 0))

function initialize!(algorithm::UCB1, K::Integer)
    initialize!(algorithm.learner, K)
    resize!(algorithm.num_plays, K)
    fill!(algorithm.num_plays, 0)
    return
end

function choose_arm(algorithm::UCB1, context::Context)
    μs = means(algorithm.learner)
    ns = counts(algorithm.learner)

    for a in 1:context.K
        if algorithm.num_plays[a] == 0
            algorithm.num_plays[a] += 1
            return a
        end
    end

    # Pick a random arm with the maximum score
    max_score, max_arms, num_max_arms = -Inf, Array(Integer, context.K), 1
    for a in 1:context.K
        bonus = sqrt(2 * log(context.t) / ns[a])
        score = μs[a] + bonus
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

function Base.show(io::IO, algorithm::UCB1)
    @printf(
        io,
        "UCB1(%s)",
        string(algorithm.learner),
    )
end
