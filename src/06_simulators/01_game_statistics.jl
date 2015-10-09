@doc """
Maintain statistics for each trial of a game.
""" ->
abstract SingleGameStatistics

@doc """
Maintain statistics for each trial of a game. This data structure represents
the minimal statistics we want to accumulate about each game:

* Per-trial reward
* Per-trial instantaneous regret
* Per-trial cumulative regret
* Per-trial: Which arm was chosen?
* Per trial: Was the optimal arm chosen?
* Per trial: Did the learner know which arm was optimal?
""" ->
immutable CoreSingleGameStatistics <: SingleGameStatistics
    T::Int
    reward::Vector{Float64}
    instantaneous_regret::Vector{Float64}
    step_size::Int
    steps::Int
    cumulative_regret::Vector{Float64}
    chosen_arm::Vector{Int}
    chose_best::BitVector
    knows_best::BitVector
    mse::Vector{Float64}
    se_best::Vector{Float64}

        return new(
            T,
            reward,
            instantaneous_regret,
            cumulative_regret,
            chosen_arm,
            chose_best,
            knows_best,
            mse,
            se_best,
        )
    end
end

@doc """
Update statistics for the current trial.
""" ->
function update!(
    statistics::CoreSingleGameStatistics,
    learner::Learner,
    bandit::Bandit,
    a_star::Integer,
    c::Context,
    a::Integer,
    b::Integer,
    r::Real,
    g::Real,
)
    else
    end
    learner_ms = means(learner)
    bandit_ms = means(bandit)
    mse = 0.0
    for a in 1:c.K
        mse += (learner_ms[a] - bandit_ms[a])^2
    end
    return
end
