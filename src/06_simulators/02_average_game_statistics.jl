abstract AverageGameStatistics

immutable CoreAverageGameStatistics <: AverageGameStatistics
    T::Int
    avg_reward::Vector{Float64}
    avg_instantaneous_regret::Vector{Float64}
    avg_cumulative_regret::Vector{Float64}
    avg_knows_best::Vector{Float64}
    avg_mse::Vector{Float64}
    avg_se_best::Vector{Float64}
    sample_times::Vector{Int}

    function CoreAverageGameStatistics(T::Integer)
        # Only retain statistics from sampled times
        sample_times = 2.^(1:ifloor(log2(T)))
        S = length(sample_times)

        avg_reward = Array(Float64, S)
        fill!(avg_reward, 0.0)

        avg_instantaneous_regret = Array(Float64, S)
        fill!(avg_instantaneous_regret, 0.0)

        avg_cumulative_regret = Array(Float64, S)
        fill!(avg_cumulative_regret, 0.0)

        avg_knows_best = Array(Float64, S)
        fill!(avg_knows_best, 0.0)

        avg_mse = Array(Float64, S)
        fill!(avg_mse, 0.0)

        avg_se_best = Array(Float64, S)
        fill!(avg_se_best, 0.0)

        return new(
            T,
            avg_reward,
            avg_instantaneous_regret,
            avg_cumulative_regret,
            avg_knows_best,
            avg_mse,
            avg_se_best,
            sample_times,
        )
    end
end

function dump(
    io::IO,
    algorithm::Algorithm,
    bandit_id::Integer,
    delay::Integer,
    statistics::CoreAverageGameStatistics,
)
    # Print out data in TSV format
    for ind in 1:length(statistics.sample_times)
        @printf(
            io,
            "%s\t%d\t%d\t%d\t%f\t%f\t%f\t%f\t%f\t%f\n",
            string(algorithm),
            bandit_id,
            delay,
            statistics.sample_times[ind],
            statistics.avg_reward[ind],
            statistics.avg_instantaneous_regret[ind],
            statistics.avg_cumulative_regret[ind],
            statistics.avg_knows_best[ind],
            statistics.avg_mse[ind],
            statistics.avg_se_best[ind],
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

    for ind in 1:length(avgs.sample_times)
        t = avgs.sample_times[ind]
        avgs.avg_reward[ind] =
            (1 - α) * avgs.avg_reward[ind] + α * obs.reward[t]
        avgs.avg_instantaneous_regret[ind] =
            (1 - α) * avgs.avg_instantaneous_regret[ind] + α * obs.instantaneous_regret[t]
        avgs.avg_cumulative_regret[ind] =
            (1 - α) * avgs.avg_cumulative_regret[ind] + α * obs.cumulative_regret[t]
        avgs.avg_knows_best[ind] =
            (1 - α) * avgs.avg_knows_best[ind] + α * obs.knows_best[t]
        avgs.avg_mse[ind] = (1 - α) * avgs.avg_mse[ind] + α * obs.mse[t]
        avgs.avg_se_best[ind] =
            (1 - α) * avgs.avg_se_best[ind] + α * obs.se_best[t]
    end

    return
end
