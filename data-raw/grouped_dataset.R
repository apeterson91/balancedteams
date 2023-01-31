## code to prepare `grouped_dataset` dataset goes here

set.seed(351353)
n <- 100
grouped_dataset <- data.frame(
  player_id = 1:n,
  group_id = 1:n,
  player_score = rnorm(n, mean = 50, sd = 10)
)

## baggage group of 3
grouped_dataset[10:12,]$group_id <- 10
## baggage group of 5
grouped_dataset[50:54,]$group_id <- 50
## baggage group of 2
grouped_dataset[70:71,]$group_id <- 70

usethis::use_data(grouped_dataset, overwrite = TRUE)
