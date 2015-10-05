using Bandits, Distributions

# Number of trials in a game
T = 2_000_000

# Number of simulated games per algorithm/bandit pair
# Set this below 10,000 to get results very quickly
S = 1_000

learner = MLELearner(0.5, 0.25)

algorithms = [
    RandomChoice(learner),
    #EpsilonGreedy(learner, 0.01),
    #EpsilonGreedy(learner, 0.1),
    # AnnealingEpsilonGreedy(learner),
    # DecreasingEpsilonGreedy(learner, 0.1, 0.1),
    # Softmax(learner, 0.01),
    #Softmax(learner, 0.1),
    # AnnealingSoftmax(learner, 1.0),
    #UCB1(learner),
    UCB1Tuned(learner),
    # UCB2(learner, 0.1),
    # UCBV(learner, 1.0, 1.0, 1.2),
    # Exp3(learner, 0.01),
    # Exp3(learner, 0.1),
    ThompsonSampling(BetaLearner(0.5, 0.5)),
    TopKThompsonSampling(BetaLearner(0.5, 0.5), 2),
    #TopKThompsonSampling(BetaLearner(0.5, 0.5), 3)
    # Hedge(learner, 0.1),
    # MOSS(learner),
    # ReinforcementComparison(learner, 0.1, 0.1, 1.0),
    # Pursuit(learner, 0.1),
]

bandits = [
    StochasticBandit([Bernoulli(0.15), Bernoulli(0.1), Bernoulli(0.2), Bernoulli(0.35), Bernoulli(0.3)]),
]

bandits = [StochasticBandit([Bernoulli(p) for p in [0.000556, 0.000558, 0.000594, 0.00063, 0.000635, 0.000642, 0.000652, 0.000661, 0.000674, 0.000677, 0.000677, 0.000723, 0.000724, 0.000744, 0.000746, 0.000751, 0.000752, 0.000759, 0.00076, 0.000764, 0.000771, 0.000772, 0.000779, 0.000779, 0.000798, 0.000806, 0.000819, 0.00083, 0.000846, 0.000864, 0.000887, 0.000905, 0.000939, 0.000946, 0.000948, 0.000966, 0.000968, 0.00097, 0.000978, 0.000985, 0.001033, 0.001041, 0.001047, 0.001132, 0.001144, 0.001152, 0.001175, 0.001228]]),]
#bandits = [StochasticBandit([Bernoulli(p) for p in [0.0173564753004005,0.02,0.0276338514680484,0.0226876090750436,0.0371681415929204,0.0219981668194317,0.0304709141274238,0.0188857412653447]]),]
#bandits = [StochasticBandit([Bernoulli(p) for p in [0.02589,0.02779,0.03235,0.03392,0.03485,0.03512,0.0377,0.04041]]),]
filename = join(["demo-", Dates.format(now(), "yyyy-mm-dd-HH-MM"),".tsv"])
io = open(filename, "w")
simulate(algorithms, bandits, T, S, [125_000, 250_000,500_000], io)
close(io)
