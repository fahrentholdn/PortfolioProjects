/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

SELECT
	staff.first_name,
    staff.last_name,
    address.address,
    address.district,
    city.city,
    country.country
FROM staff
INNER JOIN address
	ON staff.address_id = address.address_id
LEFT JOIN city
	ON city.city_id = address.city_id
LEFT JOIN country
	ON country.country_id = city.country_id;
	
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/
SELECT
	inventory.store_id AS store_id_number,
    inventory.inventory_id,
    film.title AS film_name,
    film.rating AS film_rating,
    film.rental_rate AS rental_rate,
    film.replacement_cost AS replacement_price
FROM film
LEFT JOIN inventory
	ON film.film_id = inventory.film_id;

/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/
SELECT
	inventory.store_id,
	film.rating,
    COUNT(inventory_id) AS inventory_items
FROM inventory
	LEFT JOIN film
		ON film.film_id = inventory.film_id
	GROUP BY
		inventory.store_id,
        film.rating;

/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 
SELECT
    category.name AS category_name,
	COUNT(film.film_id) AS number_of_films,
    AVG(replacement_cost) AS avg_replacement_cost,
    SUM(replacement_cost) AS total_replacement_cost
FROM film
LEFT JOIN film_category
	ON film.film_id = film_category.film_id
INNER JOIN category
	ON film_category.category_id = category.category_id
GROUP BY
	category.category_id;
    
/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

SELECT
	customer.customer_id,
    customer.first_name AS first_name,
    customer.last_name AS last_name,
    customer.store_id,
    customer.active as active_status,
    city.city AS city,
    country.country AS country
FROM customer
LEFT JOIN address
	ON customer.address_id = address.address_id
LEFT JOIN city
	ON city.city_id = address.city_id
LEFT JOIN country
	ON country.country_id = city.country_id;

/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/
SELECT
	customer.first_name,
    customer.last_name,
    COUNT(rental.rental_id) AS total_lifetime_rentals,
    SUM(payment.amount) AS total_payment_amount
FROM customer

LEFT JOIN rental ON rental.customer_id = customer.customer_id
LEFT JOIN payment ON payment.rental_id = rental.rental_id

GROUP BY
	customer.first_name,
    customer.last_name
ORDER BY
	SUM(payment.amount) DESC;

    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/

SELECT
	'investor' AS type,
	first_name,
    last_name,
    company_name
FROM investor 

UNION

SELECT
	'advisor' AS type,
	first_name,
    last_name,
    NULL
FROM advisor;

/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/
SELECT
	CASE
		WHEN actor_award.awards = 'Emmy, Oscar, Tony' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
        ELSE '1 award'
	END AS number_of_awards,
    AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film
FROM actor_award

GROUP BY
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
        ELSE '1 award'
	END
