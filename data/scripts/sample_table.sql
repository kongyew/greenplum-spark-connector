drop table if exists basictable;
create table basictable (
	id serial,
	value text
) distributed by (id);

insert into basictable (value) values ('Alice');
insert into basictable (value) values ('Bob');
insert into basictable (value) values ('Charlie');
insert into basictable (value) values ('Eve');
insert into basictable (value) values ('Jim');
insert into basictable (value) values ('John');
insert into basictable (value) values ('Jack');
insert into basictable (value) values ('Victoria');
insert into basictable (value) values ('Zim');



insert into basictable (value) select value from basictable;
insert into basictable (value) select value from basictable;
insert into basictable (value) select value from basictable;
insert into basictable (value) select value from basictable;
insert into basictable (value) select value from basictable;
insert into basictable (value) select value from basictable;
insert into basictable (value) select value from basictable;
insert into basictable (value) select value from basictable;
insert into basictable (value) select value from basictable;
insert into basictable (value) select value from basictable;
