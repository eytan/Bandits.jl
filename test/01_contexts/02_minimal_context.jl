module TestMinimalContext
    using Bandits
    using Base.Test

    @test isa(MinimalContext, DataType)
    @test !MinimalContext.abstract

    ctxt = MinimalContext(1)
    @test ctxt.t == 1
end
