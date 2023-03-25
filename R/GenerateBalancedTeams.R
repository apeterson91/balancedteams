#' Generate Balanced Teams
#' @param df Data frame containing columns of player_id, group_id, and score.
#' @param num_teams Number of teams to generate.
#' @param max_num_team Maximum number of groups / team. Default value is set
#'   to be the floor of the total number of groups divided by the number of
#'   teams.
#' @param stratify Boolean that indicates whether or not scores should be
#' stratified by the strata variable when calculating assignments. Note that
#' this option is only available for the "greedy" algorithm.
#' @param method One of c("greedy","MILP") indicating whether a greedy
#'   algorithm or a mixed integer linear programming routine should be used
#'   to estimate the team assignments. The latter provides the optimal solution
#'   but the former is more memory efficient.
#' @export
GenerateBalancedTeams <- function(df,
                                  num_teams,
                                  max_num_team =
                                    ceiling(nrow(df) / num_teams),
                                  stratify = FALSE,
                                  method = "greedy") {

  stopifnot(method %in% c("greedy","MILP"), length(method) == 1)
  if(stratify) {
    stopifnot("strata" %in% colnames(df))
    ## simple heuristic for max strata / team
    max_strata <- ceiling(sum(df$strata) / num_teams) + 1
  }
  # Probably need an error condition on # player / # team bounds

  summarized <- .create_summary_df(df, stratify)

  jdf <- df %>%
    dplyr::distinct(group_id) %>%
    dplyr::mutate(new_group_id = 1:dplyr::n()) %>%
    dplyr::right_join(df, by = c("group_id"), multiple = "all")

  group_id <- dplyr::pull(summarized, new_group_id)
  group_score <- dplyr::pull(summarized, group_score)
  num_players <- dplyr::pull(summarized, num_players)

  num_groups <- length(unique(group_id))

  if(method == "greedy" && stratify) {
    num_strata <- dplyr::pull(summarized, num_strata)
    strata_score <- dplyr::pull(summarized)
    team_assignments <- GreedyStratifiedTeams(group_id, group_score,
                                              strata_score, num_players,
                                              num_strata, num_teams,
                                              num_groups, max_num_team,
                                              max_strata)
  } else if(method == "greedy" && !stratify) {
    team_assignments <- GreedyTeams(group_id, group_score, num_players,
                                    num_teams, num_groups, max_num_team)
  } else {
    team_assignments <- MILPTeams(group_id, group_score, #num_players, # not yet used
                                  num_teams, num_groups, max_num_team)
  }

  pdf <- jdf %>% dplyr::select(player_id, player_score)
  jdf <- jdf %>% dplyr::select(-player_score)
  team_assignments <- team_assignments %>%
    dplyr::rename(new_group_id = "group_id") %>%
    dplyr::right_join(jdf, by = c("new_group_id"), multiple = "all") %>%
    dplyr::inner_join(pdf, by = c("player_id"), multiple = "all") %>%
    dplyr::select(team_id, player_id, group_id, score, player_score)

  if(stratify) {
    player_id_strata <- df %>%
      dplyr::select(player_id, strata)
    team_assignments <- team_assignments %>%
      dplyr::left_join(player_id_strata, by = "player_id", multiple = "all")
  }


  return(team_assignments)
}

.create_summary_df <- function(df, stratify) {

  if(stratify) {
    summarized <- df %>%
      dplyr::group_by(group_id) %>%
      dplyr::summarize(group_score = mean(player_score),
                       num_strata = sum(strata),
                       num_players = dplyr::n(),
                       strata_score = sum(player_score*strata) / num_strata
                       ) %>%
      dplyr::ungroup() %>%
      dplyr::mutate(new_group_id = 1:dplyr::n(),
                    strata_score = tidyr::replace_na(strata_score, 0))
  } else {
    summarized <- df %>%
      dplyr::group_by(group_id) %>%
      dplyr::summarize(group_score = mean(player_score),
                       num_players = dplyr::n()) %>%
      dplyr::ungroup() %>%
      dplyr::mutate(new_group_id = 1:dplyr::n())
  }

  return(summarized)
}
