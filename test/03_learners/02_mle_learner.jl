module TestMLELearner
    using Bandits, Distributions
    using Base.Test

    learner = MLELearner(0.0, 1.0)

    bandit = StochasticBandit(
        [
            Bernoulli(0.1),
            Bernoulli(0.2),
        ]
    )

    K = count_arms(bandit, MinimalContext(1))
    initialize!(learner, K)

    @test counts(learner) == Int[0, 0]
    @test means(learner) == Float64[0.0, 0.0]
    @test stds(learner) == Float64[1.0, 1.0]

    for t in 1:1_000_000
        context = StochasticContext(K, t)
        learn!(learner, context, 1, draw(bandit, context, 1))
        learn!(learner, context, 2, draw(bandit, context, 2))
    end

    for a in 1:K
        @test abs(means(learner)[a] - mean(bandit.arms[a])) < 0.1
        @test abs(stds(learner)[a] - std(bandit.arms[a])) < 0.1
    end
end
