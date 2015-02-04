immutable MOSS{L <: Learner} <: Algorithm
    learner::L
end

MOSS(learner::Learner) = MOSS(learner, Array(Float64, 0))

function choose_arm(algorithm::MOSS, context::Context)
    μs = means(algorithm.learner)
    ns = counts(algorithm.learner)

    for a in 1:context.K
        if ns[a] == 0
            return a
        end
    end

    max_score, chosen_a = -Inf, 0
    for a in 1:context.K
        score = μs[a] + sqrt(
            max(
                log(context.t / (context.K * ns[a])),
                0.0
            ) / ns[a]
        )
        if score > max_score
            max_score = score
            chosen_a = a
        end
    end

    return chosen_a
end
