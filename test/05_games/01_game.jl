module TestGame
    using Bandits, Distributions
    using Base.Test

    @test isa(Game, DataType)
    @test Game.abstract
end
