#' Greedy Algorithm Team Assignment - Accounting for Strata
#' @param group_id Identifier for group.
#' @param group_score Score associated with group members not in strata.
#' @param strata_score Score associated with strata.
#' @param num_players Number of players in each group.
#' @param num_strata Number of players in a specific strata in each group.
#' @param num_teams Number of teams to generate.
#' @param num_groups Number of groups included in group_id.
#' @param max_num_team Maximum number of groups / team.
#' @param max_strata Maximum number of strata to be met for each team.
#' @export
GreedyStratifiedTeams <- function(group_id, group_score,
                                  strata_score, num_players,
                                  num_strata, num_teams,
                                  num_groups,
                                  max_num_team,
                                  max_strata =
                                    ceiling(sum(num_strata) / num_teams) + 1) {

  remainder <- num_groups - max_num_team * num_teams
  init_groups <- sample(1:num_groups, num_teams)
  init_teams <- sample(1:num_teams, num_teams)
  ## For R CMD check
  team_id <- NULL

  team_scores <- dplyr::tibble(team_id = 1:num_teams,
                               group_id = init_groups,
                               score = group_score[init_groups],
                               strata_score = strata_score[init_groups],
                               num_players = num_players[init_groups],
                               num_strata = num_strata[init_groups])

  strata_groups <- group_id[which(num_strata > 0)]
  strata_groups_to_assign <- setdiff(strata_groups, init_groups)

  while(length(strata_groups_to_assign)) {
    max_group_ix <- which.max(group_score[strata_groups_to_assign])
    min_team <- .get_strata_min_team(team_scores, max_strata, max_num_team)
    team_scores <- rbind(team_scores,
                         data.frame(team_id = min_team,
                                    group_id =
                                      group_id[strata_groups_to_assign][max_group_ix],
                                    num_players = num_players[strata_groups_to_assign][max_group_ix],
                                    num_strata = num_strata[strata_groups_to_assign][max_group_ix],
                                    score =
                                      group_score[strata_groups_to_assign][max_group_ix],
                                    strata_score = strata_score[strata_groups_to_assign][max_group_ix]))
    strata_groups_to_assign <- setdiff(strata_groups_to_assign,
                                       group_id[strata_groups_to_assign]
                                       [max_group_ix])

  }

  groups_to_assign <- setdiff(group_id, team_scores$group_id)
  while(length(groups_to_assign)) {
    max_group_ix <- which.max(group_score[groups_to_assign])
    if (length(groups_to_assign) <= remainder) {
      max_num_team <- Inf
    }
    min_team <- .get_strata_min_team(team_scores, max_strata, max_num_team)
    team_scores <- rbind(team_scores,
                         data.frame(team_id = min_team,
                                    group_id =
                                      group_id[groups_to_assign][max_group_ix],
                                    num_players = num_players[groups_to_assign][max_group_ix],
                                    num_strata = num_strata[groups_to_assign][max_group_ix],
                                    score =
                                      group_score[groups_to_assign][max_group_ix],
                                    strata_score = strata_score[groups_to_assign][max_group_ix]))
    groups_to_assign <- setdiff(groups_to_assign,
                                group_id[groups_to_assign][max_group_ix])
  }

  team_scores <- team_scores %>%
    dplyr::arrange(team_id, group_id, group_score)


  return(team_scores)
}


.get_strata_min_team <- function(df, max_strata, max_num_team) {
  ## For R CMD check
  team_id <- med_score <- num_players <- score <-  NULL

  team_min <- dplyr::group_by(df, team_id) %>%
    dplyr::summarize(mean_score = sum(score) / sum(num_players),
                     num_strata = sum(num_strata),
                     num_players = sum(num_players),
                     strata_ratio = num_strata / num_players) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(num_players, strata_ratio, mean_score) %>%
    dplyr::filter(num_players < max_num_team,
                  num_strata < max_strata) %>%
    dplyr::filter(dplyr::row_number() == 1) %>%
    dplyr::pull(team_id)

  ## if there are no teams that have less than the max strata,
  ## assign with strata ratio as the last sorting priority.
  if(length(team_min) == 0) {
    team_min <- dplyr::group_by(df, team_id) %>%
      dplyr::summarize(mean_score = sum(score) / sum(num_players),
                       num_strata = sum(num_strata),
                       num_players = sum(num_players),
                       strata_ratio = num_strata / num_players) %>%
      dplyr::ungroup() %>%
      dplyr::arrange(num_players, mean_score, strata_ratio) %>%
      dplyr::filter(num_players < max_num_team) %>%
      dplyr::filter(dplyr::row_number() == 1) %>%
      dplyr::pull(team_id)
  }

  return(team_min)
}
