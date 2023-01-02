
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="docs/figure/balanceteams_hex.png" align="right" width=250 height=200 /> balancedteams

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The balancedteams R package (currently) uses a greedy algorithm that
takes a player or group (for players that baggage together) score and
assigns the “best” group to the worst performing team, starting with
some random initialization of the teams. There are a number of ways to
come up with this score but common methods used by our collaborators
include an average of a self-survey and/or a captain’s assessment of a
player’s athleticism.

## Installation

You can install the development version of balancedteams from
[github](https://github.com/apeterson91/balancedteams) with:

``` r
devtools::install_github("apeterson91/balancedteams)
```

## Example

This is a basic example which shows you generate teams.

``` r
library(balancedteams)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

``` r
head(mens_team)
#>   group_id group_score
#> 1        1    52.58307
#> 2        2    56.81345
#> 3        3    45.01116
#> 4        4    62.80059
#> 5        5    43.71553
#> 6        6    39.33750
```

``` r
team_config_one <- GenerateBalancedTeams(mens_team$group_id, 
                                         mens_team$group_score,
                                         num_teams = 7)
GetMeanScore(team_config_one)
#> # A tibble: 7 × 3
#>   team_id `Mean Score` `# Groups`
#>     <int>        <dbl>      <int>
#> 1       1         51.4         11
#> 2       2         52.0         11
#> 3       3         58.0         11
#> 4       4         56.0         11
#> 5       5         45.2         11
#> 6       6         37.9         11
#> 7       7         50.2         11
```

## Code of Conduct

Please note that the balancedteams project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
