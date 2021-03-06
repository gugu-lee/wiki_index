create database netspider default character set gbk;

use netspider;
create table downloaded_url
(
url_id int not null primary key AUTO_INCREMENT,
url varchar(1024),
protocol_schema varchar(64),
host_name varchar(128),
file_name varchar(1024),
download_time datetime
);


create table page_index 
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);

insert into page_index values(1,0,'%E8%87%AA%E7%84%B6','http://zh.wikipedia.org/wiki/Category:%E8%87%AA%E7%84%B6',14,1,0,1,1,0);
insert into page_index values(1,0,'%E8%87%AA%E7%84%B6%E7%A7%91%E5%AD%A6','http://zh.wikipedia.org/wiki/Category:%E8%87%AA%E7%84%B6%E7%A7%91%E5%AD%A6',16,8,0,1,1,0);

create table page_index_sw
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_sw values(1,0,'%E7%94%9F%E7%89%A9','http://zh.wikipedia.org/wiki/Category:%E7%94%9F%E7%89%A9',28,18,0,1,1,0);

create table page_index_dw
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_dw values(1,0,'%E5%8A%A8%E7%89%A9','http://zh.wikipedia.org/wiki/Category:%E5%8A%A8%E7%89%A9',73,80,0,1,1,0);

create table page_index_zw
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_zw values(1,0,'%E6%A4%8D%E7%89%A9','http://zh.wikipedia.org/wiki/Category:%E6%A4%8D%E7%89%A9',63,81,0,1,1,0);


create table page_index_qx
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_qx values(1,0,'%E6%B0%94%E8%B1%A1%E5%AD%A6','http://zh.wikipedia.org/wiki/Category:%E6%B0%94%E8%B1%A1%E5%AD%A6',63,81,0,1,1,0);



create table page_index_jj
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_jj values(1,0,'%E5%AD%A3%E7%AF%80','http://zh.wikipedia.org/wiki/Category:%E5%AD%A3%E7%AF%80',6,10,0,1,1,0);




create table page_index_hxys
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_hxys values(1,0,'%E5%8C%96%E5%AD%A6%E5%85%83%E7%B4%A0','http://zh.wikipedia.org/wiki/Category:%E5%8C%96%E5%AD%A6%E5%85%83%E7%B4%A0',6,10,0,1,1,0);


create table page_index_kw
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_kw values(1,0,'%E7%9F%BF%E7%89%A9','http://zh.wikipedia.org/wiki/Category:%E7%9F%BF%E7%89%A9',34,40,0,1,1,0);



create table page_index_dl
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_dl values(1,0,'%E5%9C%B0%E7%90%86','http://zh.wikipedia.org/wiki/Category:%E5%9C%B0%E7%90%86',23,10,0,1,1,0);

insert into page_index(parent_id,title,url,sub_category_count,page_count,state,path,level,rel_id) values(0,'%E5%9C%B0%E7%90%86','http://zh.wikipedia.org/wiki/Category:%E5%9C%B0%E7%90%86',23,10,0,1,1,0);



#math
create table page_index_xs
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_xs values(1,0,'%E6%95%B0%E5%AD%A6','http://zh.wikipedia.org/wiki/Category:%E6%95%B0%E5%AD%A6',57,52,0,1,1,0);

insert into page_index(parent_id,title,url,sub_category_count,page_count,state,path,level,rel_id) values(0,'%E6%95%B0%E5%AD%A6','http://zh.wikipedia.org/wiki/Category:%E6%95%B0%E5%AD%A6',57,52,0,1,1,0);

create table page_index_wlx
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_wlx values(1,0,'%E7%89%A9%E7%90%86%E5%AD%A6','http://zh.wikipedia.org/wiki/Category:%E7%89%A9%E7%90%86%E5%AD%A6',41,76,0,1,1,0);




create table page_index_lx
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_lx values(1,0,'%E5%8A%9B%E5%AD%B8','http://zh.wikipedia.org/wiki/Category:%E5%8A%9B%E5%AD%B8',16,69,0,1,1,0);


create table page_index_hx
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_hx values(1,0,'%E5%8C%96%E5%AD%A6','http://zh.wikipedia.org/wiki/Category:%E5%8C%96%E5%AD%A6',16,69,0,1,1,0);



create table page_index_xz
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_xz values(1,0,'%E6%98%9F%E5%BA%A7','http://zh.wikipedia.org/wiki/Category:%E6%98%9F%E5%BA%A7',92,96,0,1,1,0);



create table page_index_twx
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_twx values(1,0,'%E5%A4%A9%E6%96%87%E5%AD%A6','http://zh.wikipedia.org/wiki/Category:%E5%A4%A9%E6%96%87%E5%AD%A6',28,121,0,1,1,0);


