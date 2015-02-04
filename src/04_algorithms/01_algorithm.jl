@doc """
An Algorithm object handles the problem of selecting an arm on each trial
based on previous experiences.

All algorithm objects must contain a learner object in order to track
simulation statistics consistently across algorithms, even though some
algorithms must **not** make use of the learner when making decisions.
""" ->
abstract Algorithm

@doc """
Initialize an algorithm to its "naive" state at the start of each game.
""" ->
function initialize!(algorithm::Algorithm, K::Integer)
    initialize!(algorithm.learner, K)
    return
end

@doc """
Learn about the reward distribution of the a-th arm. Most algorithms will
delegate this method to an included learner object.
""" ->
function learn!(
    algorithm::Algorithm,
    context::Context,
    a::Integer,
    r_t::Real,
)
    learn!(algorithm.learner, context, a, r_t)
    return
end

@doc """
Choose one of K arms given the current context.
""" ->
function choose_arm(algorithm::Algorithm, context::Context)
    error("choose_arm(algorithm, context) is not implemented abstractly")
end

@doc """
Report your belief about the best arm given the current context.
""" ->
function preferred_arm(algorithm::Algorithm, context::Context)
    return preferred_arm(algorithm.learner, context::Context)
end
