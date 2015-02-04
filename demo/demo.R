tmp <- read.csv("demo.tsv", sep = "\t")

ggplot(
    subset(tmp, T > 3),
    aes(x = T, y = AvgReward, color = Algorithm)
) +
    geom_line()

ggplot(
    subset(tmp, T > 3),
    aes(x = T, y = AvgInstantaneousRegret, color = Algorithm)
) +
    geom_line()

ggplot(
    subset(tmp, T > 3),
    aes(x = T, y = AvgCumulativeRegret, color = Algorithm)
) +
    geom_line()

ggplot(
    subset(tmp, T > 3),
    aes(x = T, y = AvgKnows, color = Algorithm)
) +
    geom_line()
