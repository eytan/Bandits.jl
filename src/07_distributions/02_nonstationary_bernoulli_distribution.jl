import Base.rand
import Base.mean

@doc """
A NonStationaryBernoulliDistribution maintains a sine-based p(t),
which determines the probability of reward = 1 at time t.
""" ->
immutable NonStationaryBernoulliDistribution <: NonStationaryUnivariateDistribution

    epsilon::Float64
    frequency::Float64
    offset::Float64
    mean_value::Float64

    function NonStationaryBernoulliDistribution(epsilon::Float64, frequency::Float64, offset::Float64, mean_value::Float64)

        return new(
            epsilon,
            frequency,
            offset,
            mean_value
        )
    end
end


@doc """
Return the mean of the distribution at time t (or t=0 otherwise).
"""
function mean(d::NonStationaryBernoulliDistribution, t=0.0::Float64)
    return d.mean_value * (1 + d.epsilon * sin(d.frequency * t + d.offset))
end

@doc """
Sample one random from the distribution at time t (or t=0 otherwise).
"""
function rand(d::NonStationaryBernoulliDistribution, t=0.0::Float64, size=1::Int64)
    samples = 1*(rand(size) .< fill(mean(d, t), size))
    if size == 1
        return samples[1]
    end
    return samples
end


