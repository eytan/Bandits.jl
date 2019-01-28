# """
# A MovingBandit object represents an "stochastic bandit" with 
# non-stationary reward distributions, that is, univariate distributions
# over the non-negative reals that change over time.
#
# Due to non-stationarity, the best arm depends on time.
# Initially, we cache the best arm and max reward for t=0.
# """
struct MovingBandit{D <: NonStationaryUnivariateDistribution} <: NonStationaryBandit
    arms::Vector{D}
    means::Vector{Float64}
    pseudo_regrets::Vector{Float64}
    max_reward::Float64
    best_arm::Int64

    function MovingBandit(arms::Vector{D}) where D
        t0 = 0.0
        K = length(arms)
        means = Array{Float64}(undef, K)
        pseudo_regrets = Array{Float64}(undef, K)
        max_reward = -Inf
        for a in 1:K
            m = mean(arms[a], t0)
            means[a] = m
            max_reward = max(max_reward, m)
        end
        for a in 1:K
            pseudo_regrets[a] = max_reward - means[a]
        end
        best_arm = indmin(pseudo_regrets)
        return new{D}(arms, means, pseudo_regrets, max_reward, best_arm)
    end
end

"""
Construct a new MovingBandit object from a vector of probability
distribution objects.
"""
function MovingBandit(arms::Vector{D}) where D <: NonStationaryUnivariateDistribution
    return MovingBandit{D}(arms)
end

"""
Return the number of arms in the bandit.
"""
function count_arms(bandit::MovingBandit, context::Context)
    return length(bandit.arms)
end

"""
Return the mean of each arm for a given context (and time).
"""
function means(bandit::MovingBandit, context::Context)
    K = count_arms(bandit, context)
    means = Array{Float64}(undef, K)
    for a in 1:K
        means[a] = mean(bandit.arms[a], context.t)
    end
    return means
end

"""
Draw a reward from a MovingBandit given the current context and chosen
action.
"""
function draw(bandit::MovingBandit, context::Context, a::Integer)
    return rand(bandit.arms[a], context.t)
end

"""
Return the regret associated with choosing a given action in the current
context and at time t.
"""
function regret(bandit::MovingBandit, context::Context, a::Integer)
    return maximum(means(bandit, context)) - mean(bandit.arms[a], context.t)
end

"""
Return the index of the best arm at time t. This is inherently ambiguous if there
are multiple arms with the highest expected value.
"""
function best_arm(bandit::MovingBandit, context::Context)
    return indmax(means(bandit, context))
end
