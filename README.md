# Bandits.jl

A Julia package for simulating the behavior of new algorithms for solving
multi-armed bandit problems, including the stochastic and contextual
problems.

# Types

* `Context`
    * `MinimalContext`
    * `StochasticContext`
* `Bandit`
    * `AdversarialBandit`
    * `DuelingBandits`
    * `ProbabilisticBandit`
        * `ContextualBandit`
        * `NonStationaryBandit`
            * `ChangePointBandits`
            * `MarkovianBandit`
            * `RestlessBandits`
            * `SleepingBandits`
        * `StochasticBandit`
* `Learner`
    * `MLELearner`
    * `BetaLearner`
* `Algorithm`
    * `RandomChoice`
    * `EpsilonGreedy`
    * `AnnealingEpsilonGreedy`
    * `DecreasingEpsilonGreedy`
    * `Softmax`
    * `AnnealingSoftmax`
    * `UCB1`
    * `UCB1Tuned`
    * `UCB2`
    * `UCBV`
    * `Exp3`
    * `ThompsonSampling`
    * `Hedge`
    * `MOSS`
    * `ReinforcementComparison`
    * `Pursuit`
* `Game`
    * `StochasticGame`

# Interfaces

TO BE FILLED IN...

# Demo

```jl
using Bandits, Distributions

algorithms = [
    RandomChoice(MLELearner(0.5, 0.25)),
    EpsilonGreedy(MLELearner(0.5, 0.25), 0.1),
    Softmax(MLELearner(0.5, 0.25), 0.1),
    UCB1(MLELearner(0.5, 0.25)),
    ThompsonSampling(BetaLearner()),
    MOSS(MLELearner(0.5, 0.25)),
]

bandits = [
    StochasticBandit(
        [
            Bernoulli(0.1),
            Bernoulli(0.2),
            Bernoulli(0.3),
        ]
    ),
]

T = 5
S = 50_000

simulate(algorithms, bandits, T, S)
```

# Notation

* t: Current trial
* T: Total number of trials
* c: Context
* a: Index of an arm
* r: Reward
* g: Regret
