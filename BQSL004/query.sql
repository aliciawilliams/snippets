#standardSQL
WITH matchups AS (
SELECT g.win_team_id
  , g.lose_team_id
  , (SELECT win_masc.tax_family FROM `basketball.mascots` win_masc WHERE win_masc.id = g.win_team_id) AS tax_family_winner
  , (SELECT win_masc.tax_genus FROM `basketball.mascots` win_masc WHERE win_masc.id = g.win_team_id) AS tax_genus_winner
  , (SELECT lose_masc.tax_family FROM `basketball.mascots` lose_masc WHERE lose_masc.id = g.lose_team_id) AS tax_family_loser
  , (SELECT lose_masc.tax_genus FROM `basketball.mascots` lose_masc WHERE lose_masc.id = g.lose_team_id) AS tax_genus_loser
FROM `bigquery-public-data.ncaa_basketball.mbb_historical_tournament_games` g
)
SELECT
  SUM(IF(tax_family_winner = "Felidae" AND tax_genus_loser = "Canis", 1, 0)) AS num_cat_wins,
  SUM(IF(tax_genus_winner = "Canis" AND tax_family_loser = "Felidae", 1, 0)) AS num_dog_wins
FROM matchups
