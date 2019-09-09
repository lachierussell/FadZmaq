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


CREATE TABLE IF NOT EXISTS profile
(
    user_id  SERIAL      NOT NULL PRIMARY KEY,
    nickname VARCHAR(35) NOT NULL,
    bio      VARCHAR(400),
    dob      TIMESTAMP   NOT NULL,
    gender   CHAR,
    email    VARCHAR(255) UNIQUE,
    phone    VARCHAR UNIQUE
);

CREATE TABLE IF NOT EXISTS matches
(
    match_id SERIAL  NOT NULL
        CONSTRAINT matches_pk
            PRIMARY KEY,
    user_a   INTEGER NOT NULL REFERENCES profile (user_id),
    user_b   INTEGER NOT NULL REFERENCES profile (user_id),
    time     TIME,
    rating   BOOLEAN
);

CREATE TABLE IF NOT EXISTS votes
(
    time      TIME,
    vote      BOOLEAN,
    user_from INTEGER NOT NULL REFERENCES profile (user_id),
    user_to   INTEGER NOT NULL REFERENCES profile (user_id)
);

CREATE TABLE IF NOT EXISTS hobbies
(
    hobby_id SERIAL      NOT NULL PRIMARY KEY,
    name     VARCHAR(64) NOT NULL
);

CREATE TYPE HOBBY_SWAP AS ENUM ('share', 'discover');

CREATE TABLE IF NOT EXISTS user_hobbies
(
    user_id  INTEGER    NOT NULL REFERENCES profile (user_id),
    hobby_id INTEGER    NOT NULL REFERENCES hobbies (hobby_id),
    swap     HOBBY_SWAP NOT NULL
);


-- Inserting dummy values --
-- DOB IN USA (month/day/year)
INSERT INTO profile (bio, nickname, email, dob, gender, phone)
VALUES ('Avid rock climber and hiking enthusiast.', 'Lachie', 'Lachie@email.com', '4/09/1999', 'M', '0423199199');
INSERT INTO profile (bio, nickname, email, dob, gender, phone)
VALUES ('Casual cyclist looking for social rides.', 'John', 'John@email.com', '4/10/1999', 'M', '0423239199');
INSERT INTO profile (bio, nickname, email, dob, gender, phone)
VALUES ('Boating admirer', 'Smith', 'smith@email.com', '5/12/1970', 'M', '0413239199');
INSERT INTO profile (bio, nickname, email, dob, gender, phone)
VALUES ('Boxing champion', 'Judy', 'judy@email.com', '3/10/1980', 'F', '0404239188');

INSERT INTO hobbies (name) VALUES ('Boxing');
INSERT INTO hobbies (name) VALUES ('Boating');
INSERT INTO hobbies (name) VALUES ('Rock Climbing');
INSERT INTO hobbies (name) VALUES ('Hiking');
INSERT INTO hobbies (name) VALUES ('Golf');
INSERT INTO hobbies (name) VALUES ('Surfing');
INSERT INTO hobbies (name) VALUES ('Cycling');

INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES (1, 3, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES (1, 2, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES (1, 5, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES (2, 3, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES (1, 4, 'discover');
--
-- CREATE OR REPLACE FUNCTION match()
--     RETURNS TRIGGER AS
-- $BODY$
-- BEGIN
--     IF (
--         SELECT v.user_from, v.user_to
--         FROM votes v
--         WHERE v.user_to = NEW.user_from
--         AND
--
--
-- --         SELECT v1.user_from, v1.user_to
-- --         FROM votes v1
-- --             INNER JOIN votes v2
-- --                 ON v1.user_from = v2.user_to
-- --                 AND v2.user_from = v1.user_to
-- --         WHERE v2.vote = TRUE
-- --           AND v1.vote = TRUE
-- --     )
-- --     INSERT INTO matches (user_a, user_b)
-- --     SELECT m1.user_to, m1.user_from
-- --     FROM match_pair m1;
-- END;
-- $BODY$
--
-- CREATE TRIGGER body INSTEAD OF INSERT OR UPDATE ON votes
--     FOR EACH ROW EXECUTE FUNCTION match();

