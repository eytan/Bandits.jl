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
       # we assume all games have same fields, and use the first to get names
       fields = fieldnames(statistics.games[1])
       for metric = fields
         if metric != :T && metric != :chosen_arm
           vals = [Float64(getfield(statistics.games[s], metric)[t]) for s in 1:S]
           val_quantiles = quantile(vals, [0.025, 0.25, 0.5, 0.75, 0.975])
           min_val, max_val = minimum(vals), maximum(vals)
           mean_val = mean(vals)
           @printf(
              io,
              "%s\t%d\t%d\t%d\t%s\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n",
              string(algorithm),
              bandit_id,
              delay,
              t,
              string(metric),
              mean_val,
              min_val,
              val_quantiles[1],
              val_quantiles[2],
              val_quantiles[3],
              val_quantiles[4],
              val_quantiles[5],
              max_val,
           )
        end
      end
    end
  return
end

function update!(
    avgs::CoreAverageGameStatistics,
    obs::CoreSingleGameStatistics,
    s::Integer,
)
    α = 1 / s
    avgs.games[s] = deepcopy(obs)

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
