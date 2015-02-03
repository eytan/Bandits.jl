type Hedge <: Algorithm
    η::Float64
    sums::Vector{Float64}
    wsums::Vector{Float64}
    ps::Vector{Float64}
end

Hedge(η::Real) = Hedge(
    float64(η),
    Array(Float64, 0),
    Array(Float64, 0),
    Array(Float64, 0),
)

function initialize!(algorithm::Hedge, K::Integer)
    resize!(algorithm.sums, K)
    resize!(algorithm.wsums, K)
    resize!(algorithm.ps, K)
    fill!(algorithm.sums, 0.0)
    fill!(algorithm.wsums, 0.0)
    fill!(algorithm.ps, 1 / K)
    return
end

function choose_arm(algorithm::Hedge, context::Context)
    rand(Categorical(algorithm.ps))
end

function learn!(algorithm::Hedge, context::Context, a::Integer, r::Real)
    algorithm.sums[a] += r
    for i in 1:context.K
        algorithm.wsums[i] = algorithm.η * algorithm.sums[i]
    end
    softmax!(algorithm.ps, algorithm.wsums)
    return
end
