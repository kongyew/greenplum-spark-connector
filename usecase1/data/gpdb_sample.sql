
DROP  TABLE IF EXISTS  usertable;
CREATE TABLE usertable(lastname text, age int, firstname text) DISTRIBUTED BY (lastname);


drop table if exists basictable;
create table basictable (
	id serial,
	value text
) distributed by (id);

insert into basictable (value) values ('Alice');
insert into basictable (value) values ('Bob');
insert into basictable (value) values ('Charlie');
insert into basictable (value) values ('Eve');

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

insert into basictable (value) select value from basictable;
insert into basictable (value) select value from basictable;
insert into basictable (value) select value from basictable;
insert into basictable (value) select value from basictable;
insert into basictable (value) select value from basictable;
