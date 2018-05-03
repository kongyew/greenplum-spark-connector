
DROP  TABLE IF EXISTS  usertable;
CREATE TABLE usertable(lastname text, age int, firstname text) DISTRIBUTED BY (lastname);
