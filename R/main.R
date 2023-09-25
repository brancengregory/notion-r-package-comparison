library(tidyverse)
library(pak)
library(GithubMetrics)

repo_names <- c(
  "cmcmaster1/notionr",
  "dmolitor/notionr",
  "Eflores89/notionR",
  "NoMoreMarking/nmmNotion",
  "seankross/nosh",
  "TongZhou2017/ttnotion"
)

repos <- tibble(
  name = repo_names
) |>
  mutate(
    dependencies = map(name, pkg_deps),
    commits = map(name, ~gh_commits_get(.x, days_back = 1825) |> unnest(cols = everything()))
  ) |>
  mutate(
    .after = name,
    n_dependencies = map_int(dependencies, nrow),
    n_commits = map_int(commits, nrow),
    n_authors = map_int(commits, ~.x |> pull(author) |> n_distinct()),
    latest_commit = map(commits, ~.x |> pull(datetime) |> max()) |>
      ymd_hms()
  ) |>
  arrange(
    desc(latest_commit)
  )

