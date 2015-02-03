@doc """
A StochasticGame type represents a Game between an Algorithm and a
StochasticBandit. This simplifies many calculations, such as the calculation of
regret.
""" ->
immutable StochasticGame{A <: Algorithm} <: Game
    algorithm::A
    bandit::StochasticBandit
    T::Int
end
