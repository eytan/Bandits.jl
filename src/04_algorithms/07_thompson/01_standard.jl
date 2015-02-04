immutable ThompsonSampling{L <: Learner} <: Algorithm
    learner::L
end

function choose_arm(algorithm::ThompsonSampling, context::Context)
    max_score, chosen_a = -Inf, 0
    for a in 1:context.K
        score = rand(algorithm.learner, a)
        if score > max_score
            max_score = score
            chosen_a = a
        end
    end

    return chosen_a
end

function Base.show(io::IO, algorithm::ThompsonSampling)
    @printf(
        io,
        "ThompsonSampling(%s)",
        string(algorithm.learner),
    )
end
