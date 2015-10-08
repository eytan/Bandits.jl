immutable UCB1{L <: Learner} <: Algorithm
    learner::L
    policy::Vector{Float64}
end

function initialize!(algorithm::UCB1, K::Integer)
    initialize!(algorithm.learner, K)
    return
end

@doc """
Update policy based on empirical means and temperature.
""" ->
function update_policy!(algorithm::UCB1, context::Context)
    μs = means(algorithm.learner)
    ns = counts(algorithm.learner)

    for a in 1:context.K
        if ns[a] == 0
            for i in 1:K
                if a == i
                    algorithm.policy[i] = 1.0
                else
                    algorithm.policy[i] = 0.0
                end
            end
            return
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

    for a in 1:context.K
        if chosen_a == a
            algorithm.policy[a] = 1.0
        else
            algorithm.policy[a] = 0.0
        end
    end

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

function Base.show(io::IO, algorithm::UCB1)
    @printf(
        io,
        "UCB1(%s)",
        string(algorithm.learner),
    )
end
