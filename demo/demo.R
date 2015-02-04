tmp <- read.csv("demo.tsv", sep = "\t")

ggplot(
    subset(tmp, T > 3),
    aes(x = T, y = AvgReward, color = Algorithm)
) +
    geom_line()
ggsave("average_reward.pdf", height = 8, width = 12)

ggplot(
    subset(tmp, T > 3),
    aes(x = T, y = AvgInstantaneousRegret, color = Algorithm)
) +
    geom_line()
ggsave("average_instantaneous_regret.pdf", height = 8, width = 12)

ggplot(
    subset(tmp, T > 3),
    aes(x = T, y = AvgCumulativeRegret, color = Algorithm)
) +
    geom_line()
ggsave("average_cumulative_regret.pdf", height = 8, width = 12)

ggplot(
    subset(tmp, T > 3),
    aes(x = T, y = AvgKnows, color = Algorithm)
) +
    geom_line()
ggsave("average_best_arm_identified.pdf", height = 8, width = 12)
