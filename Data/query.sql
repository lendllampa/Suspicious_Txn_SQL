-- Isolate the transactions for each cardholder?
select 
	ch.name,
	cc.card,
	t.date,
	t.amount,
	m.name,
	mcat.name
from card_holder as ch
join credit_card as cc on cc.cardholder_id = ch.id
join transaction as t on t.card = cc.card
join merchant as m on m.id = t.id_merchant
join merchant_category as mcat on mcat.id = m.id_merchant_category
order by ch.name asc;

-- Count the total number of transactions that are less than $2.00
select count(*) as "Transactions Under $2.00"
from transaction
where amount < 2;

-- Count the number of transactions that are less than $2.00 per cardholder
select 
	a.id,
	a.name,
count(c.*) as num_transactions
from card_holder as a
inner join credit_card as b on b.cardholder_id = a.id
inner join transaction as c on b.card = c.card
where c.amount < 2
group by a.id
order by count(c.*) desc;

-- Count the number of transactions that are less than $2.00 per credit card
select
	a.id,	
	a.name,
	b.card,
count(c.*) as num_transactions
from card_holder as a
join credit_card as b on b.cardholder_id = a.id
join transaction as c on b.card = c.card
where c.amount < 2
group by (a.id, b.card)
order by (num_transactions) desc;

-- What are the top 100 highest transactions made between 7am and 9am?
select *
from transaction as t
where date_part('hour', t.date) >=7
and date_part('hour', t.date) <=9
order by amount desc
limit 100;

-- Count the total number of transactions under $2.00 made between 7am and 9am
select count(*) as "Transactions less than $2.00 between 7am and 9am"
from transaction as t
where amount < 2 
and date_part('hour', t.date) >=7
and date_part('hour', t.date) <=9

-- Count the total number of transactions under $2.00 and the total between 7am and 9am for each credit card
select
	cc.card,
	ch.name,
count(t.id) as num_transactions,
sum(t.amount) as total_amnt
from credit_card as cc
join transaction as t on cc.card = t.card
join card_holder as ch on ch.id = cc.cardholder_id
where amount < 2
and date_part('hour', t.date) >=7
and date_part('hour', t.date) <=9
group by (cc.card, ch.name)
order by (ch.name) asc;

-- Top 5 merchants prone to being hacked using small transactions
select
	m.name as merchant,
	mc.name as category,
count(t.*) as micro_transactions
from merchant as m
join merchant_category as mc on m.id_merchant_category = mc.id
join transaction as t on t.id_merchant = m.id
where t.amount < 2
group by m.name, mc.name
order by (micro_transactions) desc
limit 5;


