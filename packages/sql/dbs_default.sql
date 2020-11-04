-- create new database
create database spouk;

-- выбираю базу данных
use spouk;

-- show tables
show tables;

-- userinfo
create or replace table userinfo
(
    id       int not null auto_increment primary key,
    email    varchar(200) unique,
    password varchar(100),
    name     varchar(100),
    family   varchar(100),
    city     varchar(100),
    country  varchar(100),
    creating timestamp default current_timestamp
);

-- roles
create or replace table roles
(
    id   int not null primary key auto_increment,
    role varchar(100) unique
);

-- comment
create or replace table comment
(
    id       int not null primary key auto_increment,
    postid   int,
    userid   int,
    parentid int,
    foreign key (postid) references post (id),
    foreign key (userid) references user (id),
    foreign key (parentid) references comment (id),
    data     text,
    created  timestamp default current_timestamp
);
-- user
create or replace table user
(
    id       int not null auto_increment primary key,
    userinfo int,
    role     int,
    foreign key (userinfo) references userinfo (id),
    foreign key (role) references roles (id)
);
-- category
create or replace table category
(
    id          int not null auto_increment primary key,
    name        varchar(500),
    alias       varchar(500),
    description varchar(300),
    creating    timestamp default current_timestamp
);
-- file
create or replace table file
(
    id     int not null primary key auto_increment,
    name   varchar(300),
    path   varchar(300),
    size   int,
    type   varchar(50),
    userid int,
    foreign key (userid) references user (id)
);
-- session
create or replace table session
(
    id              int not null primary key auto_increment,
    cook            varchar(100) unique,
    created         timestamp default current_timestamp,
    start           timestamp,
    end             timestamp,
    historyredirect varchar(500),
    dump            text,
    userid          int,
    foreign key (userid) references user (id)
);

-- post
create or replace table post
(
    id      int not null primary key auto_increment,
    name    varchar(300),
    alias   varchar(300),
    created timestamp default current_timestamp,
    catid   int,
    foreign key (catid) references category (id),
    userid  int,
    foreign key (userid) references user (id)
);

-- tag
create or replace table tag
(
    id     int not null primary key auto_increment,
    postid int,
    foreign key (postid) references post (id)
);


-- testing inserts
-- inserts
insert into roles (id, role) value (id, "root");
insert into roles (id, role) value (id, "admin");
insert into roles(id, role) value (id, "user");
insert into roles(id, role) value (id, "anonymous");
select *
from roles;


-- procedure -> make new user
delimiter //
create or replace procedure newUser(IN role varchar(100), name varchar(100),
                                    family varchar(100), city varchar(100), country varchar(100),
                                    password varchar(100), email varchar(200))
begin
    insert into userinfo (email, password, name, family, city, country) VALUE
        (email, encrypt(password), name, family, city, country);
    insert into user(userinfo, role) value (
                                            (select last_insert_id()),
                                            (select id from roles where roles.role like role));
end //
delimiter ;

