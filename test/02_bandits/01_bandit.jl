module TestBandit
    using Bandits
    using Base.Test

    @test isa(Bandit, DataType)
    @test Bandit.abstract
end
