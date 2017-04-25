library(ggplot2)
library(dplyr)
library(readr)
setwd('~/gh/Bandits.jl/demo/')
#tmp <- read.csv("big_demo1s.tsv", sep = "\t")
tmp <- read_tsv("demo.tsv") %>% filter(T%%100==0)
tmp <- read_tsv("big_qp.tsv") %>% filter(T%%100==0)
tmp <- read_tsv("recent_qp.tsv") %>% filter(T%%100==0)


tmp %>%
  filter(metric=='cumulative_regret', T>3) %>%
qplot(
x = T/1000, y = q50, color = algorithm,fill=algorithm, data=.,geom='line',
ylab='Cumulative regret', xlab='T/1000', main='Regret distribution') +
geom_ribbon(aes(ymin=q25+0.001,ymax=q75+0.001), alpha=0.5) + 
    facet_grid(delay ~ .) +
geom_ribbon(aes(ymin=q025+0.001,ymax=q975+0.001), alpha=0.25) + 
geom_ribbon(aes(ymin=min,ymax=max), alpha=0.01)+ theme_bw()

rewards <- 10*c(0.000556, 0.000558, 0.000594, 0.00063, 0.000635, 0.000642, 0.000652, 0.000661, 0.000674, 0.000677, 0.000677, 0.000723, 0.000724, 0.000744, 0.000746, 0.000751, 0.000752, 0.000759, 0.00076, 0.000764, 0.000771, 0.000772, 0.000779, 0.000779, 0.000798, 0.000806, 0.000819, 0.00083, 0.000846, 0.000864, 0.000887, 0.000905, 0.000939, 0.000946, 0.000948, 0.000966, 0.000968, 0.00097, 0.000978, 0.000985, 0.001033, 0.001041, 0.001047, 0.001132, 0.001144, 0.001152, 0.001175, 0.001228)

#recent

rewards <- c(0.0575346241300903,0.0572364617460012,0.0623013350286078,0.0491676345334882,0.0516423011201823,0.0535714285714286,0.068642160540135,0.0671725776450912,0.0684662998624484)

max.reward <- max(rewards)
rand.reward <- mean(rewards)

#########
tmp %>%
  filter(metric=='cumulative_regret', T>3) %>%
qplot(
x = T/1000, y = (max.reward*T-q50)/(rand.reward*T)-1, color = algorithm,fill=algorithm, data=.,geom='line',
ylab='Improvement over AB test', xlab='thousands of users') + scale_y_continuous(label=percent) + geom_ribbon(aes(ymin=(max.reward*T-q25)/(rand.reward*T)-1,ymax=(max.reward*T-q75)/(rand.reward*T)-1), alpha=0.5)
######

#########
tmp %>%
  filter(metric=='cumulative_regret', T>3) %>%
qplot(
x = T/1000, y = (max.reward*T-q50)/(max.reward*T), color = algorithm,fill=algorithm, data=.,geom='line',
ylab='Efficiency', xlab='thousands of users') + scale_y_continuous(label=percent) 
    
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

