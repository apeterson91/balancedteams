
#' Mixed Integer Linear Programming Teams Assignment
#' @param group_id Identifier for group.
#' @param group_score Score associated with group.
#' @param num_teams Number of teams to generate.
#' @param num_groups Number of groups included in group_id.
#' @param max_num_team Maximum number of groups / team.
#' @export
MILPTeams <- function(group_id, group_score, num_teams,
                      num_groups, max_num_team) {

  max_num_team <- rep(max_num_team, num_teams)

  requireNamespace("ROI.plugin.glpk")

  ## For R CMD CHECK
  x <- i <- j <- i_two <- j_two <- value <- id <- NULL

  model <- ompr::MIPModel() %>%
  ## binary variable 1 iff player i is assigned to team j
  ompr::add_variable(x[i, j], i = 1:num_groups, j = 1:num_teams,
                     type = "binary") %>%
  ## minimize the difference between team group_score
  ompr::set_objective(
    ompr::sum_over((group_score[i] * x[i, j]) -
                     (group_score[i_two] * x[i_two,j_two]),
                         i = 1:num_groups, j = 1:num_teams,
                         i_two = 1:num_groups, j_two = 1:num_teams),
    sense = "min") %>%
  # we cannot exceed the max capacity of a team
  ompr::add_constraint(ompr::sum_over(x[i, j], i = 1:num_groups) <=
                         max_num_team[j],
                       j = 1:num_teams) %>%
  # each player needs to be assigned to one team
  ompr::add_constraint(ompr::sum_over(x[i, j], j = 1:num_teams) == 1,
                       i = 1:num_groups)

  result <- ompr::solve_model(model, ompr.roi::with_ROI(solver = "glpk"))


  team_assignments <- result %>%
    ompr::get_solution(x[i, j]) %>%
    dplyr::as_tibble() %>%
    dplyr::filter(value == 1) %>%
    dplyr::transmute(group_id = group_id[i],
                     team_id = j,
                     score = group_score[i])
}
