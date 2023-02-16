test_that("Greedy Algorithm works as intended.", {
expect_s3_class(GreedyTeams(group_id = mens_team$group_id,
                            group_score = mens_team$player_score,
                            num_teams = 7,
                            ## num players per group
                            num_players = rep(1, nrow(mens_team)),
                            num_groups = length(unique(mens_team$group_id)),
                            max_num_team = 11),
                "data.frame")
})
