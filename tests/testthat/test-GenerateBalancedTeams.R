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
  expect_s3_class(GenerateBalancedTeams(stratified_dataset,
                                        num_teams = 7,
                                        method = "greedy",
                                        stratify = FALSE),
                  "data.frame")
  expect_s3_class(GenerateBalancedTeams(stratified_dataset,
                                        num_teams = 7,
                                        method = "greedy",
                                        stratify = TRUE),
                  "data.frame")
})
