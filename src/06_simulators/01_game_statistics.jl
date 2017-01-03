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
    step_size::Int
    steps::Int
    reward::Vector{Float64}     # instantaneous reward
    regret::Vector{Float64}
    cumulative_regret::Vector{Float64}
    cumulative_regret_s::Vector{Float64}
    chosen_arm::Vector{Int}
    chose_best::BitVector
    knows_best::BitVector
    mse::Vector{Float64}
    se_best::Vector{Float64}
    max_reward::Vector{Float64}

    function CoreSingleGameStatistics(T::Integer, step_size::Integer)
        steps = max(1, round(Int, T/step_size))
        cumulative_regret_s = [0.0]

        reward = Array(Float64, steps)
        fill!(reward, 0.0)
        regret = Array(Float64, steps)
        fill!(regret, 0.0)
        cumulative_regret = Array(Float64, steps)
        chosen_arm = Array(Int, steps)
        chose_best = BitArray(steps)
        knows_best = BitArray(steps)
        mse = Array(Float64, steps)
        se_best = Array(Float64, steps)
        max_reward = Array(Float64, steps)

        return new(
            T,
            step_size,
            steps,
            reward,
            regret,
            cumulative_regret,
            cumulative_regret_s,
            chosen_arm,
            chose_best,
            knows_best,
            max_reward,
            mse,
            se_best,
        )
    end
end

function reinitialize!(statistics::CoreSingleGameStatistics)
  fill!(statistics.regret, 0.0)
  fill!(statistics.reward, 0.0)
  fill!(statistics.cumulative_regret, 0.0)
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
    step = ceil(Int, float(c.t)/statistics.step_size)
    ts = c.t % statistics.step_size + 1     # counter for inner step

    α = 1.0 / statistics.step_size
    statistics.cumulative_regret_s[1] += g

    statistics.reward[step] += α * r
    statistics.regret[step] += α * g

    # per-step statistics are only computed at the end of each step
    if ts != statistics.step_size
      return
    end

    if step == 1
      statistics.cumulative_regret[step] = statistics.cumulative_regret_s[1]
    else
      statistics.cumulative_regret[step] =
        statistics.cumulative_regret_s[1] +
        statistics.cumulative_regret[step-1]
    end

    statistics.chosen_arm[step] = a
    statistics.chose_best[step] = a_star == a
    statistics.knows_best[step] = a_star == b
    statistics.max_reward[step] = bandit.means[b]
    learner_ms = means(learner)
    bandit_ms = means(bandit)
    mse = 0.0
    for a in 1:c.K
        mse += (learner_ms[a] - bandit_ms[a])^2
    end
    statistics.mse[step] = mse
    statistics.se_best[step] = (learner_ms[a_star] - bandit_ms[a_star])^2

    statistics.cumulative_regret_s[1] = 0.0

    return
end
