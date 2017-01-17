import Base.rand
import Base.mean
using GaussianProcesses

@doc """
A NonStationary1DGaussianProcessDistribution ...
""" ->
immutable NonStationary1DGaussianProcessDistribution <: NonStationaryUnivariateDistribution

    meanGP::Float64
    variance::Float64
    lengthscale::Float64
    last_time_queried::Vector{Int64}
    lengthprocess::Int64
    sampled_data::Vector{Float64}

    function NonStationary1DGaussianProcessDistribution(meanGP::Float64, variance::Float64, lengthscale::Float64, lengthprocess::Int64)

        # Select mean and covariance function
        mGP = MeanConst(meanGP)
        # Parameters are given on the log-scale
        kern = SE(log(lengthscale), log(sqrt(variance)))
        # Specify the GP prior (squared error)
        gp = GP(m=mGP,k=kern)
        x_path = collect(linspace(1, lengthprocess, lengthprocess)) #Range to sample over
        sampled_data = rand(gp, x_path)

        return new(
            meanGP,
            variance,
            lengthscale,
            [0],
            lengthprocess,
            sampled_data,
        )
    end
end


@doc """
Return the mean of the distribution at time t (or t=0 otherwise).
"""
function mean(d::NonStationary1DGaussianProcessDistribution, t=0.0::Float64)
    t_to_sample = normalize_time(d, t)
    return sigmoid(d.sampled_data[t_to_sample])
end

@doc """
Sample one random from the distribution at time t (or t=0 otherwise).
"""
function rand(d::NonStationary1DGaussianProcessDistribution, t=0.0::Float64)
    t_to_sample = normalize_time(d, t)
    if t_to_sample <= d.last_time_queried[1]
        restore_data(d)
    end
    value = d.sampled_data[t_to_sample]
    d.last_time_queried[1] = t_to_sample
    return rand() < sigmoid(value) ? 1 : 0
end

function restore_data(d::NonStationary1DGaussianProcessDistribution)
        # Select mean and covariance function
        mGP = MeanConst(d.meanGP)
        # parameters are given on the log-scale
        kern = SE(log(d.lengthscale), log(sqrt(d.variance)))
        # Specify the GP prior
        gp = GP(m=mGP,k=kern)
        x_path = collect(linspace(1, d.lengthprocess, d.lengthprocess)) #Range to sample over
        new_sampled_data = rand(gp, x_path)
        for i=1:length(d.sampled_data)
            d.sampled_data[i] = new_sampled_data[i]
        end
        d.last_time_queried[1] = 0
        return
end

function sigmoid(x::Float64)
    return 1/(1+exp(-x))
end

function normalize_time(d::NonStationary1DGaussianProcessDistribution, t=0.0::Float64)
    t_to_sample = Int(t)
    if t_to_sample < 1
        t_to_sample = 1
    elseif t_to_sample > d.lengthprocess
        t_to_sample = d.lengthprocess 
    end
    return t_to_sample
end

