module TestSimulator
    using Bandits, Distributions
    using Base.Test

    algorithms = [
        UCB1(MLELearner(0.5, 0.25)),
        Softmax(MLELearner(0.5, 0.25), 0.1),
        ThompsonSampling(BetaLearner()),
    ]

    bandits = [
        StochasticBandit(
            [
                Bernoulli(0.1),
                Bernoulli(0.2),
                Bernoulli(0.3),
            ]
        ),
    ]

    T = 10
    S = 100

    simulate(algorithms, bandits, T, S)
end
