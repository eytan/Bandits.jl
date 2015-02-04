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
    cumulative_regret::Vector{Float64}
    chosen_arm::Vector{Int}
    chose_best::BitVector
    knows_best::BitVector
    # TODO: Track MSE comparing mu - mu_hat summed over all arms.
    # TODO: Track MSE comparing mu - mu_hat for the optimal arm.

    function CoreSingleGameStatistics(T::Integer)
        reward = Array(Float64, T)
        instantaneous_regret = Array(Float64, T)
        cumulative_regret = Array(Float64, T)
        chosen_arm = Array(Int, T)
        chose_best = BitArray(T)
        knows_best = BitArray(T)
        return new(
            T,
            reward,
            instantaneous_regret,
            cumulative_regret,
            chosen_arm,
            chose_best,
            knows_best,
        )
    end
end

@doc """
Update statistics for the current trial.
""" ->
function update!(
    statistics::CoreSingleGameStatistics,
    a_star::Integer,
    c::Context,
    a::Integer,
    b::Integer,
    r::Real,
    g::Real,
)
    statistics.reward[c.t] = r
    statistics.instantaneous_regret[c.t] = g
    if c.t == 1
        statistics.cumulative_regret[c.t] = g
    else
        statistics.cumulative_regret[c.t] = statistics.cumulative_regret[c.t - 1] + g
    end
    statistics.chosen_arm[c.t] = a
    statistics.chose_best[c.t] = a_star == a
    statistics.knows_best[c.t] = a_star == b
    return
end
