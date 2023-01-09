test_that("MILP Teams works as intended", {
  expect_s3_class(MILPTeams(mens_team$group_id,
                            mens_team$group_score,
                            num_teams = 7,
                            num_groups = 77,
                            max_num_team = 11),
                  "data.frame")
})
