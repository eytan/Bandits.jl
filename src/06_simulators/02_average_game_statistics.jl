abstract AverageGameStatistics

immutable CoreAverageGameStatistics <: AverageGameStatistics
    S::Int
    T::Int
    step_size::Int
    games::Vector{CoreSingleGameStatistics}

    function CoreAverageGameStatistics(
      S::Integer,
      T::Integer,
      step_size::Integer,
    )
        games = Array(CoreSingleGameStatistics, S)

        return new(S, T, step_size, games)
    end
end

function update!(
    avgs::CoreAverageGameStatistics,
    obs::CoreSingleGameStatistics,
    s::Integer,
)
    α = 1 / s
    avgs.games[s] = deepcopy(obs)
    return
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
    for t in 1:statistics.step_size:statistics.T
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
