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
-- @author Lachlan Russell       22414249@student.uwa.edu.au
-- @author Jordan Russell        jordanrussell@live.com
-- @author Thiren Naidoo         22257963@student.uwa.edu.au


DROP TABLE IF EXISTS user_hobbies;
DROP TABLE IF EXISTS matches;
DROP VIEW IF EXISTS matches_v;
DROP TABLE IF EXISTS votes;
DROP TABLE IF EXISTS hobbies;
DROP TABLE IF EXISTS rating;
DROP TABLE IF EXISTS location_data;
DROP TABLE IF EXISTS profile CASCADE;
DROP TYPE IF EXISTS HOBBY_SWAP;

DROP TRIGGER IF EXISTS make_match ON votes;
DROP FUNCTION IF EXISTS rate_user;
DROP FUNCTION IF EXISTS match;


CREATE TABLE IF NOT EXISTS profile
(
    user_id          VARCHAR                 NOT NULL UNIQUE PRIMARY KEY,
    nickname         VARCHAR(35)             NOT NULL,
    bio              VARCHAR(400) DEFAULT NULL,
    dob              TIMESTAMP    DEFAULT NULL,
    email            VARCHAR(255) UNIQUE     NOT NULL,
    phone            VARCHAR UNIQUE,
    photo            VARCHAR      DEFAULT NULL,
    distance_setting INT          DEFAULT 20 NOT NULL
);

