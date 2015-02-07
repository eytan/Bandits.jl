#### EstimatingBestArm algorithm

# Explores all arms round robin, and drops arms whose upper CI
# is lower than the lower CI of all other arms.
    

# NOTE: there may be an issue with false discoveries since we are
# continuously checking for statistically significant differences.
# An improved version may do some FDR sort of thing.
# One interesting idea is that this might jive well with the
# batch processing we are going to do anyways.
type EstimatingBestArm{L <: Learner} <: Algorithm
    learner::L
    active_arms::Vector{Int}  # IDs of arms that haven't been eliminated
    num_active_arms::Int
    current_arm_index::Int    # Counter for implementing round-robin sampling
                              # of arms
    # TODO: add user configurable sig. level.
end

function EstimatingBestArm(learner::Learner)
    EstimatingBestArm(learner, Array(Int, 0), 0, 1)
end

function initialize!(algorithm::EstimatingBestArm, K::Integer)
    initialize!(algorithm.learner, K)
    algorithm.active_arms = 1:K
    algorithm.num_active_arms = K
    return
end

function choose_arm(algorithm::EstimatingBestArm, context::Context)
    # if there is only one arm left, play that one
    if algorithm.num_active_arms == 1
        return algorithm.active_arms[1]
    end

    # run each arm at least twice to get proper stds for arms
    ns = counts(algorithm.learner)
    for a in 1:algorithm.num_active_arms
        if ns[a] < 2
            return a
        end
    end

    # compute upper and lower bounds of active arms, and identify
    # the arm whose upper bound is the lowest
    arm_means = means(algorithm.learner)[algorithm.active_arms] 
    arm_stds = stds(algorithm.learner)[algorithm.active_arms]
    arm_upper_bounds = arm_means + 1.96*arm_stds
    arm_lower_bounds = arm_means - 1.96*arm_stds
    min_upper_bound, min_arm_index = findmin(arm_upper_bounds)

    # determine if the min arm is significantly worse, i.e., there
    # is no arm whose lower bound is less than the min's upper bound
    min_is_significantly_worse = true
    for active_index in 1:algorithm.num_active_arms
        if min_upper_bound > arm_lower_bounds[active_index]
            min_is_significantly_worse = false
            break
        end
    end

    # if the min arm is significantly worse, nuke it.
    if min_is_significantly_worse
        splice!(algorithm.active_arms, min_arm_index)
        algorithm.num_active_arms -= 1
        # if we deleted the current arm, move a step back we don't
        # skip the arm that follows the arm we just nuked
        if min_arm_index == algorithm.current_arm_index
            algorithm.current_arm_index -= 1
        end
    end

    # step forward and return the current active arm.
    algorithm.current_arm_index =
      (algorithm.current_arm_index % algorithm.num_active_arms) + 1
    return algorithm.active_arms[algorithm.current_arm_index]
end

function Base.show(io::IO, algorithm::EstimatingBestArm)
    @printf(
        io,
        "EstimatingBestArm(%s)",
        string(algorithm.learner),
    )
end
