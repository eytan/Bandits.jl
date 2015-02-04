using Bandits, Distributions

# Number of trials in a game
T = 5_000

# Number of simulated games per algorithm/bandit pair
# Set this below 10,000 to get results very quickly
S = 1_000_000

algorithms = [
    RandomChoice(MLELearner(0.5, 0.25)),
    # EpsilonGreedy(MLELearner(0.5, 0.25), 0.01),
    EpsilonGreedy(MLELearner(0.5, 0.25), 0.1),
    AnnealingEpsilonGreedy(MLELearner(0.5, 0.25)),
    DecreasingEpsilonGreedy(MLELearner(0.5, 1.0), 0.1, 0.1),
    Softmax(MLELearner(0.5, 0.25), 0.01),
    # Softmax(MLELearner(0.5, 0.25), 0.1),
    AnnealingSoftmax(MLELearner(0.5, 0.25), 1.0),
    UCB1(MLELearner(0.5, 0.25)),
    UCB1Tuned(MLELearner(0.5, 0.25)),
    UCB2(MLELearner(0.5, 0.25), 0.1),
    UCBV(MLELearner(0.5, 1.0), 1.0, 1.0, 1.2),
    # TODO: Get these to work
    #       * Put learners in them
    #       * Don't require learners
    #Exp3(0.01),
    #Exp3(0.1),
    ThompsonSampling(BetaLearner(0.5, 0.5)),
    #Hedge(0.1),
    MOSS(MLELearner(0.5, 0.25)),
    # ReinforcementComparison(0.1, 0.1, 1.0),
    # Pursuit(MLELearner(0.5, 1.0), 0.1),
]

bandits = [
    StochasticBandit(
        [Bernoulli(0.1), Bernoulli(0.2), Bernoulli(0.3)]
    ),
]

simulate(algorithms, bandits, T, S)
