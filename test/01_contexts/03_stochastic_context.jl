module TestStochasticContext
    using Bandits
    using Base.Test

    @test isa(StochasticContext, DataType)
    @test !StochasticContext.abstract

    ctxt = StochasticContext(1, 2)
    @test ctxt.t == 1
    @test ctxt.K == 2
end
