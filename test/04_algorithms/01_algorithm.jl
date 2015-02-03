module TestAlgorithm
    using Bandits, Distributions
    using Base.Test

    @test isa(Algorithm, DataType)
    @test Algorithm.abstract
end
