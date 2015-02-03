module TestLearner
    using Bandits, Distributions
    using Base.Test

    @test isa(Learner, DataType)
    @test Learner.abstract
end
