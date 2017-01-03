using Bandits, Distributions, ArgParse

s = ArgParseSettings()
@add_arg_table s begin
    "probs"
        help = "array of probabilities per arm, e.g., 0.2,0.1,0.12"
        required = true
    "--trials"
        help = "number of trials (time steps) played"
        arg_type = Int
        default = 1_000
    "--sims"
        help = "number of games"
        arg_type = Int
        default = 100
    "--filename"
        help = "name of time to write results to"
        default = "demo.tsv"
    "--batch-size"
        help = "batch size"
        default = "100"
end

parsed_args = parse_args(s)
T = parsed_args["trials"]
S = parsed_args["sims"]
filename = parsed_args["filename"]
probs = map(float, split(parsed_args["probs"], ","))
batch_size = [parse(Int, s) for s in split(parsed_args["batch-size"], ",")]

learner = MLELearner(0.5, 0.25)

algorithms = [
    ThompsonSampling(BetaLearner(0.5, 0.5)),
    #RewardSampling(BetaLearner(0.5, 0.5)),
    #ThompsonSampling(MLELearner(0.5, 1)),
    RandomChoice(learner),
]

bandits = [StochasticBandit([Bernoulli(p) for p in probs]),]

io = open(filename, "w")
simulate(algorithms, bandits, T, S, batch_size, io)
close(io)
print("finished writing simulation output to ", filename, "\n")
