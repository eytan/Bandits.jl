module TestReinforcementComparison
    using Bandits, Distributions
    using Base.Test

    algorithm = ReinforcementComparison(0.5, 0.5, 0.5)
    @test isa(algorithm, Algorithm)

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
end
