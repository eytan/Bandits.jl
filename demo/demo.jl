using Bandits, Distributions

# Number of trials in a game
T = 5_000

# Number of simulated games per algorithm/bandit pair
# Set this below 10,000 to get results very quickly
S = 100_000

learner = MLELearner(0.5, 0.25)

algorithms = [
    RandomChoice(learner),
    # EpsilonGreedy(learner, 0.01),
    EpsilonGreedy(learner, 0.1),
    AnnealingEpsilonGreedy(learner),
    DecreasingEpsilonGreedy(learner, 0.1, 0.1),
    Softmax(learner, 0.01),
    # Softmax(learner, 0.1),
    AnnealingSoftmax(learner, 1.0),
    UCB1(learner),
    UCB1Tuned(learner),
    UCB2(learner, 0.1),
    UCBV(learner, 1.0, 1.0, 1.2),
    Exp3(learner, 0.01),
    Exp3(learner, 0.1),
    ThompsonSampling(BetaLearner(0.5, 0.5)),
    Hedge(learner, 0.1),
    MOSS(learner),
    ReinforcementComparison(learner, 0.1, 0.1, 1.0),
    Pursuit(learner, 0.1),
]

bandits = [
    StochasticBandit([Bernoulli(0.1), Bernoulli(0.2), Bernoulli(0.3)]),
]

io = open("demo.tsv", "w")
simulate(algorithms, bandits, T, S, io)
close(io)
