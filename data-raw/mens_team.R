## code to prepare `mens_team` dataset goes here

mens_team <- data.frame(
  group_id = 1:77,
  group_score = rnorm(77, mean = 50, sd = 10)
)

usethis::use_data(mens_team, overwrite = TRUE)
