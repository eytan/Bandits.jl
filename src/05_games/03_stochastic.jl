@doc """
A StochasticGame type represents a Game between an Algorithm and a
StochasticBandit. This simplifies many calculations, such as the calculation of
regret.
""" ->
immutable StochasticGame{A <: Algorithm, B <: Union(StochasticBandit, EmpiricalBandit)} <: Game
    algorithm::A
    bandit::B
    T::Int
    delay::Int
    queue::DataQueue{StochasticContext}

    function StochasticGame(algorithm, bandit, T, delay)
        queue = DataQueue(
            Array(StochasticContext, 0),
            Array(Int, 0),
            Array(Float64, 0),
        )
        return new(
            algorithm,
            bandit,
            T,
            delay,
            queue,
        )
    end
end

function StochasticGame{A <: Algorithm, B <: Union(StochasticBandit, EmpiricalBandit)}(algorithm::A, bandit::B, T, delay)
    return StochasticGame{A, B}(algorithm, bandit, T, delay)
end

function delay(game::StochasticGame)
    return game.delay
end
