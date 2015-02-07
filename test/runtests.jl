#
# Correctness Tests
#

fatalerrors = length(ARGS) > 0 && ARGS[1] == "-f"
quiet = length(ARGS) > 0 && ARGS[1] == "-q"
anyerrors = false

using Base.Test
using Bandits

my_tests = [
    "01_contexts/01_context.jl",
    "01_contexts/02_minimal_context.jl",
    "01_contexts/03_stochastic_context.jl",

    "02_bandits/01_bandit.jl",
    "02_bandits/02_stochastic_bandit.jl",
    "02_bandits/03_contextual_bandit.jl",

    "03_learners/01_learner.jl",
    "03_learners/02_mle_learner.jl",
    "03_learners/03_beta_learner.jl",

    "04_algorithms/01_algorithm.jl",
    "04_algorithms/02_baseline/01_random_choice.jl",
    "04_algorithms/03_e-greedy/01_standard.jl",
    "04_algorithms/03_e-greedy/02_annealing.jl",
    "04_algorithms/03_e-greedy/03_decreasing.jl",
    "04_algorithms/04_softmax/01_standard.jl",
    "04_algorithms/04_softmax/02_annealing.jl",
    "04_algorithms/05_ucb/01_ucb1.jl",
    "04_algorithms/05_ucb/02_ucb1_tuned.jl",
    "04_algorithms/05_ucb/03_ucb2.jl",
    "04_algorithms/05_ucb/04_ucb_v.jl",
    # TODO: Get this working
    # "04_algorithms/06_exp/01_exp3.jl",
    "04_algorithms/07_thompson/01_standard.jl",
    "04_algorithms/08_hedge/01_standard.jl",
    "04_algorithms/09_moss/01_standard.jl",
    "04_algorithms/10_rl/01_comparison.jl",
    "04_algorithms/10_rl/02_pursuit.jl",
    "04_algorithms/11_optimal_arm/02_sig_successive_rejects.jl",

    "05_games/01_game.jl",
    "05_games/02_stochastic.jl",

    "06_simulators/03_play_game.jl",
    "06_simulators/05_simulate.jl",
]

println("Running tests:")

for my_test in my_tests
    try
        include(my_test)
        println("\t\033[1m\033[32mPASSED\033[0m: $(my_test)")
    catch e
        anyerrors = true
        println("\t\033[1m\033[31mFAILED\033[0m: $(my_test)")
        if fatalerrors
            rethrow(e)
        elseif !quiet
            showerror(STDOUT, e, backtrace())
            println()
        end
    end
end

if anyerrors
    throw("Tests failed")
end
