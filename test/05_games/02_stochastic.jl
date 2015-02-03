module TestStochasticGame
    using Bandits, Distributions
    using Base.Test

    game = StochasticGame(
        UCB1(MLELearner(0.5, 0.25)),
        StochasticBandit(
            [
                Bernoulli(0.3),
                Bernoulli(0.2),
                Bernoulli(0.1),
            ]
        ),
        50,
    )
    @test isa(game, StochasticGame)
end
