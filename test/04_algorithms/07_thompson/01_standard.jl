module TestThompsonSampling
    using Bandits, Distributions
    using Base.Test

    function test_thompson_sampling_with_learner(learner)
        algorithm = ThompsonSampling(learner)
        @test isa(algorithm, Algorithm)
        #@test isa(algorithm.learner, BetaLearner)

        bandit = StochasticBandit(
            [Bernoulli(0.1), Bernoulli(0.2)]
        )

        K = count_arms(bandit, MinimalContext(1))
        initialize!(algorithm, K)

        for t in 1:10_000
            context = StochasticContext(t, K)
            a = choose_arm(algorithm, context)
            learn!(algorithm, context, a, draw(bandit, context, a))
        end

        for a in 1:K
            if counts(algorithm.learner)[a] > 0
                se = std(bandit.arms[a])/sqrt(counts(algorithm.learner)[a])
                ## make sure difference in means falls within 99% interval
                @test abs(means(algorithm.learner)[a] - mean(bandit.arms[a])) < 2.575*se
            end
        end
        ns = counts(algorithm.learner)
        @test ns[1] <= ns[2]
    end

    test_thompson_sampling_with_learner(BetaLearner())
    test_thompson_sampling_with_learner(BootstrapMLELearner(100, 0.5, 0.25))
end
