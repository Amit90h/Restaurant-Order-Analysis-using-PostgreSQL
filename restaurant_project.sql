-- Q 1 - Total number of customers.
SELECT count(*) as total_customer
FROM customers;

-- Q 2 - Total number of restaurants.
SELECT count(*) as total_restaurant 
FROM restaurants;


-- Q 3 - SQL Total number of orders.
SELECT count(*) total_order
FROM orders;

-- Q 4 - Total revenue generated.
SELECT sum(total_amount) revenue 
FROM orders;

-- Q 5 - Average order value.
SELECT avg(total_amount) average_order_amount
FROM orders;

-- Q 6 - Total delivered orders.
SELECT count(*) as delivered_orders
FROM orders
WHERE order_status = 'Delivered';

-- Q 7 - Total cancelled orders.
SELECT count(*) as delivered_orders
FROM orders
WHERE order_status = 'Cancelled';

-- Q 8 - Find the highest order amount.
SELECT max(total_amount) highest_order_amount
FROM orders;

-- Q 9 - Find the lowest order amount.
SELECT min(total_amount) highest_order_amount
FROM orders;

-- Q 10 - Count orders by payment method.
SELECT payment_method, count(*)
FROM orders
GROUP BY payment_method;

-- Q 11 - Total sales by city.
SELECT r.city, sum(o.total_amount) as sales
FROM orders o
INNER JOIN restaurants r ON r.restaurant_id = o.restaurant_id
GROUP BY r.city;

-- Q 12 - Total orders by city.
SELECT r.city ,count(o.*) total_order
FROM orders o 
INNER JOIN restaurants r ON r.restaurant_id = o.restaurant_id
GROUP BY r.city;

-- Q 13 - Total revenue by restaurant.
SELECT 
	r.restaurant_name,
	sum(o.total_amount) as total_revenue
FROM orders o
INNER JOIN restaurants r ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name;

-- Q 14 - Top 10 restaurants by revenue.
SELECT 
	r.restaurant_name,
	sum(o.total_amount) as total_revenue
FROM orders o
INNER JOIN restaurants r ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Q 15 - Bottom 10 restaurants by revenue.
SELECT 
	r.restaurant_name,
	sum(o.total_amount) as total_revenue
FROM orders o
INNER JOIN restaurants r ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name
ORDER BY total_revenue ASC
LIMIT 10;

-- Q 16 - Average rating of each restaurant.
SELECT 
	restaurant_name,
	round(avg(rating),1) avg_rating
FROM restaurants
GROUP BY restaurant_name;

-- Q 17 - Number of customers in each city.
select 
	city,
	count(*)as total_customer 
from customers
group by city;


-- Q 18 - Number of restaurants in each city.
SELECT 
	city,
	count(*) as total_restaurant
FROM restaurants
GROUP BY city;

-- Q 19 - Average order value by city.
SELECT 
	r.city,
	round(avg(o.total_amount),2) as avg_orders_value
FROM orders o
INNER JOIN restaurants r ON r.restaurant_id = o.restaurant_id
GROUP BY r.city;

-- Q 20 - Count delivered vs cancelled orders.
SELECT 
	order_status,
	count(*) as total_order
FROM orders
GROUP BY order_status;

-- Q 21 - customer name with their order amount.
SELECT 
	c.customer_name, 
	count(o.order_id) as total_orders,
	sum(o.total_amount) total_amount
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY c.customer_name ASC;

-- Q 22 - restaurant name with total revenue.
SELECT 
	 r.restaurant_name,
	 sum(o.total_amount) as total_revenue
FROM orders o
INNER JOIN restaurants r ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name;

-- Q 23 - restaurant name and menu items.
SELECT 
	 r.restaurant_name,
     m.item_name as total_items
FROM restaurants r
LEFT JOIN menu m ON r.restaurant_id = m.restaurant_id;


-- Q 24 - Find customers who never placed an order.
SELECT 
	 c.customer_id,
	 c.customer_name,
	 count(o.order_id) as total_order
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.customer_name
HAVING count(o.order_id) = 0;


