-- 1) статистика по командам с сокрытием id и набранных очков (только места)

CREATE OR REPLACE VIEW team_places AS
SELECT team_university, team_place, league_id
FROM football_women.team
JOIN football_women.league_teams ON team.team_id = league_teams.team_id
ORDER BY league_id, team_place;

SELECT *
FROM team_places;

-- 2)таблица Игроков с сокрытием серединных букв фамилии

CREATE OR REPLACE VIEW people_view AS
SELECT player.player_id, substring(player_nm, 1, 2) || '****' || substring(player_nm, length(player_nm)-5, length(player_nm)) AS name_hidden,
       player_amplua, player_age, player_goals_cnt, team_university
FROM football_women.player
JOIN football_women.team_players ON player.player_id = team_players.player_id
JOIN football_women.team t on t.team_id = team_players.team_id
ORDER BY team_university;

SELECT *
FROM people_view;

--3)вывести всю информацию об играх (в том числе команды) по высшей лиге

CREATE OR REPLACE VIEW dublicate_team AS
SELECT * FROM football_women.team;

ALTER VIEW dublicate_team RENAME COLUMN team_university TO team2_university;

CREATE OR REPLACE VIEW high_league_team AS
SELECT game.game_id, game.gate_dttm, game.game_place, game.game_score,  first_t.team_university, team1_points, dublicate_team.team2_university, team2_points
FROM football_women.game
JOIN football_women.game_teams gt ON game.game_id = gt.game_id
JOIN football_women.team first_t ON gt.team1_id = first_t.team_id
JOIN dublicate_team ON gt.team2_id = dublicate_team.team_id
JOIN football_women.league_teams ON first_t.team_id = league_teams.team_id
WHERE league_id = 1 OR league_id = 2;

SELECT *
FROM high_league_team;

--4)вся информация об играх команды физтех

CREATE OR REPLACE VIEW phystech_stats AS
SELECT *
FROM high_league_teams
WHERE team_university = 'МФТИ (ГУ)'  OR team2_university = 'МФТИ (ГУ)'
ORDER BY gate_dttm;

--5)процент выигрышей и проигрышей по всем командам высшей лиги

CREATE OR REPLACE VIEW A AS
SELECT team_university AS name1, team1_points AS score1
FROM high_league_team;

CREATE OR REPLACE VIEW B AS
SELECT team2_university AS name2, team2_points AS score2
FROM high_league_team;

CREATE OR REPLACE VIEW all_stats AS
SELECT A.name1 AS name,
CASE WHEN A.score1 = 3 then 1
    WHEN A.score1 = 0 then 0
    END AS score
FROM A
UNION ALL
SELECT name2,
       CASE WHEN B.score2 = 3 then 1
    WHEN B.score2 = 0 then 0
    END AS score
FROM B;

SELECT name, sum(score) *100 / count(score) AS success_prc
FROM all_stats
GROUP BY name;

CREATE OR REPLACE VIEW success_prcnt AS
SELECT team_university, player_nm, player_goals_cnt,
       sum(player_goals_cnt) OVER (PARTITION BY team_university) AS team_ttl_goals,
       player_goals_cnt  * 100 / sum(player_goals_cnt) OVER (PARTITION BY team_university) AS goals_prc
FROM football_women.player
JOIN football_women.team_players ON team_players.player_id = player.player_id
JOIN football_women.team ON team.team_id = team_players.team_id;

--6)для каждого тренера вывести информацию - кол-во очков его команды, место в лиге, какая лига

CREATE OR REPLACE VIEW coach_stats AS
SELECT player_nm, t2.team_university, t2.team_points, t2.team_place, league_nm
FROM football_women.player
JOIN football_women.team_players ON player.player_id = team_players.player_id
JOIN football_women.team t ON team_players.team_id = t.team_id
JOIN football_women.team t2 ON t2.team_id = team_players.team_id
JOIN football_women.league_teams ON t.team_id = league_teams.team_id
JOIN football_women.league l ON league_teams.league_id = l.league_id
WHERE player_amplua = 'тренер'
ORDER BY player_nm;

SELECT *
FROM coach_stats;
