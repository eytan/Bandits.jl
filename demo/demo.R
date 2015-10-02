library(ggplot2)

tmp <- read.csv("demo.tsv", sep = "\t")

ggplot(
    subset(tmp, T == max(T)),
    aes(x = AvgCumulativeRegret, AvgMSE, color = Algorithm)
) +
    geom_point() +
    scale_x_log10() +
    scale_y_log10() +
    facet_grid(Delay ~ .)
ggsave("regret_mse_tradeoff_final_trial.jpg", height = 8, width = 12)

ggplot(
    subset(tmp, T > 3),
    aes(x = AvgCumulativeRegret, AvgMSE, color = Algorithm)
) +
    geom_point() +
    scale_x_log10() +
    scale_y_log10() +
    facet_grid(Delay ~ .)
ggsave("regret_mse_tradeoff.jpg", height = 8, width = 12)

ggplot(
    subset(tmp, T > 3),
    aes(x = T, y = AvgReward, color = Algorithm)
) +
    geom_line() +
    facet_grid(Delay ~ .)
ggsave("average_reward.jpg", height = 8, width = 12)

ggplot(
    subset(tmp, T > 3),
    aes(x = T, y = AvgInstantaneousRegret, color = Algorithm)
) +
    geom_line() +
    facet_grid(Delay ~ .)
ggsave("average_instantaneous_regret.jpg", height = 8, width = 12)

ggplot(
    subset(tmp, T > 3),
    aes(x = T, y = AvgCumulativeRegret, color = Algorithm)
) +
    geom_line() +
    facet_grid(Delay ~ .)
ggsave("average_cumulative_regret.jpg", height = 8, width = 12)

max.y <- max(subset(tmp, T==max(tmp$T))$AvgKnows)
ggplot(
    subset(tmp, T > 3),
    aes(x = T, y = AvgKnows, color = Algorithm)
) +
    geom_line() +
    facet_grid(Delay ~ .) +
    ylim(0, min(1,max.y))
ggsave("average_best_arm_identified.jpg", height = 8, width = 12)

ggplot(
    subset(tmp, T > 3),
    aes(x = T, y = AvgMSE, color = Algorithm)
) +
    geom_line() +
    scale_y_log10() +
    facet_grid(Delay ~ .)
ggsave("average_mse.jpg", height = 8, width = 12)

ggplot(
    subset(tmp, T > 3),
    aes(x = T, y = AvgSEBest, color = Algorithm)
) +
    geom_line() +
    scale_y_log10() +
    facet_grid(Delay ~ .)
ggsave("average_se_best.jpg", height = 8, width = 12)
