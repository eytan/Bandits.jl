module TestPlayGame
    using Bandits, Distributions
    using Base.Test

    T = 50

    game = StochasticGame(
        UCB1(MLELearner(0.5, 0.25)),
        StochasticBandit(
            [
                Bernoulli(0.1),
                Bernoulli(0.2),
                Bernoulli(0.3),
            ]
        ),
        T,
    )
    @test isa(game, StochasticGame)

    rewards = Array(Float64, T)
    regrets = Array(Float64, T)
    chosen_arms = Array(Int, T)
    chose_best = BitArray(T)
    knows_best = BitArray(T)

    play_game!(game, rewards, regrets, chosen_arms, chose_best, knows_best)

    for t in 1:T
        @test rewards[t] == 0 || rewards[t] == 1
        @test isapprox(regrets[t], 0.0) || isapprox(regrets[t], 0.1) || isapprox(regrets[t], 0.2)
        @test 1 <= chosen_arms[t] <= 3
        @test chose_best[t] || !chose_best[t]
        @test knows_best[t] || !knows_best[t]
    end
end