create table page_index_dqkx
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_dqkx values(1,0,'%E5%9C%B0%E7%90%83%E7%A7%91%E5%AD%A6','http://zh.wikipedia.org/wiki/Category:%E5%9C%B0%E7%90%83%E7%A7%91%E5%AD%A6',25,107,0,1,1,0);



create table page_index_swx
(
index_id int not null primary key auto_increment,
parent_id int not null default 0,
title varchar(1024) not null,
url varchar(1024) ,
sub_category_count int default 0,
page_count int default 0,
state int default 0,
path varchar(1024) null,
level int default 0,
rel_id int default 0
);
insert into page_index_swx values(1,0,'%E7%94%9F%E7%89%A9%E5%AD%A6','http://zh.wikipedia.org/wiki/Category:%E7%94%9F%E7%89%A9%E5%AD%A6',66,155,0,1,1,0);

#wlx
insert into page_index(parent_id,title,url,sub_category_count,page_count,state,path,level,rel_id) values(0,'%E7%89%A9%E7%90%86%E5%AD%A6','http://zh.wikipedia.org/wiki/Category:%E7%89%A9%E7%90%86%E5%AD%A6',41,76,0,1,1,0);
update page_index set path=concat('0',last_insert_id()) where index_id=last_insert_id();

#lx
insert into page_index(parent_id,title,url,sub_category_count,page_count,state,path,level,rel_id) values(0,'%E5%8A%9B%E5%AD%B8','http://zh.wikipedia.org/wiki/Category:%E5%8A%9B%E5%AD%B8',16,69,0,1,1,0);
update page_index set path=concat('0',last_insert_id()) where index_id=last_insert_id();

#hx(ERROR)
insert into page_index(parent_id,title,url,sub_category_count,page_count,state,path,level,rel_id) values(0,'%E5%8C%96%E5%AD%A6','http://zh.wikipedia.org/wiki/Category:%E5%8C%96%E5%AD%A6',16,69,0,1,1,0);
update page_index set path=concat('0',last_insert_id()) where index_id=last_insert_id();

#yx
insert into page_index(parent_id,title,url,sub_category_count,page_count,state,path,level,rel_id) values(0,'%E5%8C%BB%E5%AD%A6','http://zh.wikipedia.org/wiki/Category:%E5%8C%BB%E5%AD%A6',57,175,0,1,1,0);
update page_index set path=concat('0',last_insert_id()) where index_id=last_insert_id();

#yx

insert into page_index(parent_id,title,url,sub_category_count,page_count,state,path,level,rel_id) values(0,'%E8%97%A5%E5%AD%B8','http://zh.wikipedia.org/wiki/Category:%E8%97%A5%E5%AD%B8',16,40,0,1,1,0);
update page_index set path=concat('0',last_insert_id()) where index_id=last_insert_id();

#nx
insert into page_index(parent_id,title,url,sub_category_count,page_count,state,path,level,rel_id) values(0,'%E5%86%9C%E5%AD%A6','http://zh.wikipedia.org/wiki/Category:%E5%86%9C%E5%AD%A6',10,17,0,1,1,0);
update page_index set path=concat('0',last_insert_id()) where index_id=last_insert_id();

#XXKX
insert into page_index(parent_id,title,url,sub_category_count,page_count,state,path,level,rel_id) values(0,'%E8%B3%87%E8%A8%8A%E7%A7%91%E5%AD%B8','http://zh.wikipedia.org/wiki/Category:%E8%B3%87%E8%A8%8A%E7%A7%91%E5%AD%B8',25,56,0,1,1,0);
update page_index set path=concat('0',last_insert_id()) where index_id=last_insert_id();

#XTLL
insert into page_index(parent_id,title,url,sub_category_count,page_count,state,path,level,rel_id) values(0,'%E7%B3%BB%E7%B5%B1%E7%90%86%E8%AB%96','http://zh.wikipedia.org/wiki/Category:%E7%B3%BB%E7%B5%B1%E7%90%86%E8%AB%96',16,25,0,1,1,0);
update page_index set path=concat('0',last_insert_id()) where index_id=last_insert_id();

#MMX

insert into page_index(parent_id,title,url,sub_category_count,page_count,state,path,level,rel_id) values(0,'%E5%AF%86%E7%A0%81%E5%AD%A6','http://zh.wikipedia.org/wiki/Category:%E5%AF%86%E7%A0%81%E5%AD%A6',15,81,0,1,1,0);
update page_index set path=concat('0',last_insert_id()) where index_id=last_insert_id();

