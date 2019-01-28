"""
A NonStationaryContextualDistribution...
"""
abstract type NonStationaryContextualDistribution <: NonStationaryUnivariateDistribution end

function contextual_function(d::NonStationaryContextualDistribution, contextual_vector::DataContext, t=0.0::Float64)
    return error("contextual_function(d, contextual_vector, t) is not implemented abstractly")
end

"""
Return the mean of the distribution at time t (or t=0 otherwise)
for context X (or X=E[X] otherwise).
"""
function Statistics.mean(d::NonStationaryContextualDistribution, t=0.0::Float64, contextual_vector=DataContext(-1,0)::DataContext)
    return d.contextual_function(contextual_vector, t)
end

"""
Sample one random from the distribution at time t (or t=0 otherwise).
"""
function Random.rand(d::NonStationaryContextualDistribution, t=0.0::Float64, size=1::Int64)
    return error("rand(d, t, size) is not implemented abstractly")
end