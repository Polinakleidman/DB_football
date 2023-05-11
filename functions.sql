CREATE OR REPLACE FUNCTION day_diff (game1_id integer, game2_id integer) RETURNS integer AS $$
DECLARE
    dttm1 DATE;
    dttm2 DATE;
BEGIN
    EXECUTE 'SELECT gate_dttm FROM football_women.game WHERE game_id = $1'
    INTO dttm1
    USING game1_id;

    EXECUTE 'SELECT gate_dttm FROM football_women.game WHERE game_id = $1'
    INTO dttm2
    USING game2_id;

    RETURN (dttm1 - dttm2);
END;
$$ LANGUAGE plpgsql;

SELECT day_diff(1, 2) AS answer;

CREATE EXTENSION plpython3u;

CREATE OR REPLACE FUNCTION right_num(t TEXT)
RETURNS INTEGER AS $$
    return int(t.split(':')[1])
$$ LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION left_num(t TEXT)
RETURNS INTEGER AS $$
    return int(t.split(':')[0])
$$ LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION missed_goals (team integer) RETURNS integer AS $$
DECLARE
    goals_right INT;
    goals_left INT;
BEGIN
    EXECUTE 'SELECT sum(left_num(game_score)) FROM football_women.game_teams JOIN football_women.game ON game.game_id = game_teams.game_id WHERE team2_id = $1'
    INTO goals_left
    USING team;

    EXECUTE 'SELECT sum(right_num(game_score)) FROM football_women.game_teams JOIN football_women.game ON game.game_id = game_teams.game_id WHERE team1_id = $1'
    INTO goals_right
    USING team;

    RETURN (goals_left + goals_right);
END;
$$ LANGUAGE plpgsql;

SELECT missed_goals(19) AS answer;
