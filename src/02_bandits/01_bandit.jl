@doc """
A Bandit object represents a multi-armed bandit. It is an abstract type,
which sits above many more specific types of bandits.
""" ->
abstract Bandit

abstract ProbabilisticBandit <: Bandit

abstract AdversarialBandit <: Bandit

abstract DuelingBandits <: Bandit

abstract NonStationaryBandit <: ProbabilisticBandit

abstract MarkovianBandit <: NonStationaryBandit

abstract RestlessBandits <: NonStationaryBandit

abstract ChangePointBandits <: NonStationaryBandit

abstract SleepingBandits <: NonStationaryBandit
