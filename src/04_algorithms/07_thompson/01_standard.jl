immutable ThompsonSampling{L <: Learner} <: Algorithm
    learner::L
end

function choose_arm(algorithm::ThompsonSampling, context::Context)
    max_score = -Inf
    max_arms = Array(Integer, context.K)
    num_max_arms = 1
    for a in 1:context.K
        score = rand(algorithm.learner, a)
        if score > max_score
            max_score = score
            max_arms[1] = a
            num_max_arms = 1
        elseif score == max_score
            num_max_arms += 1
            max_arms[num_max_arms] = a
        end
    end

    return max_arms[rand(1:num_max_arms)]
end

function Base.show(io::IO, algorithm::ThompsonSampling)
    @printf(
        io,
        "ThompsonSampling(%s)",
        string(algorithm.learner),
    )
end