CREATE TABLE IF NOT EXISTS matches
(
    match_id SERIAL  NOT NULL
        CONSTRAINT matches_pk PRIMARY KEY,
    user_a   VARCHAR NOT NULL REFERENCES profile (user_id) ON DELETE CASCADE,
    user_b   VARCHAR NOT NULL REFERENCES profile (user_id) ON DELETE CASCADE,
    time     TIME,
    unmatch  BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS votes
(
    time      TIME,
    vote      BOOLEAN,
    user_from VARCHAR NOT NULL REFERENCES profile (user_id) ON DELETE CASCADE,
    user_to   VARCHAR NOT NULL REFERENCES profile (user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS hobbies
(
    hobby_id SERIAL      NOT NULL PRIMARY KEY,
    name     VARCHAR(64) NOT NULL
);

CREATE TYPE HOBBY_SWAP AS ENUM ('share', 'discover', 'matched');

CREATE TABLE IF NOT EXISTS user_hobbies
(
    user_id  VARCHAR    NOT NULL REFERENCES profile (user_id) ON DELETE CASCADE,
    hobby_id INTEGER    NOT NULL REFERENCES hobbies (hobby_id) ON DELETE CASCADE,
    swap     HOBBY_SWAP NOT NULL
);

CREATE TABLE IF NOT EXISTS location_data
(
    device_id VARCHAR DEFAULT NULL,
    user_id   VARCHAR NOT NULL REFERENCES profile (user_id) ON DELETE CASCADE,
    lat       FLOAT   NOT NULL,
    long      FLOAT   NOT NULL,
    ping_time TIME DEFAULT now()
);

CREATE TABLE IF NOT EXISTS rating
(
    user_to    VARCHAR NOT NULL REFERENCES profile (user_id) ON DELETE CASCADE,
    user_from  VARCHAR NOT NULL REFERENCES profile (user_id) ON DELETE CASCADE,
    rate_value INT     NOT NULL
);

--------------------------------------------
--  ----------------------------------------
--  FUNCTIONS
--  ----------------------------------------
--------------------------------------------

-- @brief Trigger which matches two uses when mutual votes exist.
CREATE OR REPLACE FUNCTION match()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$make_match$
BEGIN
    IF ((
        SELECT v.user_from
        FROM votes v
        WHERE new.vote
          AND v.vote
          AND v.user_to = new.user_from
          AND new.user_to = v.user_from
        LIMIT 1
    ) NOTNULL
        ) THEN
        INSERT INTO matches (user_a, user_b, time)
        VALUES (new.user_from, new.user_to, now());
        DELETE FROM votes WHERE user_to = new.user_from
        AND user_from = new.user_to;
        DELETE FROM votes WHERE user_to = new.user_to
        AND user_from = new.user_from;
        RETURN NULL;
    END IF;
    RETURN new;
END;
$make_match$;

-- @brief Activates the match() trigger.
CREATE TRIGGER make_match
    BEFORE INSERT OR UPDATE
    ON votes
    FOR EACH ROW
EXECUTE PROCEDURE match();


-- @brief Creates a trigger that prevents duplicate and conflicting ratings on a user.
CREATE OR REPLACE FUNCTION rate_user()
    RETURNS TRIGGER
    LANGUAGE plpgsql AS
$rate$
BEGIN
    IF (
        SELECT user_a
        FROM matches
        WHERE user_a = new.user_from
            AND user_b = new.user_to
           OR user_a = new.user_to
            AND user_b = new.user_from
        LIMIT 1
    ) IS NULL
    THEN
        RETURN NULL;
    END IF;
    IF (
        (SELECT rt.user_from
         FROM rating rt
         WHERE rt.user_from = new.user_from
           AND rt.user_to = new.user_to
         LIMIT 1
        ) IS NOT NULL
        ) THEN
        UPDATE rating
        SET rate_value=new.rate_value
        WHERE user_from = new.user_from
          AND user_to = new.user_to;
        RETURN NULL;
    END IF;
    RETURN new;
END;
$rate$;

-- @brief Activates rating trigger.
CREATE TRIGGER rate
    BEFORE INSERT
    ON rating
    FOR EACH ROW
EXECUTE PROCEDURE rate_user();


-- @brief Calculates user compatibility.
-- Using the average rating score it calculates the difference between users.
-- This simulates the elo rating system.
CREATE OR REPLACE FUNCTION compatible_rating(from_user VARCHAR)
    RETURNS TABLE
            (
                user_id VARCHAR,
                rank    FLOAT
            )
AS
$compatible_rating$
SELECT user_to,
       their_rank -
       (
           SELECT AVG(rate_value :: FLOAT) my_rank
           FROM rating
           WHERE user_to = from_user
           GROUP BY user_to
       ) rank
FROM (
         SELECT user_to, AVG(rate_value :: FLOAT) their_rank
         FROM rating
         GROUP BY user_to
     ) not_me
ORDER BY rank DESC;
$compatible_rating$
    LANGUAGE SQL;


-- -- @brief Calculates hobby compatibility between two users.
-- -- Count number of hobbies for filtering / compatibility score
-- CREATE OR REPLACE FUNCTION compatibility(from_user VARCHAR)
--     RETURNS TABLE
--             (
--                 user_id VARCHAR,
--                 compat  BIGINT
--             )
-- AS
-- $compatability_score$
-- SELECT DISTINCT(user_id),
--                (
--                    SELECT COUNT(me.hobby_id) compat
--                    FROM user_hobbies me
--                             INNER JOIN user_hobbies you
--                                        ON me.hobby_id = you.hobby_id
--                                            AND me.swap != you.swap
--                    WHERE me.user_id = from_user
--                      AND you.user_id = user_hobbies.user_id
--                ) compat
-- FROM user_hobbies
-- WHERE user_id != from_user
-- ORDER BY compat DESC;
-- $compatability_score$
--     LANGUAGE SQL;

-- @brief Calculates hobby compatibility between two users.
-- Count number of hobbies for filtering / compatibility score
CREATE OR REPLACE FUNCTION compatibility(from_user VARCHAR)
    RETURNS TABLE
            (
                user_id VARCHAR,
                compat  BIGINT
            )
AS
$compatability_score$
SELECT  coalesce(my_share.user_id, my_discover.user_id) as user_id,
        coalesce(count_share, 0) * coalesce(count_discover,0) * 2 + coalesce(count_share, 0) + coalesce(count_discover,0) + coalesce(vote_count * 4,0) AS compat
FROM (
	SELECT user_id, Count(user_id) AS count_share
	FROM user_hobbies
	WHERE hobby_id IN (
			SELECT hobby_id
			FROM user_hobbies
			WHERE user_id = from_user
				AND swap = 'share'
			)
		AND swap = 'discover'
	GROUP BY user_id
	) my_share
FULL OUTER JOIN (
	SELECT user_id, Count(user_id) AS count_discover
	FROM user_hobbies 
	WHERE hobby_id IN (
			SELECT hobby_id
			FROM user_hobbies
			WHERE user_id = from_user
				AND swap = 'discover'
			)
		AND swap = 'share'
	GROUP BY user_id
	) my_discover
ON (my_share.user_id = my_discover.user_id)
LEFT JOIN (
	SELECT user_from, count(user_to) as vote_count
	FROM votes
	WHERE user_to = from_user
	GROUP BY user_from
	)votes_for_me
ON (coalesce(my_share.user_id, my_discover.user_id) = user_from)
ORDER BY compat DESC
$compatability_score$
    LANGUAGE SQL;


-- @brief Calculates the distance between two users.
-- Adapted from code by: Kirill Bekus
-- GeoDataSource.com (C) All Rights Reserved 2019
-- https://www.geodatasource.com/developers/postgresql
CREATE OR REPLACE FUNCTION calculate_distance(lat1 DOUBLE PRECISION, lon1 DOUBLE PRECISION,
                                              lat2 DOUBLE PRECISION, lon2 DOUBLE PRECISION)
    RETURNS FLOAT AS
$dist$
DECLARE
    dist     FLOAT = 0;
    radlat1  FLOAT;
    radlat2  FLOAT;
    theta    FLOAT;
    radtheta FLOAT;
BEGIN
    radlat1 = (pi() * lat1) / 180;
    radlat2 = (pi() * lat2) / 180;
    theta = lon1 - lon2;
    radtheta = (pi() * theta) / 180;
    dist = sin(radlat1) * sin(radlat2) + cos(radlat1) * cos(radlat2) * cos(radtheta);

    IF dist > 1 THEN dist = 1; END IF;

    dist = acos(dist);
    dist = dist * 180 / pi();
    dist = dist * 60 * 1.1515;

    dist = dist * 1.609344;
    -- dist = ROUND((dist / 5) :: numeric, 0) * 5; -- Round to nearest 5
    dist = ROUND((dist) :: numeric, 0) ; -- Round to nearest 1
    RETURN dist :: DOUBLE PRECISION;
END;
$dist$ LANGUAGE plpgsql;


-- @brief Builds a table of distance values between users.
-- This uses the calculate_distance function to build up a table of approximate distance between users
-- so that this can be used by the matching algorithm.
CREATE OR REPLACE FUNCTION distance_table(from_user VARCHAR)
    RETURNS TABLE
            (
                user_id  VARCHAR,
                distance DOUBLE PRECISION
            )
AS
$distances$
SELECT DISTINCT(user_id), distance
FROM (
         SELECT geo_tables.user_id,
                        calculate_distance(geo_tables.ml,
                                           geo_tables.mlo,
                                           geo_tables.lat,
                                           geo_tables.long
                            ) :: DOUBLE PRECISION AS distance
         FROM (
                  SELECT user_id,
                         lat,
                         long,
                         (
                             SELECT lat
                             FROM location_data
                             WHERE user_id = from_user
                             ORDER BY ping_time DESC
                             LIMIT 1
                         ) ml,
                         (
                             SELECT long
                             FROM location_data
                             WHERE user_id = from_user
                             ORDER BY ping_time DESC
                         ) mlo
                  FROM location_data
                  ORDER BY ping_time DESC
              ) geo_tables
     ) distance_tables
WHERE distance_tables.distance < (
    SELECT distance_setting
    FROM profile
    WHERE user_id = from_user
)
$distances$
    LANGUAGE SQL;


-- @brief Collates compatibility, ratings and distances of users into a single function for use by the server.
CREATE OR REPLACE FUNCTION matching_algorithm(from_user VARCHAR)
    RETURNS TABLE
            (
                user_id  VARCHAR,
                distance DOUBLE PRECISION,
                hobbies  BIGINT,
                score    DOUBLE PRECISION
            )
AS
$matching_algorithm$
SELECT DISTINCT(dt.user_id), dt.distance, hc.compat hobbies, rc.rank score
FROM distance_table(from_user) dt
         LEFT OUTER JOIN compatibility(from_user) hc
                    ON dt.user_id = hc.user_id
         LEFT OUTER JOIN compatible_rating(from_user) rc
                    ON dt.user_id = rc.user_id
WHERE dt.user_id NOT IN (
              SELECT user_to FROM votes WHERE user_from = from_user
              UNION
              SELECT user_a FROM matches WHERE user_b = from_user
              UNION
              SELECT user_b FROM matches WHERE user_a = from_user
              UNION
              SELECT user_id FROM profile where user_id = from_user
    )
$matching_algorithm$
    LANGUAGE SQL;


--------------------------------------------
--  ----------------------------------------
--  Dummy Data
--  ----------------------------------------
--------------------------------------------

-- DOB IN USA (month/day/year)
INSERT INTO profile (bio, nickname, email, dob, phone, user_id, photo)
VALUES ('Avid rock climber and hiking enthusiast.', 'Lachie', 'Lachie@email.com', '1999-09-04', '0423199199',
        'b026324c6904b2a9cb4b88d6d61c81d1',
        'https://upload.wikimedia.org/wikipedia/commons/c/ca/AV0A6306_Sean_Bean.jpg');

INSERT INTO profile (bio, nickname, email, dob, phone, user_id, photo)
VALUES ('Casual cyclist looking for social rides.', 'John', 'John@email.com', '1999-10-4', '0423239199',
        '26ab0db90d72e28ad0ba1e22ee510510',
        'https://upload.wikimedia.org/wikipedia/commons/9/9b/Good_Omens_panel_at_NYCC_%2860841%29a.jpg');

INSERT INTO profile (bio, nickname, email, dob, phone, user_id, photo)
VALUES ('Boating admirer', 'Smith', 'smith@email.com', '1970-12-5', '0413239199', '6d7fce9fee471194aa8b5b6e47267f03',
        'https://upload.wikimedia.org/wikipedia/commons/8/89/Matt_Smith_by_Gage_Skidmore_2.jpg');

INSERT INTO profile (bio, nickname, email, dob, phone, user_id, photo)
VALUES ('Boxing champion', 'Judy', 'judy@email.com', '1980-10-3', '0404239188', '48a24b70a0b376535542b996af517398',
        'https://upload.wikimedia.org/wikipedia/commons/5/51/Jeffrey_Wright_by_Gage_Skidmore_3.jpg');

INSERT INTO profile (bio, nickname, email, dob, phone, user_id, photo)
VALUES ('I dont have hobbies but keen to find something new', 'Mike', 'mike@email.com', '1980-09-14', '0415239188',
        '1dcca23355272056f04fe8bf20edfce0',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/Sam_Neill_2010.jpg/435px-Sam_Neill_2010.jpg');

-- Inserting user data for ourselves --
INSERT INTO profile (user_id, nickname, bio, dob, email, phone, photo)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 'Lachie', 'Mountain biker but wanting to try out rock climbing!', '1999-09-14',
        'lachie.russell@gmail.com',
        '04152122188',
        'https://upload.wikimedia.org/wikipedia/commons/f/fd/Christopher_Plummer_2014.jpg');

INSERT INTO profile (user_id, nickname, bio, dob, email, phone, photo)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 'Jordan',
        'Jordan has a background in graphic design and user experience. He ' ||
        'will help with how the app looks, feels and overall use.',
        '1990-05-13', 'jordashrussell@gmail.com',
        '0400100300',
        'https://www.russell-systems.cc/other/f75c35fbefffb759903f4de04fbc168eccaea0619b1f3611a2ee6f2872b397c7.jpg');

INSERT INTO profile (user_id, nickname, bio, dob, email, phone, photo)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 'Seharsh', 'Seharsh has developed a number of mobile apps and has the most' ||
                                                   ' front end experience of the team.  His experience puts him in ' ||
                                                   'the position to help with technical and design decisions relating ' ||
                                                   'to the mobile platform.'
           , '1998-04-24', 'seharshs05@gmail.com',
        '0400100400',
        'https://www.russell-systems.cc/other/3ef06fabbfa1be08fcd50dded3450258e357e08e8d75f0aa544ca69e7808ff3b.jpg');

INSERT INTO profile (user_id, nickname, bio, dob, email, phone, photo)
VALUES ('HJtnPGdccnbqsR1V0hWSJe9AWFx1', 'Thiren',
        'Thiren is the primary contact point for the team, he will organise' ||
        ' our meetings keep track of a technical queries and responses on ' ||
        'behalf of the team.', '1998-09-8', '22239906@student.uwa.edu.au',
        '0400100500',
        'https://www.russell-systems.cc/other/ceac483c49a4b8c2c03e4eb3b7e213b8746b996bb7dd30468e0ea6044710a648.jpg');


-- INSERT INTO hobbies (name)
-- VALUES ('Boxing');
-- INSERT INTO hobbies (name)
-- VALUES ('Boating');
-- INSERT INTO hobbies (name)
-- VALUES ('Rock Climbing');
-- INSERT INTO hobbies (name)
-- VALUES ('Hiking');
-- INSERT INTO hobbies (name)
-- VALUES ('Golf');
-- INSERT INTO hobbies (name)
-- VALUES ('Surfing');
-- INSERT INTO hobbies (name)
-- VALUES ('Cycling');

INSERT INTO hobbies (name)
VALUES ('3D printing'), ('Board games'), ('Calligraphy'), ('Cooking'), ('Crocheting'), ('Cryptography'), ('Dance'), ('Drawing'),  ('Embroidery'), 
('Jewelry making'),  ('Juggling'),  ('Knitting'), ('Magic'), ('Painting'),  ('Pottery'), ('Quilting'), ('Sculpting'), ('Sewing'), ('Singing'), 
('Soapmaking'), ('Wood Carving'), ('Woodworking'), ('Writing'), ('Archery'), ('Astronomy'),  ('Baseball'), ('Basketball'), ('Beekeeping'), ('Bird watching'),
('Cycling'), ('Fishing'),('Gardening'), ('Hiking'), ('Inline skating'), ('Jogging'), ('Kayaking'), ('Kitesurfing'), ('Mountain biking'), ('Netball'),
('Paintball'), ('Parkour'), ('Photography'), ('Rock climbing'), ('Rugby'), ('Running'), ('Sailing'), ('Scuba diving'), ('Rowing'), ('Skateboarding'), ('Skiing'),
('Snowboarding'), ('Surfing'), ('Swimming'), ('Taekwondo'), ('Tai chi');

INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('b026324c6904b2a9cb4b88d6d61c81d1', 3, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('b026324c6904b2a9cb4b88d6d61c81d1', 2, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('b026324c6904b2a9cb4b88d6d61c81d1', 5, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('26ab0db90d72e28ad0ba1e22ee510510', 3, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('b026324c6904b2a9cb4b88d6d61c81d1', 4, 'discover');

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
INSERT INTO matches (user_a, user_b, time)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', '26ab0db90d72e28ad0ba1e22ee510510', now());
INSERT INTO matches (user_a, user_b, time)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 'b026324c6904b2a9cb4b88d6d61c81d1', now());
INSERT INTO matches (user_a, user_b, time)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 'OQezYUwFC2P2JOP81nicQR4qZRB3', now());
INSERT INTO matches (user_a, user_b, time)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 'C0j9nlTcBaWXmNACgwtnNds0Q3A2', now());
INSERT INTO matches (user_a, user_b, time)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 'HJtnPGdccnbqsR1V0hWSJe9AWFx1', now());

INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 1, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 2, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 3, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 4, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 6, 'discover');

INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 4, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 5, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 6, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 1, 'share');

-- Jordan
INSERT INTO matches (user_a, user_b, time)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', '26ab0db90d72e28ad0ba1e22ee510510', now());
INSERT INTO matches (user_a, user_b, time)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 'b026324c6904b2a9cb4b88d6d61c81d1', now());
INSERT INTO matches (user_a, user_b, time)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 'TMnFU6BmQoV8kSMoYYGLJDu8qSy1', now());
INSERT INTO matches (user_a, user_b, time)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 'C0j9nlTcBaWXmNACgwtnNds0Q3A2', now());
INSERT INTO matches (user_a, user_b, time)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 'HJtnPGdccnbqsR1V0hWSJe9AWFx1', now());

INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 2, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 6, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 3, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 4, 'discover');

INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 7, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 5, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 6, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3', 2, 'share');

-- Seharsh
INSERT INTO matches (user_a, user_b, time)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', '26ab0db90d72e28ad0ba1e22ee510510', now());
INSERT INTO matches (user_a, user_b, time)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 'b026324c6904b2a9cb4b88d6d61c81d1', now());
INSERT INTO matches (user_a, user_b, time)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 'TMnFU6BmQoV8kSMoYYGLJDu8qSy1', now());
INSERT INTO matches (user_a, user_b, time)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 'OQezYUwFC2P2JOP81nicQR4qZRB3', now());
INSERT INTO matches (user_a, user_b, time)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 'HJtnPGdccnbqsR1V0hWSJe9AWFx1', now());

INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 1, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 6, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 3, 'discover');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 4, 'discover');

INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 1, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 5, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 6, 'share');
INSERT INTO user_hobbies (user_id, hobby_id, swap)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2', 2, 'share');

-- FAKE VOTES
INSERT INTO votes (time, vote, user_from, user_to)
VALUES (now(), TRUE, 'b026324c6904b2a9cb4b88d6d61c81d1', '26ab0db90d72e28ad0ba1e22ee510510');
INSERT INTO votes (time, vote, user_from, user_to)
VALUES (now(), TRUE, '26ab0db90d72e28ad0ba1e22ee510510', 'b026324c6904b2a9cb4b88d6d61c81d1');
INSERT INTO votes (time, vote, user_from, user_to)
VALUES (now(), TRUE, '6d7fce9fee471194aa8b5b6e47267f03', '48a24b70a0b376535542b996af517398');
INSERT INTO votes (time, vote, user_from, user_to)
VALUES (now(), TRUE, 'b026324c6904b2a9cb4b88d6d61c81d1', '48a24b70a0b376535542b996af517398');
INSERT INTO votes (time, vote, user_from, user_to)
VALUES (now(), FALSE, 'b026324c6904b2a9cb4b88d6d61c81d1', '6d7fce9fee471194aa8b5b6e47267f03');
INSERT INTO votes (time, vote, user_from, user_to)
VALUES (now(), TRUE, '48a24b70a0b376535542b996af517398', 'b026324c6904b2a9cb4b88d6d61c81d1');
INSERT INTO votes (time, vote, user_from, user_to)
VALUES (now(), TRUE, '6d7fce9fee471194aa8b5b6e47267f03', '26ab0db90d72e28ad0ba1e22ee510510');
INSERT INTO votes (time, vote, user_from, user_to)
VALUES (now(), TRUE, '48a24b70a0b376535542b996af517398', '6d7fce9fee471194aa8b5b6e47267f03');
INSERT INTO votes (time, vote, user_from, user_to)
VALUES (now(), TRUE, '6d7fce9fee471194aa8b5b6e47267f03', '48a24b70a0b376535542b996af517398');
INSERT INTO votes (time, vote, user_from, user_to)
VALUES (now(), TRUE, '6d7fce9fee471194aa8b5b6e47267f03', 'b026324c6904b2a9cb4b88d6d61c81d1');

