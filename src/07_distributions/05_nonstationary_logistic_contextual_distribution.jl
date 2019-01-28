"""
A NonStationaryLogisticContextualDistribution...
We add an intercept.
"""
struct NonStationaryLogisticContextualDistribution <: NonStationaryContextualDistribution

    contextual_dist::NonStationaryMultivariateDistribution
    beta::Vector{Float64}

    function NonStationaryLogisticContextualDistribution(contextual_dist::NonStationaryMultivariateDistribution, beta::Vector{Float64})

        return new(
            contextual_dist,
            beta,
        )
    end
end


function contextual_function(d::NonStationaryLogisticContextualDistribution, contextual_vector::DataContext, t=0.0::Float64)
    lc = d.beta[1] + dot(d.beta[2:end], contextual_vector.data)
    return 1 / (1 + exp(-lc))
end

"""
Return the mean of the distribution at time t (or t=0 otherwise)
for context X (or X=E[X] otherwise).
"""
function Statistics.mean(d::NonStationaryLogisticContextualDistribution, t=0.0::Float64, contextual_vector=DataContext(-1.0,0)::DataContext)
    if contextual_vector.t == -1.0
        mean_contextual_vector = DataContext(-1.0, 0, mean(d.contextual_dist))
        return contextual_function(d, mean_contextual_vector, t)
    end
    return contextual_function(d, contextual_vector, t)
end

"""
Sample one random from the distribution at time t (or t=0 otherwise).
"""
function Random.rand(d::NonStationaryLogisticContextualDistribution, t=0.0::Float64, size=1::Int64)
    samples = Array{Float64}(undef, size)
    contextual_vectors = rand(d.contextual_dist, t, size)
    for i=1:size
        data_context = DataContext(Float64(t), 0, vec(contextual_vectors[:,i]))
        p_c = contextual_function(d, data_context, t)
        samples[i] = rand() < p_c ? 1 : 0
    end
    if size == 1
        return samples[1]
    end
    return samples
end
