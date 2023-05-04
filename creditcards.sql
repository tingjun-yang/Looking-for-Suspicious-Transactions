create table card_holder(
	id int primary key not NULL,
	name varchar(20)
);

select * from card_holder;

create table credit_card(
	card varchar(20) primary key not NULL,
	cardholder_id int,
	FOREIGN KEY (cardholder_id) REFERENCES card_holder(id)
);

select * from credit_card;

create table merchant_category(
	id smallint primary key not NULL,
	name varchar(20)
);

select * from merchant_category;

create table merchant(
	id int primary key not NULL,
	name varchar(50),
	id_merchant_category smallint,
	foreign key (id_merchant_category) references merchant_category(id)
);

select * from merchant;

create table transaction(
	id int primary key not NULL,
	date timestamp,
	amount float,
	card varchar(20),
	id_merchant int,
	foreign key (id_merchant) references merchant(id),
	foreign key (card) references credit_card(card)
);

select * from transaction;

drop view transaction_counts;

create view transaction_counts as
select a.amount, a.card, e.name
from transaction as a
left join merchant as b on a.id_merchant = b.id
left join merchant_category as c on c.id = b.id_merchant_category
left join credit_card as d on d.card = a.card
left join card_holder as e on e.id = d.cardholder_id
where a.amount < 2;

select * from transaction_counts;

select count(amount) as "transactions less than $2", name from transaction_counts
group by name;

select count(amount) as "transactions less than $2", card from transaction_counts
group by card;

select a.amount, a.date
from transaction as a
left join merchant as b on a.id_merchant = b.id
left join merchant_category as c on c.id = b.id_merchant_category
left join credit_card as d on d.card = a.card
left join card_holder as e on e.id = d.cardholder_id
where extract(hour from a.date) > 7 and extract(hour from a.date) < 9
order by a.amount desc
limit 100;

select a.amount, a.date
from transaction as a
left join merchant as b on a.id_merchant = b.id
left join merchant_category as c on c.id = b.id_merchant_category
left join credit_card as d on d.card = a.card
left join card_holder as e on e.id = d.cardholder_id
where extract(hour from a.date) < 7 or extract(hour from a.date) > 9
order by a.amount desc
limit 100;