-- Q 25 - Find restaurants with no reviews.
SELECT 
	 r.restaurant_id,
	 r.restaurant_name,
	 rw.rating
FROM restaurants r
LEFT JOIN reviews rw on r.restaurant_id  = rw.restaurant_id
WHERE rw.rating IS NULL;

-- Q 26 -  Show menu items with restaurant names.

SELECT 
	 m.menu_id,
	 m.item_name,
	 r.restaurant_name
FROM menu m 
INNER JOIN restaurants r ON r.restaurant_id = m.restaurant_id;

	 
-- Q 28 - Show all reviews with customer names.
SELECT 
	 c.customer_id,
	 c.customer_name,
	 rw.rating,
	 rw.review_text
FROM customers c
INNER JOIN reviews rw ON rw.customer_id = c.customer_id;

-- Q 29 - Show order details with delivery status.
SELECT 
	 o.order_id,
	 o.order_date,
	 o.payment_method,
	 o.total_amount,
	 d.delivery_minutes,
	 d.delivery_status
FROM orders o
INNER JOIN deliveries d ON d.order_id = o.order_id;


-- Q 30 - Find customers who ordered from more than one restaurant
SELECT 
	 c.customer_id,
	 c.customer_name,
	 count(DISTINCT r.restaurant_id) as number_of_restaurants
FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
INNER JOIN restaurants r ON r.restaurant_id = o.restaurant_id
GROUP BY c.customer_id ,c.customer_name
HAVING count(DISTINCT r.restaurant_id)  > 1
ORDER BY c.customer_id ASC;



-- Business Analysis 


-- Q 31 - Top 10 highest spending customers.
SELECT 
	 c.customer_id,
	 c.customer_name,
	 sum(o.total_amount) as spended_amount,
	 dense_rank() over(order by sum(o.total_amount) desc) as ranks
FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id,c.customer_name
ORDER BY spended_amount DESC
LIMIT 10;

-- Q 32 - Top 5 most ordered menu items.
SELECT 
	 m.item_name,
	 count(oi.order_id) total_order
FROM menu m
INNER JOIN order_items oi ON oi.menu_id = m.menu_id
GROUP BY m.item_name
ORDER BY total_order DESC
LIMIT 5;

-- Q 33 - Most popular cuisine.
SELECT 
	 r.cuisine,
	 count(distinct o.order_id) as total_order
FROM restaurants r
INNER JOIN orders o ON o.restaurant_id = r.restaurant_id
GROUP BY r.cuisine
ORDER BY total_order DESC
LIMIT 1;

-- Q 34 - Restaurant with highest average rating.
select 
r.restaurant_id,
r.restaurant_name,
r.rating,
round(avg(rw.rating),1) as average_rating
FROM restaurants r
JOIN reviews rw ON r.restaurant_id = rw.restaurant_id
GROUP BY r.restaurant_id,r.restaurant_name,r.rating
ORDER BY average_rating DESC
LIMIT 1;


-- Q 35 - City with highest revenue.
SELECT 
r.city,
sum(o.total_amount) as total_revenue
FROM restaurants r 
INNER JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.city
ORDER BY  total_revenue DESC
LIMIT 1;


-- Q 36 - Average delivery time by city.
SELECT
r.city,
round(avg(d.delivery_minutes),2) average_time
FROM restaurants r 
INNER JOIN orders o ON r.restaurant_id = o.restaurant_id
INNER JOIN deliveries d ON o.order_id = d.order_id
GROUP BY r.city
ORDER BY average_time;

-- Q 37 - Percentage of cancelled orders.
SELECT round(count(
	CASE 
  	   when order_status = 'Cancelled' THEN 1 END)*100.0/COUNT(*),2)
FROM orders;


-- Q 38 - Find restaurants with revenue below average.
SELECT 
	r.restaurant_name,
	SUM(o.total_amount) as reveune
