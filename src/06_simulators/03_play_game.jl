@doc """
Simulate a single play of a stochastic bandit game. Store game statistics
as the simulation proceeds.
""" ->
function play_game!(game::StochasticGame, statistics::SingleGameStatistics)
    # Set up aliases
    algorithm, bandit, T = game.algorithm, game.bandit, game.T
    # TODO: Should this function work for StochasticBandit
    # without a context object?
    K = count_arms(bandit, MinimalContext(1))

    # Initialize the algorithm
    initialize!(algorithm, K)

    # Determine the best arm for this bandit
    a_star = best_arm(bandit, MinimalContext(1))

    # Learning occurs in batches
    current_delay = delay(game)
    next_update = current_delay

    # Play all T trials of the game
    for t in 1:T
        # Set up the agent's knowledge of the context
        c = StochasticContext(t, K)

        # Agent selects an arm given context
        a = choose_arm(algorithm, c)

        # Agent indicates its preferred arm given context
        b = preferred_arm(algorithm, c)

        # A draw is made from the agent's chosen arm to produce a reward
        r = draw(bandit, c, a)

        # Calculate the regret implied by the agent's chosen arm
        g = regret(bandit, c, a)

        # We store core data in a queue for batch updating
        store!(game.queue, c, a, r)

        # Agent learns from its observed reward if we are at a batch update
        if t == next_update
            for obs in 1:current_delay
                learn!(
                    algorithm,
                    game.queue.c[obs],
                    game.queue.a[obs],
                    game.queue.r[obs]
                )
            end
            current_delay = delay(game)
            next_update += current_delay
            clear!(game.queue)
        end

        # We update the core simulation statistics for this game
        update!(statistics, a_star, c, a, b, r, g)
    end

    # All changes to state occur via mutation, so we return nothing
    return
end
