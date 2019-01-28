module TestDataQueue
    using Bandits, Distributions
    using Base.Test

    queue = Bandits.DataQueue(
        Array{StochasticContext}(undef, 0),
        Array{Int}(undef, 0),
        Array{Float64}(undef, 0),
    )
    @test isa(queue, Bandits.DataQueue)
end