FROM orders o 
INNER JOIN restaurants r 
ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
HAVING SUM(o.total_amount) <(
		SELECT AVG(total_sum) as average
		FROM (
				SELECT 
					r.restaurant_name,
					SUM( o.total_amount) as total_sum
				FROM orders o
				INNER JOIN restaurants r ON o.restaurant_id = r.restaurant_id
				GROUP BY r.restaurant_name ) as t
);

-- Q 39 - Monthly revenue trend.
SELECT 
	EXTRACT( month from order_date) as months,
	EXTRACT( YEAR from order_date) as years,
	sum(total_amount) as reveune
FROM orders
GROUP BY months,years
ORDER BY months,years ASC;

-- Q 40 - Top revenue-generating month.
SELECT 
	EXTRACT( month from order_date) as months,
	EXTRACT( YEAR from order_date) as years,
	sum(total_amount) as reveune
FROM orders
GROUP BY months,years
ORDER BY reveune DESC
LIMIT 1;

-- Q 41 - Rank restaurants by revenue.
SELECT 
	r.restaurant_id,
	r.restaurant_name,
	sum(o.total_amount) as revenue,
	rank() over(order by sum(o.total_amount) desc) as rank_revenue
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id,r.restaurant_name;


-- Q 42 - Dense rank customers by spending.
SELECT 
	c.customer_id,
	c.customer_name,
	sum(o.total_amount) as spended_amount,
	dense_rank() over(order by sum(o.total_amount) desc) as customer_rank
FROM customers c 
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.customer_name;


-- Q 43 - Running total of revenue by order date.
SELECT 
	 order_date,
	 sum(total_amount) over(order by order_date asc) as running_total
FROM orders;


-- Q 43 Part 2 - Running total of revenue by  daily.
SELECT 
	order_date,
	reveune,
	sum(reveune) over(order by order_date)
FROM 
(select 
	order_date,
	sum(total_amount) as reveune
FROM orders
GROUP BY order_date
order by order_date asc
)t;

-- Q 44 - Find top 3 restaurants in every city.
SELECT 
	 *
FROM 
(
	SELECT 
	r.restaurant_id,
	r.restaurant_name,
	r.city,
	sum(o.total_amount) as reveune,
	DENSE_RANK() OVER(PARTITION BY r.city order by sum(o.total_amount) desc) city_rank
	FROM restaurants r 
	JOIN orders o ON  r.restaurant_id = o.restaurant_id
	GROUP BY r.restaurant_id,r.restaurant_name,r.city
) as t
where city_rank <= 3;

-- Q 45 - Find second highest spending customer.
SELECT 
*
FROM (
SELECT 
	 c.customer_id,
	 c.customer_name,
	 sum(o.total_amount) spended_money,
	 DENSE_RANK() OVER(ORDER BY sum(o.total_amount) desc) customer_rank
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.customer_name
ORDER BY spended_money DESC
) as t
WHERE customer_rank = 2;

-- Q 46 - Previous order amount using LAG().
SELECT 
   	 o.order_id,
	 c.customer_id,
	 o.order_date,
	 o.total_amount,
	 LAG(o.total_amount)
	 OVER(PARTITION BY c.customer_id ORDER BY o.order_date) as previous_amount
FROM orders o
INNER JOIN customers c
ON c.customer_id = o.customer_id;


-- Q 47 - Next order amount using LEAD().
SELECT 
   	 o.order_id,
	 c.customer_id,
	 o.order_date,
	 o.total_amount,
	 LEAD(o.total_amount)
	 OVER(PARTITION BY c.customer_id ORDER BY o.order_date) as previous_amount
FROM orders o
INNER JOIN customers c
ON c.customer_id = o.customer_id;


-- Q 48 - Moving average of daily revenue.
SELECT 
 	 order_date,
	 average,
	 round(avg(average) over(order by order_date asc),2) average_of_daily
FROM (
SELECT 
    order_date,
	ROUND(sum(total_amount),2) as average
FROM orders
GROUP BY order_date
ORDER BY order_date ASC
) t;


-- Q 49 - Row number for each customer's orders.
SELECT 
  	 c.customer_id,
	 c.customer_name,
	 o.order_id,
	 o.order_date,
	 row_number() 
	 over(partition by c.customer_id 
	 order by o.order_date asc) as order_row_number
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;


