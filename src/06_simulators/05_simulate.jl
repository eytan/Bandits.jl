function simulate(
    algorithms::Vector,
    bandits::Vector,
    T::Integer,
    S::Integer,
    delays::Vector,
    io::IO = STDOUT,
)
    game_statistics = CoreSingleGameStatistics(T)
    avg_game_statistics = CoreAverageGameStatistics(T)

    # Print out a header to STDOUT in TSV format
    @printf(io, "Algorithm\tBandit\tDelay\tT\tAvgReward\tAvgInstantaneousRegret\t")
    @printf(io, "AvgCumulativeRegret\tAvgKnows\tAvgMSE\tAvgSEBest\n")

    # Generate data and print it to STDOUT in TSV format
    for delay in delays
        for algorithm in algorithms
            for (bandit_id, bandit) in enumerate(bandits)
                play_games!(
                    game_statistics,
                    avg_game_statistics,
                    algorithm,
                    bandit,
                    T,
                    S,
                    delay
                )
                dump(io, algorithm, bandit_id, delay, avg_game_statistics)
            end
        end
    end

    return
end
