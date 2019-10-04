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
DROP TABLE IF EXISTS rating;
DROP TABLE IF EXISTS user_location;
DROP TABLE IF EXISTS location_data;
DROP TABLE IF EXISTS profile;
DROP TYPE IF EXISTS HOBBY_SWAP;

-- TODO reinstate this in sprint 3
-- DROP FUNCTION IF EXISTS match;

DROP TRIGGER IF EXISTS make_match ON votes;


CREATE TABLE IF NOT EXISTS profile
(
    user_id  VARCHAR      NOT NULL UNIQUE PRIMARY KEY,
    nickname VARCHAR(35)  NOT NULL,
    bio      VARCHAR(400) DEFAULT NULL,
    dob      TIMESTAMP    DEFAULT NULL,
    email    VARCHAR(255) UNIQUE NOT NULL,
    phone    VARCHAR      UNIQUE,
    photo    VARCHAR      DEFAULT NULL,
    distance INT          DEFAULT 20 NOT NULL
);

CREATE TABLE IF NOT EXISTS matches
(
    match_id SERIAL  NOT NULL CONSTRAINT matches_pk PRIMARY KEY,
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

CREATE TYPE HOBBY_SWAP AS ENUM ('share', 'discover', 'matched');

CREATE TABLE IF NOT EXISTS user_hobbies
(
    user_id  VARCHAR    NOT NULL REFERENCES profile (user_id),
    hobby_id INTEGER    NOT NULL REFERENCES hobbies (hobby_id),
    swap     HOBBY_SWAP NOT NULL
);

CREATE TABLE IF NOT EXISTS location_data
(
    location_id SERIAL NOT NULL UNIQUE PRIMARY KEY,
    lat         FLOAT NOT NULL,
    long        FLOAT NOT NULL
);

CREATE TABLE IF NOT EXISTS user_location
(
    user_id         VARCHAR NOT NULL REFERENCES profile (user_id),
    location_id     SERIAL NOT NULL REFERENCES location_data (location_id)
);

CREATE TABLE IF NOT EXISTS rating
(
    user_to     VARCHAR NOT NULL REFERENCES profile (user_id),
    user_from   VARCHAR NOT NULL REFERENCES profile (user_id),
    rating      BOOLEAN NOT NULL
);


--------------------------------------------
--  ----------------------------------------
--  FUNCTIONS
--  ----------------------------------------
--------------------------------------------


-- Trigger to form a match between two consenting users
CREATE OR REPLACE FUNCTION match()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS
$make_match$
BEGIN
    IF ( (
            SELECT v.user_from
            FROM votes v
            WHERE NEW.vote
              AND v.vote
              AND v.user_to = new.user_from
              AND new.user_to = v.user_from
         ) NOTNULL
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
    FOR EACH ROW EXECUTE PROCEDURE match();


--------------------------------------------
--  ----------------------------------------
--  Dummy Data
--  ----------------------------------------
--------------------------------------------

-- DOB IN USA (month/day/year)
INSERT INTO profile (bio, nickname, email, dob, phone, user_id, photo)
VALUES ('Avid rock climber and hiking enthusiast.', 'Lachie', 'Lachie@email.com', '1999-09-04', '0423199199', 'b026324c6904b2a9cb4b88d6d61c81d1',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/AV0A6306_Sean_Bean.jpg/468px-AV0A6306_Sean_Bean.jpg');

INSERT INTO profile (bio, nickname, email, dob, phone, user_id, photo)
VALUES ('Casual cyclist looking for social rides.', 'John', 'John@email.com', '1999-10-4', '0423239199', '26ab0db90d72e28ad0ba1e22ee510510',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Good_Omens_panel_at_NYCC_%2860841%29a.jpg/1024px-Good_Omens_panel_at_NYCC_%2860841%29a.jpg');

INSERT INTO profile (bio, nickname, email, dob, phone, user_id, photo)
VALUES ('Boating admirer', 'Smith', 'smith@email.com', '1970-12-5', '0413239199', '6d7fce9fee471194aa8b5b6e47267f03',
 'https://upload.wikimedia.org/wikipedia/commons/1/10/Rooney_Mara_at_The_Discovery_premiere_during_day_2' ||
 '_of_the_2017_Sundance_Film_Festival_at_Eccles_Center_Theatre_on_January_20%2C_2017_in_Park_City%2C_Utah_%2832088061480%29_%28cropped%29.jpg');

INSERT INTO profile (bio, nickname, email, dob, phone, user_id, photo)
VALUES ('Boxing champion', 'Judy', 'judy@email.com', '1980-10-3', '0404239188', '48a24b70a0b376535542b996af517398',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Jeffrey_Wright_by_Gage_Skidmore_3.jpg/800px-Jeffrey_Wright_by_Gage_Skidmore_3.jpg');

INSERT INTO profile (bio, nickname, email, dob, phone, user_id, photo)
VALUES ('I dont have hobbies but keen to find something new', 'Mike', 'mike@email.com', '1980-09-14', '0415239188', '1dcca23355272056f04fe8bf20edfce0',
 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/Sam_Neill_2010.jpg/435px-Sam_Neill_2010.jpg');

-- Inserting user data for ourselves --
INSERT INTO profile (user_id, nickname, bio, dob, email, phone, photo)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 'Lachie', 'Mountain biker but wanting to try out rock climbing!', '1999-09-14', 'lachie.russell@gmail.com',
        '04152122188', 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/Sam_Neill_2010.jpg/435px-Sam_Neill_2010.jpg');

INSERT INTO profile (user_id, nickname, bio, dob, email, phone, photo)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 'Jordan', 'Jordan has a background in graphic design and user experience. He ' ||
                                                  'will help with how the app looks, feels and overall use.',
        '1990-05-13', 'jordashrussell@gmail.com',
        '0400100300', 'https://www.russell-systems.cc/other/f75c35fbefffb759903f4de04fbc168eccaea0619b1f3611a2ee6f2872b397c7.jpg');

INSERT INTO profile (user_id, nickname, bio, dob, email, phone, photo)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 'Seharsh', 'Seharsh has developed a number of mobile apps and has the most' ||
                                                   ' front end experience of the team.  His experience puts him in ' ||
                                                   'the position to help with technical and design decisions relating ' ||
                                                   'to the mobile platform.'
                                                   , '1998-04-24', 'seharshs05@gmail.com',
        '0400100400', 'https://www.russell-systems.cc/other/3ef06fabbfa1be08fcd50dded3450258e357e08e8d75f0aa544ca69e7808ff3b.jpg');

INSERT INTO profile (user_id, nickname, bio, dob, email, phone, photo)
VALUES ('HJtnPGdccnbqsR1V0hWSJe9AWFx1', 'Thiren', 'Thiren is the primary contact point for the team, he will organise' ||
                                                  ' our meetings keep track of a technical queries and responses on ' ||
                                                  'behalf of the team.', '1998-09-8', '22239906@student.uwa.edu.au',
        '0400100500', 'https://www.russell-systems.cc/other/ceac483c49a4b8c2c03e4eb3b7e213b8746b996bb7dd30468e0ea6044710a648.jpg');


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

--------------------------------------------
--  ----------------------------------------
--  DUMMY USER DATA FOR THE TEAM
--  ----------------------------------------
--------------------------------------------

-- Lachie
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', '26ab0db90d72e28ad0ba1e22ee510510', now(), null);
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 'b026324c6904b2a9cb4b88d6d61c81d1', now(), null);
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 'OQezYUwFC2P2JOP81nicQR4qZRB3', now(), null);
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 'C0j9nlTcBaWXmNACgwtnNds0Q3A2', now(), null);
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 'HJtnPGdccnbqsR1V0hWSJe9AWFx1', now(), null);

INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 1, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 2, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 3, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 4, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 6, 'discover');

INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 4, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 5, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 6, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 1, 'share');

-- Jordan
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', '26ab0db90d72e28ad0ba1e22ee510510', now(), null);
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 'b026324c6904b2a9cb4b88d6d61c81d1', now(), null);
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 'TMnFU6BmQoV8kSMoYYGLJDu8qSy1', now(), null);
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 'C0j9nlTcBaWXmNACgwtnNds0Q3A2', now(), null);
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 'HJtnPGdccnbqsR1V0hWSJe9AWFx1', now(), null);

INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 2, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 6, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 3, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 4, 'discover');

INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 7, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 5, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 6, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 2, 'share');

-- Seharsh
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', '26ab0db90d72e28ad0ba1e22ee510510', now(), null);
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 'b026324c6904b2a9cb4b88d6d61c81d1', now(), null);
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 'TMnFU6BmQoV8kSMoYYGLJDu8qSy1', now(), null);
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 'OQezYUwFC2P2JOP81nicQR4qZRB3', now(), null);
INSERT INTO matches (user_a, user_b, time, rating)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 'HJtnPGdccnbqsR1V0hWSJe9AWFx1', now(), null);

INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 1, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 6, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 3, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 4, 'discover');

INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 1, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 5, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 6, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap) VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 2, 'share');

-- FAKE VOTES
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

INSERT INTO votes (time, vote, user_from, user_to) VALUES (now(), True,  'b026324c6904b2a9cb4b88d6d61c81d1', '26ab0db90d72e28ad0ba1e22ee510510'); -- Repeat match
INSERT INTO votes (time, vote, user_from, user_to) VALUES (now(), True,  '26ab0db90d72e28ad0ba1e22ee510510', 'b026324c6904b2a9cb4b88d6d61c81d1');