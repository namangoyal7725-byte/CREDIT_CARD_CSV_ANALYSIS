--write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends --

with cte1 as(
select *, (select sum(amount) from credit_card_transcations) as Total_amount from credit_card_transcations)
, cte2 as
(select 
city,sum(amount) as total_amount_per_city,Total_amount
from cte1
group by city,Total_amount)
, cte3 as
(select *,
row_number() over(order by total_amount_per_city desc) as rn
from cte2)
select *,(total_amount_per_city*1.0/total_amount)*100 as percentage_contribution from cte3
where rn<=5



--write a query to print highest spend month and amount spent in that month for each card type--
with cte1 as
(select *,
format(transaction_date, 'yyyy-MM') as transction_month_year
from credit_card_transcations)
, cte2 as
(select card_type,transction_month_year,sum(amount) as total from cte1
group by card_type,transction_month_year)
, cte3 as
(select *,
ROW_NUMBER() over(partition by card_type order by total desc) as rn
from cte2)
select * from cte3
where rn = 1



/*write a query to print the transaction details(all columns from the table) for each card type when
it reaches a cumulative of 1000000 total spends*/

with cte1 as
(select *,
sum(amount) over(partition by card_type order by transaction_date,transaction_id rows between unbounded preceding and current row) as rolling_sum
from credit_card_transcations)
, cte2 as
(select *,
ROW_NUMBER() over(partition by card_type order by rolling_sum,transaction_id ) as rn
from cte1
where rolling_sum>=1000000)
select * from cte2
where rn = 1

--write a query to find city which had lowest percentage spend for gold card type--
with cte1 as
(select card_type,city,sum(amount) as total,
(select sum(amount) from credit_card_transcations where card_type='gold') as total_gold_spent from credit_card_transcations
where card_type = 'gold'
group by card_type, city)
, cte2 as
(select *,
(total*1.0/total_gold_spent) as percentage_of_total,
row_number() over(order by total) as rn from cte1)
select top 1* from cte2


--write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)--
with cte1 as
(select city,exp_type,sum(amount) as total from credit_card_transcations
group by city,exp_type)
, cte2 as
(select *,
max(total)over(partition by city) as highest_expense_amount, min(total)over(partition by city) as lowest_expense_amount from cte1)
, cte3 as
(select city,exp_type as highest_expense_type
from cte2
where highest_expense_amount = total)
, cte4 as
(select city,exp_type as lowest_expense_type
from cte2
where lowest_expense_amount = total)

select cte3.city,lowest_expense_type,highest_expense_type from cte3
inner join cte4
on cte3.city = cte4.city;


--write a query to find percentage contribution of spends by females for each expense type--
with cte1 as
(select exp_type,sum(amount) as total_per_exp,(select sum(amount) from credit_card_transcations where gender = 'F') as total_spends from credit_card_transcations
where gender  = 'F'
group by exp_type)
,cte2 as
(select  exp_type,(total_per_exp*1.0/total_spends)*100 as ratio from cte1

)
select top 1 * from cte2
order by ratio desc



--which card and expense type combination saw highest month over month growth in Jan-2014--
with cte1 as
(select card_type,exp_type,sum(amount) as total, format(transaction_date,'yyyy-MM') as month_year from credit_card_transcations
where format(transaction_date,'yyyy-MM') between '2013-12' and '2014-01'
group by card_type,exp_type,format(transaction_date,'yyyy-MM'))
, cte2 as
(select *,
lag(total,1,0) over(partition by card_type,exp_type order by month_year) as lagfunction
from cte1
)
select top 1*,total-lagfunction as growth from cte2
where lagfunction != 0
order by growth desc


--during weekends which city has highest total spend to total no of transcations ratio --

with cte1 as
(select *,datename(WEEKDAY,transaction_date) as day from credit_card_transcations)
, cte2 as
(select city,day,sum(amount) as amt,count(transaction_id) as total_transaction from cte1
where day = 'saturday' or day = 'sunday'
group by city,day)
select city,
sum(amt*1.0)over(partition by city)/sum(total_transaction)over(partition by city) as ratio
from cte2
order by ratio desc



--which city took least number of days to reach its 500th transaction after the first transaction in that city--
with cte1 as
(select *,
row_number() over(partition by city order by transaction_date) as rn
from credit_card_transcations)
, cte2 as
(select * from cte1
where rn = 1 or rn = 500)
, cte3 as
(select *,lead(transaction_date)over(partition by city order by transaction_date)  as led from cte2)
select top 1*,
datediff(day,transaction_date,led) as datefunc
from cte3
where led is not null
order by datefunc


