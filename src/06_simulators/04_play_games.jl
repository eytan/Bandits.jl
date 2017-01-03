function play_games!(
    game_statistics::CoreSingleGameStatistics,
    avg_game_statistics::CoreAverageGameStatistics,
    algorithm::Algorithm,
    bandit::Bandit,
    T::Integer,
    S::Integer,
    delay::Integer
)
    game = StochasticGame(algorithm, bandit, T, delay)
    for s in 1:S
        reinitialize!(game_statistics)
        play_game!(game, game_statistics)
        update!(avg_game_statistics, game_statistics, s)
    end

    return
end
