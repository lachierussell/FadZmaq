-- @file
-- @brief        Database schema script.
-- database/init.sql
--
-- FadZmaq Project
-- Professional Computing. Semester 2 2019
--
-- This script builds our database schema and uploads it with dummy values.
--
-- Copyright FadZmaq © 2019      All rights reserved.
-- @author Thiren Naidoo         22257963@student.uwa.edu.au
-- @author Lachlan Russell       22414249@student.uwa.edu.au


DROP TABLE IF EXISTS user_hobbies;
DROP TABLE IF EXISTS matches;
DROP VIEW IF EXISTS matches_v;
DROP TABLE IF EXISTS votes;
DROP TABLE IF EXISTS hobbies;
DROP TABLE IF EXISTS profile;
DROP TABLE IF EXISTS primary_user;
DROP TYPE IF EXISTS HOBBY_SWAP;
DROP FUNCTION IF EXISTS match;
DROP TRIGGER IF EXISTS make_match ON votes;


CREATE TABLE IF NOT EXISTS profile
(
    user_id  VARCHAR      NOT NULL UNIQUE PRIMARY KEY,
    nickname VARCHAR(35)  NOT NULL,
    bio      VARCHAR(400) DEFAULT NULL,
    dob      TIMESTAMP    DEFAULT NULL,
    email    VARCHAR(255) UNIQUE NOT NULL,
    phone    VARCHAR      UNIQUE
);

CREATE TABLE IF NOT EXISTS matches
(
    match_id SERIAL  NOT NULL
        CONSTRAINT matches_pk
            PRIMARY KEY,
    user_a   VARCHAR NOT NULL REFERENCES profile (user_id),
    user_b   VARCHAR NOT NULL REFERENCES profile (user_id),
    time     TIME,
    rating   BOOLEAN
);

CREATE TABLE IF NOT EXISTS votes
(
    time      TIME,
    vote      BOOLEAN,
    user_from VARCHAR NOT NULL REFERENCES profile (user_id),
    user_to   VARCHAR NOT NULL REFERENCES profile (user_id)
);

CREATE TABLE IF NOT EXISTS hobbies
(
    hobby_id SERIAL      NOT NULL PRIMARY KEY,
    name     VARCHAR(64) NOT NULL
);

CREATE TYPE HOBBY_SWAP AS ENUM ('share', 'discover');

CREATE TABLE IF NOT EXISTS user_hobbies
(
    user_id  VARCHAR    NOT NULL REFERENCES profile (user_id),
    hobby_id INTEGER    NOT NULL REFERENCES hobbies (hobby_id),
    swap     HOBBY_SWAP NOT NULL
);


-- Inserting dummy values --
-- DOB IN USA (month/day/year)
INSERT INTO profile (bio, nickname, email, dob, phone, user_id)
VALUES ('Avid rock climber and hiking enthusiast.', 'Lachie', 'Lachie@email.com', '4/09/1999', '0423199199', 'b026324c6904b2a9cb4b88d6d61c81d1');
INSERT INTO profile (bio, nickname, email, dob, phone, user_id)
VALUES ('Casual cyclist looking for social rides.', 'John', 'John@email.com', '4/10/1999', '0423239199', '26ab0db90d72e28ad0ba1e22ee510510');
INSERT INTO profile (bio, nickname, email, dob, phone, user_id)
VALUES ('Boating admirer', 'Smith', 'smith@email.com', '5/12/1970', '0413239199', '6d7fce9fee471194aa8b5b6e47267f03');
INSERT INTO profile (bio, nickname, email, dob, phone, user_id)
VALUES ('Boxing champion', 'Judy', 'judy@email.com', '3/10/1980', '0404239188', '48a24b70a0b376535542b996af517398');
INSERT INTO profile (bio, nickname, email, dob, phone, user_id)
VALUES ('I dont have hobbies but keen to find something new', 'Mike', 'mike@email.com', '9/14/1980', '0415239188', '1dcca23355272056f04fe8bf20edfce0');

