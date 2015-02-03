function simulate(
    algorithms::Vector,
    bandits::Vector,
    T::Integer,
    S::Integer,
)
    rewards = Array(Float64, T)
    regrets = Array(Float64, T)
    chosen_arms = Array(Int, T)
    chose_best = BitArray(T)
    knows_best = BitArray(T)

    avg_rewards = Array(Float64, T)
    avg_regrets = Array(Float64, T)
    avg_knows_best = Array(Float64, T)

    @printf(
        "Algorithm\tBandit\tT\tAvgReward\tAvgRegret\tAvgKnows\n",
    )

    for algorithm in algorithms
        for (i, bandit) in enumerate(bandits)
            game = StochasticGame(algorithm, bandit, T)
            for s in 1:S
                play_game!(
                    game,
                    rewards,
                    regrets,
                    chosen_arms,
                    chose_best,
                    knows_best
                )
                α = 1 / s
                for t in 1:T
                    avg_rewards[t] = (1 - α) * avg_rewards[t] + α * rewards[t]
                    avg_regrets[t] = (1 - α) * avg_regrets[t] + α * regrets[t]
                    avg_knows_best[t] = (1 - α) * avg_knows_best[t] + α * knows_best[t]
                end
            end
            for t in 1:T
                @printf(
                    "%s\t%d\t%d\t%f\t%f\t%f\n",
                    typeof(algorithm),
                    i,
                    t,
                    avg_rewards[t],
                    avg_regrets[t],
                    avg_knows_best[t],
                )
            end
        end
    end

    return
end
