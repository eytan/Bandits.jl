immutable MOSS{L <: Learner} <: Algorithm
    learner::L
    num_plays::Vector{Integer}
end

MOSS(learner::Learner) = MOSS(learner, Array(Integer, 0))

function initialize!(algorithm::MOSS, K::Integer)
    initialize!(algorithm.learner, K)
    resize!(algorithm.num_plays, K)
    fill!(algorithm.num_plays, 0)
end

function choose_arm(algorithm::MOSS, context::Context)
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
        score = μs[a] + sqrt(
            max(
                log(context.t / (context.K * ns[a])),
                0.0
            ) / ns[a]
        )
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

function Base.show(io::IO, algorithm::MOSS)
    @printf(
        io,
        "MOSS(%s)",
        string(algorithm.learner),
    )
end
