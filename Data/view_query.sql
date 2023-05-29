-- Create a view for isolating transactions for each cardholder
create view cardholder_transactions as
select 
	ch.name,
	cc.card,
	t.date,
	t.amount,
	m.name as merchant_name,
	mcat.name as category
from card_holder as ch
join credit_card as cc on cc.cardholder_id = ch.id
join transaction as t on t.card = cc.card
join merchant as m on m.id = t.id_merchant
join merchant_category as mcat on mcat.id = m.id_merchant_category
order by ch.name asc;



-- Create a view for the total number of transactions with less than $2.00
CREATE VIEW total_transactions_under AS
SELECT COUNT(*) AS "Transactions Under $2.00"
FROM transaction
WHERE amount < 2;



-- Create a view for transactions less than $2 per cardholder
create view ch_total_transactions as
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



-- Create view of total transactions under $2 per credit card
create view cc_total_transactions as
select
	cc.card,
	ch.name,
count(*) as num_transactions
from credit_card as cc
join card_holder as ch on ch.id = cc.cardholder_id
join transaction as t on t.card = cc.card
where t.amount < 2
group by (cc.card, ch.name)
order by (num_transactions) desc;


-- Create view of the top 100 highest transactions made between 7am and 9am
create view highest_transactions_am as
select *
from transaction as t
where date_part('hour', t.date) >=7
and date_part('hour', t.date) <=9
order by amount desc
limit 100;



-- Create view of the total transactions under $2 between 7am and 9am
create view transactions_under_am as
select count(*) as "Transactions less than $2.00 between 7am and 9am"
from transaction as t
where amount < 2 
and date_part('hour', t.date) >=7
and date_part('hour', t.date) <=9;



-- Create view of total transactions under $2 in the morning for each credit card
create view cc_transactions_under_am as
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



-- Create view of top 5 merchants prone to being hacked using small transactions
create view prone_merchants as
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



