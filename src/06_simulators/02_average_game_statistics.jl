abstract AverageGameStatistics

immutable CoreAverageGameStatistics <: AverageGameStatistics
    S::Int
    T::Int
    games::Vector{CoreSingleGameStatistics}
    avg_reward::Vector{Float64}
    avg_instantaneous_regret::Vector{Float64}
    avg_cumulative_regret::Vector{Float64}
    avg_knows_best::Vector{Float64}
    avg_mse::Vector{Float64}
    avg_se_best::Vector{Float64}

    function CoreAverageGameStatistics(S::Integer, T::Integer)
        games = Array(CoreSingleGameStatistics, S)
        avg_reward = Array(Float64, T)
        fill!(avg_reward, 0.0)

        avg_instantaneous_regret = Array(Float64, T)
        fill!(avg_instantaneous_regret, 0.0)

        avg_cumulative_regret = Array(Float64, T)
        fill!(avg_cumulative_regret, 0.0)

        avg_knows_best = Array(Float64, T)
        fill!(avg_knows_best, 0.0)

        avg_mse = Array(Float64, T)
        fill!(avg_mse, 0.0)

        avg_se_best = Array(Float64, T)
        fill!(avg_se_best, 0.0)

        return new(
            S,
            T,
            games,
            avg_reward,
            avg_instantaneous_regret,
            avg_cumulative_regret,
            avg_knows_best,
            avg_mse,
            avg_se_best,
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
    S = statistics.S
    # Print out data in TSV format
    for t in 1:statistics.T
       ## Here is my first attempt at extracting distributional statistics
       # on algorithm performance metrics. There are a few things that seem
       # less than ideal:
       # (1) Use of the list comprehension seems not very efficient
       # (2) It would be awkward to write this out for every metric, but maybe
       #     not a huge deal
       # (3) if we add 7 more distributional statistics for every metric
       #     that would be 7x6 columns.  This seems like it would be annoying
       #     to write out.  I wonder if a long format would work better, like
       #       algorithm,bandit_id,delay_t,metric,avg,min,max,q025,q25,q75,q975
       metrics = [(statistics.games[s]).knows_best[t] for s in 1:S]
       metrics_quantiles = quantile(metrics, [0.025, 0.25, 0.5, 0.75, 0.975])
       # max and min are not defined for booleans, interestingly enough, so
       # the following line won't work for knows_best.
       #metrics_min, metrics_max = min(metrics), max(metrics)

        @printf(
            io,
            "%s\t%d\t%d\t%d\t%f\t%f\t%f\t%f\t%f\t%f\n",
            string(algorithm),
            bandit_id,
            delay,
            t,
            statistics.avg_reward[t],
            statistics.avg_instantaneous_regret[t],
            statistics.avg_cumulative_regret[t],
            statistics.avg_knows_best[t],
            statistics.avg_mse[t],
            statistics.avg_se_best[t],
        )
    end

    return
end

function update!(
    avgs::CoreAverageGameStatistics,
    obs::CoreSingleGameStatistics,
    s::Integer
)
    α = 1 / avgs.S
    avgs.games[s] = obs

    for t in 1:avgs.T
        avgs.avg_reward[t] =
            (1 - α) * avgs.avg_reward[t] + α * obs.reward[t]
        avgs.avg_instantaneous_regret[t] =
            (1 - α) * avgs.avg_instantaneous_regret[t] + α * obs.instantaneous_regret[t]
        avgs.avg_cumulative_regret[t] =
            (1 - α) * avgs.avg_cumulative_regret[t] + α * obs.cumulative_regret[t]
        avgs.avg_knows_best[t] =
            (1 - α) * avgs.avg_knows_best[t] + α * obs.knows_best[t]
        avgs.avg_mse[t] = (1 - α) * avgs.avg_mse[t] + α * obs.mse[t]
        avgs.avg_se_best[t] =
            (1 - α) * avgs.avg_se_best[t] + α * obs.se_best[t]
    end

    return
end
