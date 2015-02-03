module TestContext
    using Bandits
    using Base.Test

    @test isa(Context, DataType)
    @test Context.abstract
end
