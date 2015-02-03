using Bandits, Distributions

algorithms = [
    RandomChoice(MLELearner(0.5, 0.25)),
    EpsilonGreedy(MLELearner(0.5, 0.25), 0.1),
    Softmax(MLELearner(0.5, 0.25), 0.1),
    UCB1(MLELearner(0.5, 0.25)),
    ThompsonSampling(BetaLearner()),
    MOSS(MLELearner(0.5, 0.25)),
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

T = 1_000
S = 250_000

simulate(algorithms, bandits, T, S)
