USE sakila;

-- 1a. Display the first and last names of all actors FROM the table actor.

SELECT first_name, last_name FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT CONCAT(first_name, '  ', last_name) AS Actor_Name FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'JOE';

-- 2b. Find all actors whose last name contain the letters GEN:

SELECT * FROM actor WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

SELECT * FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name;

-- 2d. Using IN, display the COUNTry_id and COUNTry columns of the following COUNTries: Afghanistan, Bangladesh, and China:

SELECT COUNTry_id, COUNTry FROM COUNTry WHERE COUNTry IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, AS the difference between it and VARCHAR are significant).

ALTER TABLE actor ADD description BLOB;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

ALTER TABLE actor DROP description;

-- 4a. List the last names of actors, AS well AS how many actors have that last name.

SELECT last_name, COUNT(last_name) AS last_name_count FROM actor GROUP BY 1;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT last_name, COUNT(last_name) AS last_name_count FROM actor GROUP BY 1 HAVING last_name_count > 1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table AS GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE actor SET first_name = 'HARPO' WHERE (first_name = 'GROUCHO' and last_name = 'WILLIAMS');

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

SHOW CREATE TABLE address;
CREATE TABLE address (address_id smallint(5) unsigned NOT NULL AUTO_INCREMENT, address varchar(50) NOT NULL,  address2 varchar(50) DEFAULT NULL,  district varchar(20) NOT NULL,  city_id smallint(5) unsigned NOT NULL,  postal_code varchar(10) DEFAULT NULL,  phone varchar(20) NOT NULL,  location geometry NOT NULL,  last_UPDATE timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  PRIMARY KEY (address_id),  KEY idx_fk_city_id (city_id),  SPATIAL KEY idx_location (location),  CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) ON UPDATE CASCADE) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

-- 6a. Use JOIN to display the first and last names, AS well AS the address, of each staff member. Use the tables staff and address:

SELECT s.first_name, s.last_name, a.address FROM staff s INNER JOIN address a ON a.address_id = s.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT CONCAT(s.first_name, '  ', s.last_name), SUM(p.amount) FROM staff s INNER JOIN payment p WHERE p.payment_date BETWEEN '2005-08-01' AND '2005-08-31' GROUP BY 1;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT f.title, COUNT(a.actor_id) AS num_actors FROM film f INNER JOIN film_actor a ON f.film_id = a.film_id GROUP BY 1;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT f.title, COUNT(i.inventory_id) AS num_copies FROM film f INNER JOIN inventory i ON f.film_id = i.film_id WHERE f.title = 'Hunchback Impossible' GROUP BY 1;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT c.first_name, c.last_name, SUM(p.amount) AS total_amount FROM customer c INNER JOIN payment p ON p.customer_id = c.customer_id GROUP BY 1,2 ORDER BY c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unLIKEly resurgence. AS an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT title FROM film WHERE (title LIKE 'K%' OR title LIKE 'Q%') and language_id in (SELECT language_id FROM language WHERE name = 'English')

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name FROM actor WHERE actor_id in (SELECT actor_id FROM film_actor WHERE film_id in (SELECT film_id FROM film WHERE title = 'Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT cust.first_name, cust.last_name, cust.email FROM customer cust JOIN address ad ON cust.address_id = ad.address_id
																												JOIN city ON city.city_id = ad.city_id
																												JOIN COUNTry ON COUNTry.COUNTry_id = city.COUNTry_id
	WHERE COUNTry.COUNTry = 'Canada'; 
	

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized AS family films.

SELECT title FROM film WHERE film_id in (SELECT film_id FROM film_category WHERE category_id in (SELECT category_id FROM category WHERE name = 'Family'));

-- 7e. Display the most frequently rented movies in descending order.

SELECT film.title, COUNT(rental.rental_id) total_rents FROM film JOIN inventory ON film.film_id = inventory.inventory_id
																			JOIN rental ON rental.inventory_id = inventory.inventory_id
	GROUP BY 1 
    ORDER BY total_rents desc;
    


-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT store.store_id, SUM(payment.amount) AS total_business FROM store JOIN staff ON store.store_id = staff.store_id
																													JOIN payment ON payment.staff_id = staff.staff_id
	GROUP BY 1;

-- 7g. Write a query to display for each store its store ID, city, and COUNTry.

SELECT store.store_id, city.city, COUNTry.COUNTry FROM store JOIN address ON store.address_id = address.address_id
																						JOIN city ON address.city_id = city.city_id
                                                                                        JOIN COUNTry ON COUNTry.COUNTry_id = city.COUNTry_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT category.name, SUM(payment.amount) AS total_revenue FROM category JOIN film_category ON category.category_id = film_category.category_id
																															JOIN inventory ON inventory.film_id = film_category.film_id
                                                                                                                            JOIN rental ON rental.inventory_id = inventory.inventory_id
                                                                                                                            JOIN payment ON rental.rental_id = payment.rental_id
	GROUP BY 1
    ORDER BY total_revenue desc
    limit 5;

-- 8a. In your new role AS an executive, you would LIKE to have an easy way of viewing the Top five genres by gross revenue. Use the solution FROM the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW top_5_genres AS 
SELECT category.name, SUM(payment.amount) AS total_revenue FROM category JOIN film_category ON category.category_id = film_category.category_id
																															JOIN inventory ON inventory.film_id = film_category.film_id
                                                                                                                            JOIN rental ON rental.inventory_id = inventory.inventory_id
                                                                                                                            JOIN payment ON rental.rental_id = payment.rental_id
	GROUP BY 1
    ORDER BY total_revenue desc
    limit 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM top_5_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW top_5_genres;