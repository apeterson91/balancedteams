test_that("GenerateBalancedTeams works", {
  expect_error(GenerateBalancedTeams(1:10,rnorm(25),5))
  expect_s3_class(GenerateBalancedTeams(mens_team$group_id,
                                     mens_team$group_score,
                                     num_teams = 7),
               "data.frame")
})