INSERT INTO votes (time, vote, user_from, user_to)
VALUES (now(), TRUE, 'b026324c6904b2a9cb4b88d6d61c81d1', '26ab0db90d72e28ad0ba1e22ee510510'); -- Repeat match
INSERT INTO votes (time, vote, user_from, user_to)
VALUES (now(), TRUE, '26ab0db90d72e28ad0ba1e22ee510510', 'b026324c6904b2a9cb4b88d6d61c81d1');

INSERT INTO rating (user_to, user_from, rate_value)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', '26ab0db90d72e28ad0ba1e22ee510510', 0);
INSERT INTO rating (user_to, user_from, rate_value)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 'OQezYUwFC2P2JOP81nicQR4qZRB3', 1);
INSERT INTO rating (user_to, user_from, rate_value)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1', 'b026324c6904b2a9cb4b88d6d61c81d1', 1);
INSERT INTO rating (user_to, user_from, rate_value)
VALUES ('26ab0db90d72e28ad0ba1e22ee510510', 'b026324c6904b2a9cb4b88d6d61c81d1', 1);
INSERT INTO rating (user_to, user_from, rate_value)
VALUES ('26ab0db90d72e28ad0ba1e22ee510510', '6d7fce9fee471194aa8b5b6e47267f03', 0);
INSERT INTO rating (user_to, user_from, rate_value)
VALUES ('26ab0db90d72e28ad0ba1e22ee510510', 'b026324c6904b2a9cb4b88d6d61c81d1', 1);
INSERT INTO rating (user_to, user_from, rate_value)
VALUES ('b026324c6904b2a9cb4b88d6d61c81d1', '6d7fce9fee471194aa8b5b6e47267f03', 0);
INSERT INTO rating (user_to, user_from, rate_value)
VALUES ('48a24b70a0b376535542b996af517398', '6d7fce9fee471194aa8b5b6e47267f03', 0);
INSERT INTO rating (user_to, user_from, rate_value)
VALUES ('48a24b70a0b376535542b996af517398', 'b026324c6904b2a9cb4b88d6d61c81d1', 1);

