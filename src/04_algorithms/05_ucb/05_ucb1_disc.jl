immutable UCB1Disc{L <: DiscLearner} <: Algorithm
    learner::L
end

function initialize!(algorithm::UCB1Disc, K::Integer)
    initialize!(algorithm.learner, K)
    return
end

function choose_arm(algorithm::UCB1Disc, context::Context)

    μs = means(algorithm.learner)
    ns = counts(algorithm.learner)
    total_discounted_time = sum(ns)

    for a in 1:context.K
        if ns[a] == 0
            return a
        end
    end

    max_score, chosen_a = -Inf, 0
    for a in 1:context.K
        bonus = sqrt(2 * max(1, log(total_discounted_time)) / ns[a])
        score = μs[a] + bonus
        if score > max_score
            max_score = score
            chosen_a = a
        end
    end

    return chosen_a
end

function Base.show(io::IO, algorithm::UCB1Disc)
    @printf(
        io,
        "%f-UCBDisc(%s)",
        algorithm.learner.gamma,
        string(algorithm.learner),
    )
end
