function simulate(
    algorithms::Vector,
    bandits::Vector,
    T::Integer,
    S::Integer,
    delays::Vector,
    io::IO = STDOUT,
)
    game_statistics = CoreSingleGameStatistics(T)
    
    # Print out a header to STDOUT in TSV format
    @printf(io, "algorithm\tbandit\tdelay\tT\tmetric")
    @printf(io, "\tmean\tmin\tq025\tq25\tq50\tq75\tq975\tmax\n")

    # Generate data and print it to STDOUT in TSV format
    for delay in delays
        step_size = round(Int, max(delay/10,1))
        avg_game_statistics = CoreAverageGameStatistics(S, T, step_size)
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
