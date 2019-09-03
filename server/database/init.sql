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

alter table primary_user owner to postgres;

create table if not exists matches
(
	match_id serial not null
		constraint matches_pk
			primary key,
	time time,
	rating boolean
);

alter table matches owner to postgres;

create table if not exists votes
(
	time time,
	user_from integer,
	user_to integer
);

alter table votes owner to postgres;

create table if not exists hobbies
(
	hobby_id serial not null
		constraint hobbies_pk
			primary key,
	name varchar
);

alter table hobbies owner to postgres;
