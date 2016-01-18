library(ggplot2)
library(dplyr)

#tmp <- read.csv("big_demo1s.tsv", sep = "\t")
tmp <- read.csv("demo.tsv", sep = "\t")

tmp %>%
  filter(metric=='cumulative_regret', T>3) %>%
qplot(
x = T/1000, y = q50, color = algorithm,fill=algorithm, data=.,geom='line',
ylab='Cumulative regret', xlab='T/1000', main='Regret distribution') +
geom_ribbon(aes(ymin=q25+0.001,ymax=q75+0.001), alpha=0.5) + 
geom_ribbon(aes(ymin=q025+0.001,ymax=q975+0.001), alpha=0.25) + 
geom_ribbon(aes(ymin=min,ymax=max), alpha=0.01) +
    facet_grid(delay ~ algorithm) + theme_bw()
    
tmp %>%
  filter(metric=='cumulative_regret', T>3) %>%
qplot(
x = T/1000, y = q50, color = algorithm,fill=algorithm, data=.,geom='line',
ylab='Cumulative regret', xlab='T/1000', main='Regret distribution') +
geom_ribbon(aes(ymin=q25+0.001,ymax=q75+0.001), alpha=0.5) + 
geom_ribbon(aes(ymin=q025+0.001,ymax=q975+0.001), alpha=0.25) + 
geom_ribbon(aes(ymin=min,ymax=max), alpha=0.01) +
   theme_bw()
    

    
tmp %>%
  filter(metric=='knows_best', T>3) %>%
qplot(
x = T, y = mean, color = algorithm,fill=algorithm, data=.,geom='line') + 
    facet_grid(delay ~ .) + theme_bw()

tmp %>%
  filter(metric=='se_best', T>3, delay==1,
  algorithm != 'UCB1Tuned(MLELearner(0.500000, 0.250000))') %>%
qplot(
x = T, y = q50, color = algorithm,fill=algorithm, data=.,geom='line',
ylab='cumulative regret', main='regret distribution',log='y') +
geom_ribbon(aes(ymin=q25+0.001,ymax=q75+0.001), alpha=0.5) + 
geom_ribbon(aes(ymin=q025+0.001,ymax=q975+0.001), alpha=0.25) + 
geom_ribbon(aes(ymin=min,ymax=max), alpha=0.01) +
    facet_grid(.~algorithm ) + theme_bw()
    
    
 
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

