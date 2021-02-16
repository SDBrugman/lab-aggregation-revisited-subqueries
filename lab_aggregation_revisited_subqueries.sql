USE sakila;

-- 1 --
-- Select the first name, last name, and email address of all the customers who have rented a movie.

SELECT c.customer_id, concat(c.first_name, ' ', c.last_name)  AS customer_name, c.email, count(r.rental_id) as nr_of_rentals
FROM rental r
	join customer c on r.customer_id = c.customer_id
group by customer_name
order by nr_of_rentals;

-- 2 --
-- What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
SELECT c.customer_id, concat(c.first_name, ' ', c.last_name)  AS customer_name, c.email, round(avg(p.amount),2) as average_payment
FROM customer c
	join payment p on c.customer_id = p.customer_id
group by customer_name
order by average_payment;

-- 3 --
-- Select the name and email address of all the customers who have rented the "Action" movies.
-- step 1 --
-- Write the query using multiple join statements
SELECT distinct(c.customer_id), concat(c.first_name, ' ', c.last_name)  AS customer_name, c.email, ca.name
from rental r
	join customer c on r.customer_id = c.customer_id
    join inventory i on r.inventory_id = i.inventory_id
    join film_category f on i.film_id = f.film_id
    join category ca on f.category_id = ca.category_id
where ca.name = 'Action'
order by customer_name;

-- step 2 --
-- Write the query using sub queries with multiple WHERE clause and IN condition
select distinct(customer_id), concat(first_name, ' ', last_name)  AS customer_name, email from customer 
where customer_id in (
	select customer_id from rental
	where inventory_id in (
		select inventory_id from inventory
		where film_id in (
			select film_id from film_category
			where category_id in (
				select category_id from category
				where name = 'Action'
			)
		)
	)
)
order by customer_name;

-- step 3 --
-- Verify if the above two queries produce the same results or not
# Yes it's the same result

-- 4 --
-- Use the case statement to create a new column classifying existing columns as either or high value transactions 
-- based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, 
-- the label should be medium, and if it is more than 4, then it should be high.
select customer_id, amount,
case 
	when amount between 0 and 2 then 'low'
	when amount between 2 and 4 then 'medium'
	else 'high'
end as classifying_payments
from payment
order by amount ASC;

/* classifying payments divided by columns
select customer_id, amount,
(case when amount between 0 and 2 then amount end) as 'low',
(case when amount between 2 and 4 then amount end) as 'medium',
(case when amount > 4 then amount end) as 'high'
from payment;
*/
