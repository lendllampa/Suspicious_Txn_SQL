-- create table card_holder(
-- 	id int not null,
-- 	name varchar(255),
-- 	primary key (id)
-- );

-- create table credit_card(
-- 	card varchar(50),
-- 	cardholder_id int,
-- 	primary key (card),
-- 	foreign key (cardholder_id) references card_holder(id)
-- );

-- create table merchant_category(
-- 	id int not null,
-- 	name varchar(255),
-- 	primary key (id)
-- );

-- create table merchant(
-- 	id int not null,
-- 	name varchar(255),
-- 	id_merchant_category int,
-- 	primary key (id),
-- 	foreign key (id_merchant_category) references merchant_category(id)
-- );

-- create table transaction(
-- 	id int not null,
-- 	date TIMESTAMP,
-- 	amount float,
-- 	card varchar(50),
-- 	id_merchant int,
-- 	primary key (id),
-- 	foreign key (card) references credit_card(card),
-- 	foreign key (id_merchant) references merchant(id)
-- );

