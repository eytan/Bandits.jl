immutable UCB1{L <: Learner} <: Algorithm
    learner::L
end

function initialize!(algorithm::UCB1, K::Integer)
    initialize!(algorithm.learner, K)
    return
end

function choose_arm(algorithm::UCB1, context::Context)
    μs = means(algorithm.learner)
    ns = counts(algorithm.learner)

    for a in 1:context.K
        if ns[a] == 0
            return a
        end
    end

    max_score, chosen_a = -Inf, 0
    for a in 1:context.K
        bonus = sqrt(2 * log(context.t) / ns[a])
        score = μs[a] + bonus
        if score > max_score
            max_score = score
            chosen_a = a
        end
    end

    return chosen_a
end
