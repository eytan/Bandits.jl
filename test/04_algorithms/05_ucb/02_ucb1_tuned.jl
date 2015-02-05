module TestUCB1Tuned
    using Bandits, Distributions
    using Base.Test

    algorithm = UCB1Tuned(MLELearner(0.0, 1.0))
    @test isa(algorithm, Algorithm)
    @test isa(algorithm.learner, MLELearner)

    bandit = StochasticBandit(
        [Bernoulli(0.1), Bernoulli(0.2)]
    )

    K = count_arms(bandit, MinimalContext(1))
    initialize!(algorithm, K)

    for t in 1:1_000_000
        context = StochasticContext(t, K)
        a = choose_arm(algorithm, context)
        learn!(algorithm, context, a, draw(bandit, context, a))
    end

    for a in 1:K
        @test abs(means(algorithm.learner)[a] - mean(bandit.arms[a])) < 0.1
        @test abs(stds(algorithm.learner)[a] - std(bandit.arms[a])) < 0.1
    end

    ns = counts(algorithm.learner)
    @test ns[1] <= ns[2]
end
