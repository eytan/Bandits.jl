"""
A NonStationaryGaussianDistribution maintains a sine-based p(t),
which determines the probability of reward = 1 at time t.
"""
struct NonStationaryGaussianDistribution <: NonStationaryMultivariateDistribution

    mean::Vector{Float64}
    cov::Matrix{Float64}

    function NonStationaryGaussianDistribution(mean::Vector{Float64}, cov::Matrix{Float64})

        return new(
            mean,
            cov,
        )
    end
end


"""
Return the mean of the distribution at time t (or t=0 otherwise).
"""
function Statistics.mean(d::NonStationaryGaussianDistribution, t=0.0::Float64)
    return d.mean # + process(t)
end

"""
Sample from the distribution at time t (or t=0 otherwise).
"""
function Random.rand(d::NonStationaryGaussianDistribution, t=0.0::Float64, size=1::Int64)
    mean_val = d.mean # + process(t)
    cov_val = d.cov # + process(t)
    return rand(MvNormal(mean_val, cov_val), size)
end


