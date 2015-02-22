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
        1,
    )
    @test isa(game, StochasticGame)

    statistics = CoreSingleGameStatistics(T)

    play_game!(game, statistics)

    for t in 1:T
        @test statistics.reward[t] == 0 || statistics.reward[t] == 1
        @test isapprox(statistics.instantaneous_regret[t], 0.0) ||
            isapprox(statistics.instantaneous_regret[t], 0.1) ||
            isapprox(statistics.instantaneous_regret[t], 0.2)
        @test 1 <= statistics.chosen_arm[t] <= 3
        @test statistics.chose_best[t] || !statistics.chose_best[t]
        @test statistics.knows_best[t] || !statistics.knows_best[t]
    end
end
