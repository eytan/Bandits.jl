@doc """
A Learner type handles the problem of learning about reward distributions
given observed reward outcomes. Most algorithms depend only on a few
empirical statistics, including the mean, standard deviation and number of
observations.

But in Thompson sampling, the learner needs to learn a full posterior over the
reward distribution. In this case, the learner must also implement a rand()
method that produces a draw from the posterior of arm a.
""" ->
abstract Learner

@doc """
Return the number of observations for all arms as a Vector{Int}.
""" ->
counts(learner::Learner) = error("counts(learner) not implemented abstractly")

@doc """
Return the estimated means for all arms as a Vector{Float64}.
""" ->
means(learner::Learner) = error("means(learner) not implemented abstractly")

@doc """
Return the estimated standard deviations for all arms as a Vector{Float64}.
""" ->
stds(learner::Learner) = error("stds(learner) not implemented abstractly")

@doc """
Return a draw from the posterior distribution over the rewards for arm a.
""" ->
function Base.rand(learner::Learner, a::Integer)
    error("rand(learner, a) not implemented abstractly")
end

@doc """
Update the agent's beliefs about the reward distributions of the arms given
a reward r from arm a.
""" ->
function learn!(
    learner::Learner,
    context::Context,
    a::Integer,
    r::Real,
)
    error("learn!(learner, context, a, r) not implemented abstractly")
end

@doc """
Report your belief about the best arm in the current context.
""" ->
function preferred_arm(learner::Learner, context::Context)
    return indmax(means(learner))
end
