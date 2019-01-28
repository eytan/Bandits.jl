"""
A EBBetaLearner is an Empirical Bayes version of BetaLearner
prior_fx_mean is the prior mean of effect sizes
prior_fx_precision is how much dispersion we have around the effect size
 (larger values being more uniform priors)
"""
struct EBBetaLearner <: Learner
    beta_learner::BetaLearner
    prior_fx_mean::Float64
    prior_fx_precision::Float64
    posterior_αs::Vector{Float64}
    posterior_βs::Vector{Float64}
    posterior_μs::Vector{Float64}
    posterior_σs::Vector{Float64}
end

"""
Constructs a EBBetaLearner with R replicates and some initial mean and standard deviation
"""
function EBBetaLearner(prior_fx_mean, prior_fx_precision)
    return EBBetaLearner(
        BetaLearner(),
        prior_fx_mean,
        prior_fx_precision,
        Array{Float64}(undef, 0),
        Array{Float64}(undef, 0),
        Array{Float64}(undef, 0),
        Array{Float64}(undef, 0),
    )
end

"""
Return the total number of trials.
"""
counts(learner::EBBetaLearner) = counts(learner.beta_learner)

## @TODO: update this to give posterior mean
"""
Return the posterior means for each arm.
"""
means(learner::EBBetaLearner) = learner.posterior_μs


## @TODO: update this to give posterior std
"""
Return the posterior standard deviations for each arm.
"""
stds(learner::EBBetaLearner) = learner.posterior_σs

"""
Reset empirical bayes learner.
"""
function initialize!(learner::EBBetaLearner, K::Integer)
    beta_learner = learner.beta_learner
    initialize!(beta_learner, K)

    prior_fx_alpha = learner.prior_fx_mean/learner.prior_fx_precision
    prior_fx_beta = (1 - learner.prior_fx_mean)/learner.prior_fx_precision
    prior_fx_dist = Beta(prior_fx_alpha, prior_fx_beta)

    resize!(learner.posterior_αs, K)
    resize!(learner.posterior_βs, K)
    resize!(learner.posterior_μs, K)
    resize!(learner.posterior_σs, K)

    # Initial effect sizes to follow a weak prior.
    means = rand(prior_fx_dist, K)
    for a in 1:K
        # using the mean itself should be fairly uninformative, since mean < 1
        beta_learner.αs[a] = means[a]
        beta_learner.βs[a] = 1.0 - means[a]
        learner.posterior_αs[a] = beta_learner.αs[a] + prior_fx_alpha
        learner.posterior_βs[a] = beta_learner.βs[a] + prior_fx_beta
        posterior_dist = Beta(learner.posterior_αs[a], learner.posterior_βs[a])
        learner.posterior_μs[a] = mean(posterior_dist)
        learner.posterior_σs[a] = std(posterior_dist)
    end

    return
end

"""
Learn about arm a on trial t from reward r.
"""
function learn!(learner::EBBetaLearner, context::Context, a::Integer, r::Real)
    learn!(learner.beta_learner, context, a, r)
    empirical_fx_dist = fit(Beta, learner.beta_learner.μs)
    fx_alpha, fx_beta = params(empirical_fx_dist)
    for a in 1:length(learner.posterior_αs)
        learner.posterior_αs[a] = learner.beta_learner.αs[a] + fx_alpha
        learner.posterior_βs[a] = learner.beta_learner.βs[a] + fx_beta
        posterior_dist = Beta(learner.posterior_αs[a], learner.posterior_βs[a])
        learner.posterior_μs[a] = mean(posterior_dist)
        learner.posterior_σs[a] = std(posterior_dist)
    end
    return
end


"""
Draw a sample from the empirical bayes posterior.
"""
function Base.rand(learner::EBBetaLearner, a::Integer)
    rand(Beta(learner.posterior_αs[a], learner.posterior_βs[a]))
end

function Base.show(io::IO, learner::EBBetaLearner)
    @printf(
        io,
        "EBBetaLearner(%f, %f)",
        learner.prior_fx_mean,
        learner.prior_fx_precision,
    )
end
