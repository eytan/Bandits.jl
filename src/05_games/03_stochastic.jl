"""
A StochasticGame type represents a Game between an Algorithm and a
StochasticBandit. This simplifies many calculations, such as the calculation of
regret.
"""
struct StochasticGame{A <: Algorithm} <: Game
    algorithm::A
    bandit::Bandit #::StochasticBandit
    T::Int
    delay::Int
    queue::DataQueue{StochasticContext}

    function StochasticGame(algorithm, bandit, T, delay)
        queue = DataQueue(
            Array{StochasticContext}(undef, 0),
            Array{Int}(undef, 0),
            Array{Float64}(undef, 0),
        )
        return new{A}(
            algorithm,
            bandit,
            T,
            delay,
            queue,
        )
    end
end

function StochasticGame(algorithm::A, bandit, T, delay) where A <: Algorithm
    return StochasticGame{A}(algorithm, bandit, T, delay)
end

function delay(game::StochasticGame)
    return game.delay
end