-- FAKE LOCATION  -31.98, 115.82 UWA
INSERT INTO location_data (user_id, lat, long)
VALUES ('26ab0db90d72e28ad0ba1e22ee510510', -31.95, 115.81);
INSERT INTO location_data (user_id, lat, long)
VALUES ('b026324c6904b2a9cb4b88d6d61c81d1', -31.98, 115.83);
INSERT INTO location_data (user_id, lat, long)
VALUES ('6d7fce9fee471194aa8b5b6e47267f03', -31.97, 115.82);
INSERT INTO location_data (user_id, lat, long)
VALUES ('b026324c6904b2a9cb4b88d6d61c81d1', -31.95, 115.87);
INSERT INTO location_data (user_id, lat, long)
VALUES ('48a24b70a0b376535542b996af517398', -31.88, 115.76);
INSERT INTO location_data (user_id, lat, long)
VALUES ('C0j9nlTcBaWXmNACgwtnNds0Q3A2'    , -31.89, 115.79);
INSERT INTO location_data (user_id, lat, long)
VALUES ('OQezYUwFC2P2JOP81nicQR4qZRB3'    , -31.92, 115.83);
INSERT INTO location_data (user_id, lat, long)
VALUES ('TMnFU6BmQoV8kSMoYYGLJDu8qSy1'    , -31.96, 115.85);


-- TEST FUNCTION CALLS

SELECT *
FROM compatibility('TMnFU6BmQoV8kSMoYYGLJDu8qSy1');

SELECT *
FROM distance_table('TMnFU6BmQoV8kSMoYYGLJDu8qSy1');

SELECT *
FROM compatible_rating('TMnFU6BmQoV8kSMoYYGLJDu8qSy1');

SELECT *
FROM matching_algorithm('TMnFU6BmQoV8kSMoYYGLJDu8qSy1');
