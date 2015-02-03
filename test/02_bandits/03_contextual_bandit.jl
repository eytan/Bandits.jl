module TestContextualBandit
    using Bandits
    using Base.Test

    @test isa(ContextualBandit, DataType)
    @test ContextualBandit.abstract
end
