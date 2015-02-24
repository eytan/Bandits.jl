@doc """
An EmpiricalBandit object represents a stochastic bandit that is derived from
empirical reward distributions for each arm. You pass in a vector of vectors,
where each vector is the set of all observed rewards from that arm.

Because of stationarity, we can cache the maximum reward associated with
any arm. Based on this maximum reward, we can also cache the pseudo-regret
associated with choosing any particular arm. The complete object contains
all of this cached information.
""" ->
immutable EmpiricalBandit <: ProbabilisticBandit
    arm_rewards::Vector{Vector{Float64}}
    means::Vector{Float64}
    pseudo_regrets::Vector{Float64}
    max_reward::Float64
    best_arm::Int64

# Pick an arm, then draw from that arm's observed data
    function EmpiricalBandit(arm_rewards::Vector{Vector{Float64}})
        K = length(arm_rewards)
        means = Array(Float64, K)
        pseudo_regrets = Array(Float64, K)
        max_reward = -Inf
        for a in 1:K
            m = mean(arm_rewards[a])
            means[a] = m
            max_reward = max(max_reward, m)
        end
        for a in 1:K
            pseudo_regrets[a] = max_reward - means[a]
        end
        best_arm = indmin(pseudo_regrets)
        return new(arm_rewards, means, pseudo_regrets, max_reward, best_arm)
    end
end

@doc """
Draw a reward from an EmpiricalBandit given the current context and chosen
action.
""" ->
function draw(bandit::EmpiricalBandit, context::Context, a::Integer)
    return StatsBase.sample(bandit.arm_rewards[a])
end

@doc """
Return the regret associated with choosing a given action in the current
context.
""" ->
function regret(bandit::EmpiricalBandit, context::Context, a::Integer)
    return bandit.pseudo_regrets[a]
end

@doc """
Return the number of arms in the bandit.
""" ->
function count_arms(bandit::EmpiricalBandit, context::Context)
    return length(bandit.arm_rewards)
end

@doc """
Return the index of the best arm. This is inherently ambiguous if there
are multiple arms with the highest expected value.
""" ->
function best_arm(bandit::EmpiricalBandit, context::Context)
    return bandit.best_arm
end

means(bandit::EmpiricalBandit) = bandit.means
