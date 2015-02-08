using HypothesisTests
#### SignificantlyWorseRejection algorithm

# Explores all arms round robin, and drops arms whose upper CI
# is lower than the lower CI of all other arms.
    

# NOTE: there may be an issue with false discoveries since we are
# continuously checking for statistically significant differences.
# An improved version may do some FDR sort of thing.
# One interesting idea is that this might jive well with the
# batch processing we are going to do anyways.
type SignificantlyWorseRejection{L <: Learner} <: Algorithm
    learner::L
    active_arms::Vector{Int}  # IDs of arms that haven't been eliminated
    num_active_arms::Int
    current_arm_index::Int    # Counter for implementing round-robin sampling
                              # of arms
    # TODO: add user configurable sig. level.
end

function SignificantlyWorseRejection(learner::Learner)
    SignificantlyWorseRejection(learner, Array(Int, 0), 0, 1)
end

function initialize!(algorithm::SignificantlyWorseRejection, K::Integer)
    initialize!(algorithm.learner, K)
    algorithm.active_arms = 1:K
    algorithm.num_active_arms = K
    return
end

@doc """
Learn about the reward distribution of the a-th arm. Most algorithms will
delegate this method to an included learner object.
""" ->
function learn!(
    algorithm::SignificantlyWorseRejection,
    context::Context,
    a::Integer,
    r_t::Real,
)
    learn!(algorithm.learner, context, a, r_t)

    # Drop arms that are significantly worse
    if algorithm.num_active_arms == 1
        return  # nothing to do
    end
    

    # TODO: replace all CI computations with the bootstrap

    # compute upper and lower bounds of active arms, and identify
    # the min arm, with the lowest upper bound, and
    # the max arm, with the greatest lower bound.

    arm_means = means(algorithm.learner)[algorithm.active_arms] 
    arm_stds = stds(algorithm.learner)[algorithm.active_arms]
    ns = counts(algorithm.learner)[algorithm.active_arms]

    arm_upper_bounds = arm_means + 1.96*arm_stds
    arm_lower_bounds = arm_means - 1.96*arm_stds
    min_upper_bound, min_arm_index = findmin(arm_upper_bounds)
    max_lower_bound, max_arm_index = findmax(arm_lower_bounds)

    # compute CI for difference in means; see TODO above
    (upper, lower) = CI2(
        arm_means[max_arm_index], arm_means[min_arm_index],
        ns[max_arm_index], ns[min_arm_index],
        arm_stds[max_arm_index]^2, arm_stds[min_arm_index]^2
    )

    # if the min arm is significantly worse, nuke it.
    if (sign(lower) == sign(upper))
        splice!(algorithm.active_arms, min_arm_index)
        algorithm.num_active_arms -= 1
        if algorithm.current_arm_index == min_arm_index
            algorithm.current_arm_index -= 1
        end
    end
end

function choose_arm(algorithm::SignificantlyWorseRejection, context::Context)
    # if there is only one arm left, play that one
    if algorithm.num_active_arms == 1
        return algorithm.active_arms[1]
    end

    # run each arm at least twice to get proper stds for arms
    ns = counts(algorithm.learner)[algorithm.active_arms]
    for a in 1:algorithm.num_active_arms
        if ns[a] < 2
            return a
        end
    end

    # step forward and return the current active arm.
    algorithm.current_arm_index =
      (algorithm.current_arm_index % algorithm.num_active_arms) + 1
    return algorithm.active_arms[algorithm.current_arm_index]
end

# Adapted from HypothesisTests.jl:t.jl
function CI2(mx, my, nx, ny, varx, vary)
    diff = mx - my
    stderr = sqrt(varx/nx + vary/ny)
    t = diff/stderr
    df = (varx / nx + vary / ny)^2 / ((varx / nx)^2 / (nx - 1) + (vary / ny)^2 / (ny - 1))
    if df <= 0 || isnan(df)
        return (-1, 1)
    end
    ci(UnequalVarianceTTest(nx, ny, diff, df, stderr, t, 0))
end

function Base.show(io::IO, algorithm::SignificantlyWorseRejection)
    @printf(
        io,
        "SignificantlyWorseRejection(%s)",
        string(algorithm.learner),
    )
end
