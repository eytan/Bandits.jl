# Two differences from documented algorithm:
# (1) Play all arms twice, not once
# (2) Use unbiased sample variance, not biased sample variance
immutable UCB1Tuned{L <: Learner} <: Algorithm
    learner::L
end

function initialize!(algorithm::UCB1Tuned, K::Integer)
    initialize!(algorithm.learner, K)
    return
end

function choose_arm(algorithm::UCB1Tuned, context::Context)
    μs = means(algorithm.learner)
    σs = stds(algorithm.learner)
    ns = counts(algorithm.learner)

    # Play all machines twice to get proper variance estimates
    for a in 1:context.K
        if ns[a] < 2
            return a
        end
    end

    max_score, chosen_a = -Inf, 0
    for a in 1:context.K
        v = σs[a]^2 + sqrt(2 * log(context.t) / ns[a])
        bonus = sqrt(min(1 / 4, v) * log(context.t) / ns[a])
        score = μs[a] + bonus
        if score > max_score
            max_score = score
            chosen_a = a
        end
    end

    return chosen_a
end

function Base.show(io::IO, algorithm::UCB1Tuned)
    @printf(
        io,
        "UCB1Tuned(%s)",
        string(algorithm.learner),
    )
end
