module TestDataQueue
    using Bandits, Distributions
    using Base.Test

    queue = Bandits.DataQueue(
        Array(StochasticContext, 0),
        Array(Int, 0),
        Array(Float64, 0),
    )
    @test isa(queue, Bandits.DataQueue)
end
