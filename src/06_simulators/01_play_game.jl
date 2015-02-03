function play_game!(
    game::StochasticGame,
    rewards::Vector,
    regrets::Vector,
    chosen_arms::Vector,
    chose_best::BitVector,
    knows_best::BitVector,
)
    # Set up aliases
    algorithm = game.algorithm
    bandit = game.bandit
    K = count_arms(bandit, MinimalContext(1))
    T = game.T

    # Initialize the algorithm
    initialize!(algorithm, K)

    # Determine the best arm for this bandit
    a_star = best_arm(bandit, MinimalContext(1))

    # Play all T trials of the game
    for t in 1:T
        # TODO: Randomly draw a context

        # Set up the agent's knowledge of the context
        context = StochasticContext(t, K)

        # Agent selects an arm
        a = choose_arm(algorithm, context)

        # Agent indicates its preferred arm
        # TODO: This doesn't make sense for contextual
        b = preferred_arm(algorithm, context)

        # A draw is made from the agent's chosen arm to produce a reward
        r = draw(bandit, context, a)

        # Calculate the regret for the agent's choice of arm
        g = regret(bandit, context, a)

        # Agent learns from its rewards before the next trial begins
        learn!(algorithm, context, a, r)

        # Track the core statistics for this trial
        rewards[t] = r
        regrets[t] = g
        chosen_arms[t] = a
        chose_best[t] = a_star == a
        knows_best[t] = a_star == b
    end

    return
end
