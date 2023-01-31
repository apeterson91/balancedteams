#' Generate Balanced Teams
#' @param df Data frame containing columns of player_id, group_id, and score.
#' @param num_teams Number of teams to generate.
#' @param max_num_team Maximum number of groups / team. Default value is set
#'   to be the floor of the total number of groups divided by the number of
#'   teams.
#' @param method One of c("greedy","MILP") indicating whether a greedy
#'   algorithm or a mixed integer linear programming routine should be used
#'   to estimate the team assignments. The latter is more optimal but the
#'   former is more memory efficient.
#' @export
GenerateBalancedTeams <- function(df,
                                  num_teams,
                                  max_num_team =
                                    ceiling(nrow(df) / num_teams),
                                  method = "greedy") {

  stopifnot(method %in% c("greedy","MILP"), length(method) == 1)
  # Probably need an error condition on # player / # team bounds

  summarized <- df %>%
    dplyr::group_by(group_id) %>%
    dplyr::summarize(group_score = mean(player_score),
                     num_players = dplyr::n()) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(new_group_id = 1:dplyr::n())

  jdf <- df %>%
    dplyr::distinct(group_id) %>%
    dplyr::mutate(new_group_id = 1:dplyr::n()) %>%
    dplyr::right_join(df, by = c("group_id"))

  group_id <- dplyr::pull(summarized, new_group_id)
  group_score <- dplyr::pull(summarized, group_score)
  num_players <- dplyr::pull(summarized, num_players)

  num_groups <- length(unique(group_id))

  if(method == "greedy") {
    team_assignments <- GreedyTeams(group_id, group_score, num_players,
                                    num_teams, num_groups, max_num_team)
  } else {
    team_assignments <- MILPTeams(group_id, group_score, num_players,
                                  num_teams, num_groups, max_num_team)
  }

  team_assignments <- team_assignments %>%
    dplyr::left_join(jdf, by = c("group_id" = "new_group_id",
                                 "score" = "player_score")) %>%
    dplyr::select(team_id, player_id, group_id, score)

  return(team_assignments)
}