INSERT INTO hobbies (name) VALUES ('Boxing');
INSERT INTO hobbies (name) VALUES ('Boating');
INSERT INTO hobbies (name) VALUES ('Rock Climbing');
INSERT INTO hobbies (name) VALUES ('Hiking');
INSERT INTO hobbies (name) VALUES ('Golf');
INSERT INTO hobbies (name) VALUES ('Surfing');
INSERT INTO hobbies (name) VALUES ('Cycling');

INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('b026324c6904b2a9cb4b88d6d61c81d1', 3, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('b026324c6904b2a9cb4b88d6d61c81d1', 2, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('b026324c6904b2a9cb4b88d6d61c81d1', 5, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('26ab0db90d72e28ad0ba1e22ee510510', 3, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('b026324c6904b2a9cb4b88d6d61c81d1', 4, 'discover');

-- Test data for matches (John has three, a few others have one with him)
INSERT INTO matches (user_a, user_b)
VALUES ('26ab0db90d72e28ad0ba1e22ee510510', '6d7fce9fee471194aa8b5b6e47267f03');
INSERT INTO matches (user_a, user_b)
VALUES ('26ab0db90d72e28ad0ba1e22ee510510', 'b026324c6904b2a9cb4b88d6d61c81d1');
INSERT INTO matches (user_a, user_b)
VALUES ('26ab0db90d72e28ad0ba1e22ee510510', '48a24b70a0b376535542b996af517398');


CREATE OR REPLACE FUNCTION match()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS
$make_match$
BEGIN
    IF (
        SELECT v.user_from
        FROM votes v
        WHERE NEW.vote
          AND v.vote
          AND v.user_to = new.user_from
          AND new.user_to = v.user_from
    ) THEN
        INSERT INTO matches (user_a, user_b, time, rating)
          VALUES (NEW.user_from, NEW.user_to, now(), null);
        DELETE FROM votes WHERE user_to = NEW.user_from;
        RETURN NULL;
    END IF;
    RETURN NEW;
END;
$make_match$;

CREATE TRIGGER make_match BEFORE INSERT OR UPDATE ON votes
    FOR EACH ROW EXECUTE FUNCTION match();


INSERT INTO votes (time, vote, user_from, user_to) VALUES (now(), True,  'b026324c6904b2a9cb4b88d6d61c81d1', '26ab0db90d72e28ad0ba1e22ee510510');
INSERT INTO votes (time, vote, user_from, user_to) VALUES (now(), True,  '26ab0db90d72e28ad0ba1e22ee510510', 'b026324c6904b2a9cb4b88d6d61c81d1');
INSERT INTO votes (time, vote, user_from, user_to) VALUES (now(), True,  '6d7fce9fee471194aa8b5b6e47267f03', '48a24b70a0b376535542b996af517398');
INSERT INTO votes (time, vote, user_from, user_to) VALUES (now(), True,  'b026324c6904b2a9cb4b88d6d61c81d1', '48a24b70a0b376535542b996af517398');
INSERT INTO votes (time, vote, user_from, user_to) VALUES (now(), False, 'b026324c6904b2a9cb4b88d6d61c81d1', '6d7fce9fee471194aa8b5b6e47267f03');
INSERT INTO votes (time, vote, user_from, user_to) VALUES (now(), True,  '48a24b70a0b376535542b996af517398', 'b026324c6904b2a9cb4b88d6d61c81d1');
INSERT INTO votes (time, vote, user_from, user_to) VALUES (now(), True,  '6d7fce9fee471194aa8b5b6e47267f03', '26ab0db90d72e28ad0ba1e22ee510510');
INSERT INTO votes (time, vote, user_from, user_to) VALUES (now(), True,  '48a24b70a0b376535542b996af517398', '6d7fce9fee471194aa8b5b6e47267f03');
INSERT INTO votes (time, vote, user_from, user_to) VALUES (now(), True,  '6d7fce9fee471194aa8b5b6e47267f03', '48a24b70a0b376535542b996af517398');
INSERT INTO votes (time, vote, user_from, user_to) VALUES (now(), True,  '6d7fce9fee471194aa8b5b6e47267f03', 'b026324c6904b2a9cb4b88d6d61c81d1');
