## code to prepare `mens_team` dataset goes here

set.seed(351351)
mens_team <- data.frame(
  group_id = 1:77,
  player_id = 1:77,
  num_players = 1,
  player_score = rnorm(77, mean = 50, sd = 10)
)

usethis::use_data(mens_team, overwrite = TRUE)
