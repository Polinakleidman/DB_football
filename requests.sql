SELECT *
FROM football_women.player
WHERE football_women.player.player_goals_cnt > 10
ORDER BY football_women.player.player_goals_cnt DESC;

SELECT *
FROM football_women.player
WHERE player_amplua = 'тренер'
ORDER BY player_nm;

SELECT player_nm, team_university
FROM football_women.player
JOIN football_women.team_players ON team_players.player_id = player.player_id
JOIN football_women.team ON team.team_id = team_players.team_id
WHERE team.team_university = 'МФТИ (ГУ)';

SELECT sum(football_women.player.player_goals_cnt) as goals_per_team, team_university
FROM football_women.player
JOIN football_women.team_players ON team_players.player_id = player.player_id
JOIN football_women.team ON team.team_id = team_players.team_id
GROUP BY team.team_university
ORDER BY goals_per_team DESC;

UPDATE football_women.player
SET player_goals_cnt = player_goals_cnt + 1
WHERE player_nm = 'Акинина Анна';

UPDATE football_women.player
SET player_goals_cnt = player_goals_cnt + 1
WHERE player_nm = 'Бодрова Марина';

UPDATE football_women.player
SET player_goals_cnt = player_goals_cnt + 1
WHERE player_nm = 'Мыльникова Ольга';

UPDATE football_women.player
SET player_goals_cnt = player_goals_cnt + 2
WHERE player_nm = 'Важенкова Екатерина';

DELETE
FROM football_women.team_players
WHERE player_id = 23;

DELETE
FROM football_women.player
WHERE player_id = 23;

INSERT INTO football_women.player VALUES (23, 'Досманова Виолетта', 'нападающий', 19, 0);
INSERT INTO football_women.team_players VALUES (9, 23);
