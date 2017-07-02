__precompile__(false)

module Bandits
    using Distributions
    using StatsFuns
    # using HypothesisTests

    # Contexts
    export Context, MinimalContext, StochasticContext, DataContext
    include(joinpath("01_contexts", "01_context.jl"))
    include(joinpath("01_contexts", "02_minimal_context.jl"))
    include(joinpath("01_contexts", "03_stochastic_context.jl"))
    include(joinpath("01_contexts", "04_data_context.jl"))

    # Distributions
    export NonStationaryUnivariateDistribution, NonStationaryBernoulliDistribution
    export NonStationaryMultivariateDistribution, NonStationaryContextualDistribution
    export NonStationaryLogisticContextualDistribution, NonStationaryGaussianDistribution
    export NonStationary1DGaussianProcessDistribution
    include(joinpath("07_distributions", "01_nonstationary_univariate_distribution.jl"))
    include(joinpath("07_distributions", "02_nonstationary_bernoulli_distribution.jl"))
    include(joinpath("07_distributions", "03_nonstationary_multivariate_distribution.jl"))
    include(joinpath("07_distributions", "04_nonstationary_contextual_distribution.jl"))
    include(joinpath("07_distributions", "05_nonstationary_logistic_contextual_distribution.jl"))
    include(joinpath("07_distributions", "06_nonstationary_gaussian_distribution.jl"))
    include(joinpath("07_distributions", "07_nonstationary_1dgaussianprocess_distribution.jl"))

    # Bandit
    export Bandit, StochasticBandit, ContextualBandit, MovingBandit
    export draw, regret, count_arms, best_arm
    include(joinpath("02_bandits", "01_bandit.jl"))
    include(joinpath("02_bandits", "02_stochastic_bandit.jl"))
    include(joinpath("02_bandits", "03_contextual_bandit.jl"))
    include(joinpath("02_bandits", "04_moving_bandit.jl"))

    # Learners
    export Learner, MLELearner, BetaLearner, BootstrapLearner,
        BootstrapMLELearner, EBBetaLearner, DiscLearner, JamesSteinLearner
    export initialize!, counts, means, stds, learn!, preferred_arm
    include(joinpath("03_learners", "01_learner.jl"))
    include(joinpath("03_learners", "02_mle_learner.jl"))
    include(joinpath("03_learners", "03_beta_learner.jl"))
    include(joinpath("03_learners", "04_bootstrap_learner.jl"))
    include(joinpath("03_learners", "05_eb_beta_learner.jl"))
    include(joinpath("03_learners", "05_disc_learner.jl"))
    include(joinpath("03_learners", "06_james_stein_learner.jl"))

    # Algorithms
    export
        Algorithm,
        RandomChoice,
        EpsilonGreedy,
        AnnealingEpsilonGreedy,
        DecreasingEpsilonGreedy,
        Softmax,
        AnnealingSoftmax,
        UCB1,
        UCB1Tuned,
        UCB2,
        UCBV,
        UCB1Disc,
        Exp3,
        RExp3,
        ThompsonSampling,
        TopKThompsonSampling,
        Hedge,
        MOSS,
        ReinforcementComparison,
        Pursuit,
        SignificantlyWorseRejection
    export choose_arm
    include(joinpath("04_algorithms", "01_algorithm.jl"))
    include(joinpath("04_algorithms", "02_baseline", "01_random_choice.jl"))
    include(joinpath("04_algorithms", "03_e-greedy", "01_standard.jl"))
    include(joinpath("04_algorithms", "03_e-greedy", "02_annealing.jl"))
    include(joinpath("04_algorithms", "03_e-greedy", "03_decreasing.jl"))
    include(joinpath("04_algorithms", "04_softmax", "01_standard.jl"))
    include(joinpath("04_algorithms", "04_softmax", "02_annealing.jl"))
    include(joinpath("04_algorithms", "05_ucb", "01_ucb1.jl"))
    include(joinpath("04_algorithms", "05_ucb", "02_ucb1_tuned.jl"))
    include(joinpath("04_algorithms", "05_ucb", "03_ucb2.jl"))
    include(joinpath("04_algorithms", "05_ucb", "04_ucb_v.jl"))
    include(joinpath("04_algorithms", "05_ucb", "05_ucb1_disc.jl"))
    include(joinpath("04_algorithms", "06_exp", "01_exp3.jl"))
    include(joinpath("04_algorithms", "06_exp", "02_rexp3.jl"))
    include(joinpath("04_algorithms", "07_thompson", "01_standard.jl"))
    include(joinpath("04_algorithms", "07_thompson", "02_top_k.jl"))
    include(joinpath("04_algorithms", "08_hedge", "01_standard.jl"))
    include(joinpath("04_algorithms", "09_moss", "01_standard.jl"))
    include(joinpath("04_algorithms", "10_rl", "01_comparison.jl"))
    include(joinpath("04_algorithms", "10_rl", "02_pursuit.jl"))
    # include(joinpath("04_algorithms", "11_optimal_arm", "02_significantly_worse_rejection.jl"))

    # Games
    export Game, StochasticGame
    include(joinpath("05_games", "01_game.jl"))
    include(joinpath("05_games", "02_data_queue.jl"))
    include(joinpath("05_games", "03_stochastic.jl"))

    # Simulators
    export
        SingleGameStatistics,
        CoreSingleGameStatistics,
        AverageGameStatistics,
        CoreAverageGameStatistics
    export play_game!, play_games!, simulate
    include(joinpath("06_simulators", "01_game_statistics.jl"))
    include(joinpath("06_simulators", "02_average_game_statistics.jl"))
    include(joinpath("06_simulators", "03_play_game.jl"))
    include(joinpath("06_simulators", "04_play_games.jl"))
    include(joinpath("06_simulators", "05_simulate.jl"))
end
