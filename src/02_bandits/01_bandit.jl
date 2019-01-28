"""
A Bandit object represents a multi-armed bandit. It is an abstract type,
which sits above many more specific types of bandits.
"""
abstract type Bandit end

abstract type ProbabilisticBandit <: Bandit end

abstract type AdversarialBandit <: Bandit end

abstract type DuelingBandits <: Bandit end

abstract type NonStationaryBandit <: ProbabilisticBandit end

abstract type MarkovianBandit <: NonStationaryBandit end

abstract type RestlessBandits <: NonStationaryBandit end

abstract type ChangePointBandits <: NonStationaryBandit end

abstract type SleepingBandits <: NonStationaryBandit end
