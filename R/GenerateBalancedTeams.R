#' Generate Balanced Teams
#' @param group_id Identifier for group.
#' @param group_score Score associated with group.
#' @param num_teams Number of teams to generate.
#' @param max_num_team Maximum number of groups / team. Default value is set
#'   to be the floor of the total number of groups divided by the number of
#'   teams.
#' @export
GenerateBalancedTeams <- function(group_id,
                                  group_score,
                                  num_teams,
                                  max_num_team =
                                    floor(length(group_id) / num_teams) ) {

  stopifnot(length(group_id) == length(group_score))

  num_groups <- length(group_id)
  remainder <- num_groups - max_num_team * num_teams
  init_groups <- sample(1:num_groups, num_teams)
  init_teams <- sample(1:num_teams, num_teams)

  ## For R CMD check
  team_id <- NULL

  team_scores <- data.frame(team_id = 1:num_teams,
                            group_id = init_groups,
                            group_score = group_score[init_groups])

  groups_to_assign <- setdiff(group_id, init_groups)

  while(length(groups_to_assign)) {
    max_group_ix <- which.max(group_score[groups_to_assign])
    if (length(groups_to_assign) <= remainder) {
      max_num_team <- Inf
    }
    min_team <- .get_min_team(team_scores, max_num_team)
    team_scores <- rbind(team_scores,
                         data.frame(team_id = min_team,
                                    group_id = group_id[groups_to_assign][max_group_ix],
                                    group_score = group_score[groups_to_assign][max_group_ix]))
    groups_to_assign <- setdiff(groups_to_assign, group_id[groups_to_assign][max_group_ix])
  }

  team_scores <- team_scores %>%
    dplyr::arrange(team_id,group_id,group_score)

  return(team_scores)
}

.get_min_team <- function(df, max_num_team) {
  ## For R CMD check
  team_id <- group_score <- med_score <- num_players <- NULL

  team_min <- dplyr::group_by(df, team_id) %>%
    dplyr::summarize(mean_score = mean(group_score),
                     num_players = dplyr::n()) %>%
    dplyr::arrange(med_score, num_players) %>%
    dplyr::filter(num_players < {{max_num_team}}) %>%
    dplyr::filter(dplyr::row_number() == 1) %>%
    dplyr::pull(team_id)
  return(team_min)
}