abstract AverageGameStatistics

immutable CoreAverageGameStatistics <: AverageGameStatistics
    T::Int
    avg_reward::Vector{Float64}
    avg_instantaneous_regret::Vector{Float64}
    avg_cumulative_regret::Vector{Float64}
    avg_knows_best::Vector{Float64}

    function CoreAverageGameStatistics(T::Integer)
        avg_reward = Array(Float64, T)
        fill!(avg_reward, 0.0)
        avg_instantaneous_regret = Array(Float64, T)
        fill!(avg_instantaneous_regret, 0.0)
        avg_cumulative_regret = Array(Float64, T)
        fill!(avg_cumulative_regret, 0.0)
        avg_knows_best = Array(Float64, T)
        fill!(avg_knows_best, 0.0)
        return new(
            T,
            avg_reward,
            avg_instantaneous_regret,
            avg_cumulative_regret,
            avg_knows_best,
        )
    end
end

function dump(
    io::IO,
    algorithm::Algorithm,
    bandit_id::Integer,
    statistics::CoreAverageGameStatistics,
)
    # Print out data in TSV format
    for t in 1:statistics.T
        @printf(
            io,
            "%s\t%d\t%d\t%f\t%f\t%f\t%f\n",
            typeof(algorithm),
            bandit_id,
            t,
            statistics.avg_reward[t],
            statistics.avg_instantaneous_regret[t],
            statistics.avg_cumulative_regret[t],
            statistics.avg_knows_best[t],
        )
    end

    return
end

function update!(
    avgs::CoreAverageGameStatistics,
    obs::CoreSingleGameStatistics,
    s::Integer,
)
    α = 1 / s

    for t in 1:avgs.T
        avgs.avg_reward[t] =
            (1 - α) * avgs.avg_reward[t] + α * obs.reward[t]
        avgs.avg_instantaneous_regret[t] =
            (1 - α) * avgs.avg_instantaneous_regret[t] + α * obs.instantaneous_regret[t]
        avgs.avg_cumulative_regret[t] =
            (1 - α) * avgs.avg_cumulative_regret[t] + α * obs.cumulative_regret[t]
        avgs.avg_knows_best[t] =
            (1 - α) * avgs.avg_knows_best[t] + α * obs.knows_best[t]
    end

    return
end
