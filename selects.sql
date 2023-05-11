SELECT team_university, MAX(player_goals_cnt) AS goals
FROM football_women.player
JOIN football_women.team_players ON team_players.player_id = player.player_id
JOIN football_women.team ON team.team_id = team_players.team_id
GROUP BY team_university
HAVING MAX(player_goals_cnt) > 20
ORDER BY MAX(player_goals_cnt) DESC;

SELECT team_university, player_nm, player_goals_cnt,
       sum(player_goals_cnt) OVER (PARTITION BY team_university) AS team_ttl_goals,
       player_goals_cnt  * 100 / sum(player_goals_cnt) OVER (PARTITION BY team_university) AS goals_prc
FROM football_women.player
JOIN football_women.team_players ON team_players.player_id = player.player_id
JOIN football_women.team ON team.team_id = team_players.team_id;


SELECT  team_university, player_goals_cnt,
        sum(player_goals_cnt) OVER (ORDER BY team_university) AS cumul_sum_goals
FROM football_women.player
JOIN football_women.team_players ON team_players.player_id = player.player_id
JOIN football_women.team ON team.team_id = team_players.team_id
WHERE team.team_id < 16;

SELECT DISTINCT team_university, league_id, team_points,
        AVG(player_age) OVER (PARTITION BY league_id ORDER BY team_points)
FROM football_women.player
JOIN football_women.team_players ON team_players.player_id = player.player_id
JOIN football_women.team ON team.team_id = team_players.team_id
JOIN football_women.league_teams ON league_teams.team_id = team.team_id;


SELECT game.game_id,
    ROW_NUMBER()
    OVER (ORDER BY league_id) AS "row number",
    RANK()
    OVER (ORDER BY league_id) AS "rank",
    DENSE_RANK()
    OVER (ORDER BY league_id) AS "dense rank"
FROM football_women.game
JOIN football_women.game_teams ON game_teams.game_id = game.game_id
JOIN football_women.league_teams ON league_teams.team_id = game_teams.team1_id;


SELECT team.team_id, league_teams.league_id, team_points,
       LAG(team_points, 1, 0) OVER (ORDER BY league_id) AS prev_place,
       LEAD(team_points, 1, 0) OVER (ORDER BY league_id) AS next_place
FROM football_women.team
JOIN football_women.league_teams ON team.team_id = league_teams.team_id;
