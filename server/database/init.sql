
drop table if exists matches;
drop table if exists votes;
drop table if exists hobbies;
drop table if exists primary_user;


create table if not exists primary_user
(
	bio varchar(400),
	nickname varchar(200),
	email varchar(300),
	age integer,
	gender "char",
	user_id serial not null,
	phone varchar
);

create table if not exists matches
(
	match_id serial not null
		constraint matches_pk
			primary key,
	time time,
	rating boolean
);

create table if not exists votes
(
	time time,
	user_from integer,
	user_to integer
);

create table if not exists hobbies
(
	hobby_id serial not null
		constraint hobbies_pk
			primary key,
	name varchar
);

