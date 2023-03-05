testthat::capture_output(
    summarized_df <- stratified_dataset %>%
      dplyr::group_by(group_id) %>%
      dplyr::summarize(group_score = mean(player_score),
                       num_strata = sum(strata),
                       num_players = dplyr::n(),
                       strata_score = sum(player_score*strata) / num_strata
                       ) %>%
      dplyr::ungroup() %>%
      dplyr::mutate(new_group_id = 1:dplyr::n(),
                    strata_score = tidyr::replace_na(strata_score, 0))
)

test_that("Greedy Stratified Teams Works as Intended", {
expect_s3_class(GreedyStratifiedTeams(group_id = summarized_df$new_group_id,
                                      group_score = summarized_df$group_score,
                                      strata_score =  summarized_df$strata_score,
                                      num_players = summarized_df$num_players,
                                      num_strata = summarized_df$num_strata,
                                      ## num players per group
                                      num_team = 7,
                                      num_groups = length(summarized_df$group_id),
                                      max_num_team = 15),
                "data.frame")
})
