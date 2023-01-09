#' Generate Balanced Teams
#' @param group_id Identifier for group.
#' @param group_score Score associated with group.
#' @param num_teams Number of teams to generate.
#' @param max_num_team Maximum number of groups / team. Default value is set
#'   to be the floor of the total number of groups divided by the number of
#'   teams.
#' @param method One of c("greedy","MILP") indicating whether a greedy
#'   algorithm or a mixed integer linear programming routine should be used
#'   to estimate the team assignments. The latter is more optimal but the
#'   former is more memory efficient.
#' @export
GenerateBalancedTeams <- function(group_id,
                                  group_score,
                                  num_teams,
                                  max_num_team =
                                    ceiling(length(group_id) / num_teams),
                                  method = "greedy") {

  stopifnot(length(group_id) == length(group_score))
  stopifnot(method %in% c("greedy","MILP"), length(method) == 1)

  num_groups <- length(group_id)

  if(method == "greedy") {
    team_assignments <- GreedyTeams(group_id, group_score, num_teams,
                                    num_groups, max_num_team)
  } else {
    team_assignments <- MILPTeams(group_id, group_score, num_teams,
                                  num_groups, max_num_team)
  }

  return(team_assignments)
}
