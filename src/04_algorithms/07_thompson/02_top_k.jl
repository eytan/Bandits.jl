struct TopKThompsonSampling{L <: Learner} <: Algorithm
    learner::L
    top_k::Int64
end

function choose_arm(algorithm::TopKThompsonSampling, context::Context)
    scores = [rand(algorithm.learner, a) for a in 1:context.K]
    k_best = sortperm(scores, rev=true)[1:algorithm.top_k]
    return k_best[rand(1:algorithm.top_k)]
end

function Base.show(io::IO, algorithm::TopKThompsonSampling)
    @printf(
        io,
        "TopKThompsonSampling(%s, %s)",
        string(algorithm.learner),
        string(algorithm.top_k)
    )
end
