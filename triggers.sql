CREATE OR REPLACE FUNCTION update_player_info() RETURNS TRIGGER AS $$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            DELETE  FROM football_women.player_history WHERE player_id = OLD.player_id;
            IF NOT FOUND THEN RETURN NULL; END IF;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO football_women.player_history VALUES(OLD.player_id,
                                                             OLD.player_nm,
                                                             OLD.player_amplua,
                                                             OLD.player_age,
                                                             OLD.player_goals_cnt,
                                                             CURRENT_DATE);
            RETURN NEW;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER players_update
    BEFORE UPDATE OR DELETE ON football_women.player
    FOR EACH ROW
    EXECUTE PROCEDURE update_player_info();


UPDATE football_women.player
SET player_goals_cnt = player_goals_cnt + 1
WHERE player_id = 403;


CREATE OR REPLACE FUNCTION check_same_league() RETURNS TRIGGER AS $$
    DECLARE
    league1 INT;
    league2 INT;
    BEGIN
        EXECUTE 'SELECT league_id FROM football_women.league_teams WHERE team_id = $1'
        INTO league1
        USING NEW.team1_id;

        EXECUTE 'SELECT league_id FROM football_women.league_teams WHERE team_id = $1'
        INTO league2
        USING NEW.team2_id;

        IF (league1 = league2) THEN
            RETURN NEW;
        ELSE
            RETURN NULL;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_teams
    BEFORE INSERT ON football_women.game_teams
    FOR EACH ROW
    EXECUTE PROCEDURE check_same_league();

INSERT INTO football_women.game_teams VALUES(23, 2, 3, 3, 0);
