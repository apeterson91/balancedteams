test_that("GenerateBalancedTeams works", {
  expect_error(GenerateBalancedTeams(mens_team,
                                     num_teams = 7,
                                     method = "any"))
  expect_error(GenerateBalancedTeams(mens_team,
               num_teams = 7,
               method = "greedy",
               stratify = TRUE))
  expect_s3_class(GenerateBalancedTeams(mens_team,
                                     num_teams = 7),
               "data.frame")
  expect_s3_class(GenerateBalancedTeams(mens_team,
                                     num_teams = 7,
                                     method = "MILP"),
               "data.frame")
})
