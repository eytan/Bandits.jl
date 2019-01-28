# """
# A StochasticBandit object represents exactly what the literature calls a
# "stochastic bandit", which is a bandit that has a finite number of arms, each
# of which has an associated stationary, univariate distribution over the
# non-negative reals.
#
# Because of stationarity, we can cache the maximum reward associated with
# any arm. Based on this maximum reward, we can also cache the pseudo-regret
# associated with choosing any particular arm. The complete object contains
# all of this cached information.
# """
struct StochasticBandit{D <: UnivariateDistribution} <: ProbabilisticBandit
    arms::Vector{D}
    means::Vector{Float64}
    pseudo_regrets::Vector{Float64}
    max_reward::Float64
    best_arm::Int64

    function StochasticBandit(arms::Vector{D}) where D
        K = length(arms)
        means = Array{Float64}(undef, K)
        pseudo_regrets = Array{Float64}(undef, K)
        max_reward = -Inf
        for a in 1:K
            m = mean(arms[a])
            means[a] = m
            max_reward = max(max_reward, m)
        end
        for a in 1:K
            pseudo_regrets[a] = max_reward - means[a]
        end
        best_arm = argmin(pseudo_regrets)
        return new{D}(arms, means, pseudo_regrets, max_reward, best_arm)
    end
end

"""
Construct a new StochasticBandit object from a vector of probability
distribution objects.
"""
function StochasticBandit(arms::Vector{D}, t::Integer) where D <: UnivariateDistribution
    return StochasticBandit{D}(arms)
end

"""
Draw a reward from a StochasticBandit given the current context and chosen
action.
"""
function draw(bandit::StochasticBandit, context::Context, a::Integer)
    return rand(bandit.arms[a])
end

"""
Return the regret associated with choosing a given action in the current
context.
"""
function regret(bandit::StochasticBandit, context::Context, a::Integer)
    return bandit.pseudo_regrets[a]
end

"""
Return the number of arms in the bandit.
"""
function count_arms(bandit::StochasticBandit, context::Context)
    return length(bandit.arms)
end

"""
Return the index of the best arm. This is inherently ambiguous if there
are multiple arms with the highest expected value.
"""
function best_arm(bandit::StochasticBandit, context::Context)
    return bandit.best_arm
end

means(bandit::StochasticBandit, context::Context) = bandit.means
