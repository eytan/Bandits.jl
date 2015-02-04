function play_games!(
    game_statistics::CoreSingleGameStatistics,
    avg_game_statistics::CoreAverageGameStatistics,
    algorithm::Algorithm,
    bandit::Bandit,
    T::Integer,
    S::Integer,
)
    game = StochasticGame(algorithm, bandit, T)
    for s in 1:S
        play_game!(game, game_statistics)
        update!(avg_game_statistics, game_statistics, s)
    end

    return
end