-- Q 50 -  Highest order in each city using ROW_NUMBER().
SELECT 
*
FROM
(SELECT 
  r.city,
  r.restaurant_name,
  COUNT(o.order_id) as total_order,
  ROW_NUMBER() OVER(PARTITION BY r.city order by count(o.order_id) desc) as rn
FROM restaurants r
JOIN orders o 
ON r.restaurant_id = o.restaurant_id
GROUP BY r.city,r.restaurant_name)t
WHERE rn = 1;

-- Q 51 Customers who placed more than 10 orders.
SELECT 
	 c.customer_id,
	 c.customer_name,
	 count(o.order_id) as total_order
FROM customers c
INNER JOIN orders o
ON  c.customer_id = o.customer_id
GROUP BY c.customer_id,c.customer_name
HAVING count(o.order_id) > 10;

-- Q 52 Restaurants whose average rating is above 3.
SELECT 
	 r.restaurant_id,
	 r.restaurant_name,
	 round(avg(rw.rating),1) as average_rating
FROM restaurants r
INNER JOIN reviews rw
ON r.restaurant_id = rw.restaurant_id
GROUP BY r.restaurant_id,r.restaurant_name
HAVING avg(rw.rating) > 3;

-- Q 53 Revenue contribution (%) of each restaurant.
SELECT 
	 r.restaurant_id,
	 r.restaurant_name,
	 sum(o.total_amount),
	 round(
	 	sum(o.total_amount)*100.0 /
		 (select sum(total_amount) FROM orders),2) as contribution_revenue
FROM restaurants r
INNER JOIN orders o 
ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id,r.restaurant_name
ORDER BY contribution_revenue DESC;

-- Q 54 Top-selling menu item in each city.
SELECT 
*
FROM(
select 
	 r.city,
	 m.item_name,
	 count(oi.menu_id) as total_order,
	 row_number() 
	 over(partition by r.city order by count(oi.menu_id) desc) rn
from restaurants r
join menu m on r.restaurant_id = m.restaurant_id
join order_items oi on m.menu_id = oi.menu_id
group by r.city,m.item_name
) t
where rn = 1;

-- Q 55 Repeat customers (ordered on more than one date.)

select 
	 c.customer_id,
	 c.customer_name,
	 count(distinct o.order_date) as customer
from orders o
join customers c on c.customer_id = o.customer_id
group by 1,2
having count(distinct o.order_date) > 1
order by c.customer_id desc;

--  Q 56 Find inactive customers (no order in last 30 days).
SELECT c.customer_id,c.customer_name,max(o.order_date) AS last_order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING max(o.order_date) < (
select max(order_date) - interval '30 days' from orders
);

-- Q 57 Restaurant with the highest cancellation rate.
SELECT r.restaurant_id,r.restaurant_name, 
	   round(count(case 
	   				when o.order_status = 'Cancelled' then 1 end)*100.0/
					   	(count(o.order_id)),2) as highest_p
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP by 1,2
order by highest_p desc
limit 1;

-- Q 58 Top 5 delivery partners by fastest average delivery time. (If partner table is added.)
select 
		partner_id,
		round(avg(delivery_minutes),2) as average_time
from deliveries
group by partner_id
order by average_time asc
limit 5;

-- Q 59 Find customers who spent above the overall average spending.
SELECT 
	 c.customer_id,
	 c.customer_name,
	 sum(o.total_amount) as spended_money
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.customer_name
HAVING sum(o.total_amount) > (
	select avg(spend_avg) from (
			select 
				customer_id,
				sum(total_amount) as spend_avg
			from orders
			group by customer_id
					) t
)
ORDER BY spended_money DESC;


--  Q 60 Create a leaderboard of customers based on total spending

SELECT 
	c.customer_id,
	c.customer_name,
	count(o.order_id) as total_order,
	sum(o.total_amount) as spended_amount,
	dense_rank() over(order by sum(o.total_amount) desc) customer_ranks
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.customer_name








