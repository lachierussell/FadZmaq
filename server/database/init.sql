DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS votes;
DROP TABLE IF EXISTS hobbies;
DROP TABLE IF EXISTS profile;


CREATE TABLE IF NOT EXISTS profile
(
    bio      VARCHAR(400),
    nickname VARCHAR(20),
    email    VARCHAR(320),
    age      INTEGER,
    gender   char,
    user_id  SERIAL NOT NULL,
    phone    VARCHAR
);

CREATE TABLE IF NOT EXISTS matches
(
    match_id SERIAL NOT NULL
        CONSTRAINT matches_pk
            PRIMARY KEY,
    time     TIME,
    rating   BOOLEAN
);

CREATE TABLE IF NOT EXISTS votes
(
    time      TIME,
    user_from INTEGER,
    user_to   INTEGER
);

CREATE TABLE IF NOT EXISTS hobbies
(
    hobby_id SERIAL NOT NULL
        CONSTRAINT hobbies_pk
            PRIMARY KEY,
    name     VARCHAR
);


INSERT INTO profile (bio, nickname, email, age, gender, phone)
    VALUES ('Avid rock climber and hiking enthusiast.', 'Lachie', 'some@email.com', 20, 'M', '0423199199');