
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="docs/figure/balanceteams_hex.png" align="right" width=250 height=200 /> balancedteams

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The balancedteams R package offers a suite of methods — currently two —
including a greedy heuristic algorithm as well as a [mixed integer
linear programming](https://en.wikipedia.org/wiki/Integer_programming)
algorithm (Schumacher 2022) that creates a “balanced” set of team
assignments according to player scores and, optionally, accounting for a
strata indicator. There are a number of ways to come up with this score
but common methods used by our collaborators include an average of a
self-survey and/or a captain’s assessment of a player’s athleticism.

## Installation

You can install the development version of balancedteams from
[github](https://github.com/apeterson91/balancedteams) with:

``` r
devtools::install_github("apeterson91/balancedteams)
```

## Example

This is a basic example which shows you the basic input and output data
structures as well as the package syntax.

``` r
library(balancedteams)
library(dplyr)
```

``` r
head(mens_team)
#>   group_id player_id num_players player_score
#> 1        1         1           1     33.33851
#> 2        2         2           1     60.36581
#> 3        3         3           1     44.16801
#> 4        4         4           1     53.94389
#> 5        5         5           1     56.59137
#> 6        6         6           1     42.08316
```

``` r
team_config_one <- GenerateBalancedTeams(mens_team, 
                                         num_teams = 7,
                                         max_num_team = 11,
                                         method = "greedy")
GetMeanScore(team_config_one)
#> # A tibble: 7 × 4
#>   team_id `Mean Score` `Median Score` `# Players`
#>     <int>        <dbl>          <dbl>       <int>
#> 1       1         44.2           42.1          11
#> 2       2         48.2           45.8          11
#> 3       3         54.0           52.8          11
#> 4       4         40.0           37.1          11
#> 5       5         51.6           49.7          11
#> 6       6         51.1           48.1          11
#> 7       7         56.1           56.2          11
```

## Code of Conduct

Please note that the balancedteams project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-ompr" class="csl-entry">

Schumacher, Dirk. 2022. *Ompr: Model and Solve Mixed Integer Linear
Programs*. <https://github.com/dirkschumacher/ompr>.

</div>

</div>
