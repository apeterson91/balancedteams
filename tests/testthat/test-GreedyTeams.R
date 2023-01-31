test_that("Greedy Algorithm works as intended.", {
expect_s3_class(GreedyTeams(mens_team$group_id,
                            mens_team$group_score,
                            rep(1, nrow(mens_team)),
                            num_teams = 7,
                            num_groups = 77,
                            max_num_team = 11),
                "data.frame")
})
