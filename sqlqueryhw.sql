USE sakila;

##show first_name and last_name coLUMN FROM actor table
SELECT first_name, last_name FROM actor;

## combine first and last name  and place in a new column
SELECT 
concat(first_name, ' ', last_name) Actor_Name
FROM actor;

##ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';

##Find all actors whose last name contain the letters `GEN`
SELECT * FROM actor WHERE actor.last_name LIKE '%GEN%';

##Find all actors whose last names contain the letters `LI`.
##This time, order the rows by last name and first name, in that order:  NEED HELP!!
SELECT * FROM actor WHERE last_name LIKE '%LI%' ;

##Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China
SELECT country_id, country FROM country WHERE country IN('Afghanistan','Bangladesh','China');

##so create a column in the table `actor` named `description` and use the data type `BLOB` 
##(Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor ADD COLUMN description BLOB;       ##BLOB Binary large Object example summary/paragraph


#Delete the `description` column.
ALTER TABLE actor DROP COLUMN description;


##List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) lastcount  FROM actor GROUP BY last_name;

   ##  GIVE TOTAL COUNT OF THE VALUES IN THE COLUMN    NOT PART OF HW
SELECT COUNT(DISTINCT last_name) FROM actor;

##List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name HAVING COUNT(*) > 1;

##The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
SELECT *  FROM actor WHERE first_name = "Groucho";

##Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor SET first_name='HARPO' WHERE actor_id = 172;
SELECT * FROM actor WHERE first_name = 'HARPO'; ##check for change
UPDATE actor SET first_name='GROUCHO' WHERE actor_id = 172;
SELECT * FROM actor WHERE actor_id = 172;   ###check for change

##You cannot locate the schema of the `address` table. Which query would you use to re-create it?
USE sakila;

SELECT * FROM address; #to view columns needed

USE sakila;
CREATE TABLE address2(
	address_id INT AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR (30),
    district VARCHAR (25),
    city_id INT,
    postal_code INT(6),
    phone INT (12),
    location BLOB);

##Use `JOIN` t o display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
USE sakila;

SELECT first_name, last_name, address 
FROM staff
JOIN address ON address.address_id;
##Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT * FROM staff;

SELECT staff.staff_id, staff.first_name, SUM(payment.amount)  
FROM payment 
JOIN staff ON staff.staff_id = payment.staff_id
WHERE payment.payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY staff.staff_id;


##List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT COUNT(film_actor.actor_id) AS actor_count, film.title  
FROM film_actor 
INNER JOIN film ON film.film_id=film_actor.film_id
GROUP BY film.title; 

##How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT film_id FROM film WHERE title = 'Hunchback Impossible'; #439
SELECT COUNT(film_id) count_of_HI_films FROM inventory WHERE film_id = 439;

##Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer.
## List the customers alphabetically by last name:
USE sakila;

SELECT  customer.customer_id, customer.first_name, customer.last_name, SUM(payment.amount) AS total_paid 
FROM customer
JOIN payment ON payment.customer_id = customer.customer_id
GROUP BY customer.last_name ASC;

##The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
##As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity.
##Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
            ####NEED HELP
SELECT title  
FROM film
	JOIN language ON language.language_id = film.language_id
WHERE language.name = 'english'
AND film.title LIKE 'K%' OR 'Q%';

##Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT first_name, last_name FROM actor WHERE actor_id IN(
	SELECT actor_id FROM film_actor WHERE film_id IN(
		SELECT film_id FROM film WHERE title = 'Alone Trip'));

##You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
	JOIN address ON customer.address_id = address.address_id
	JOIN city ON address.city_id = city.city_id
	JOIN country ON city.country_id = country.country_id
WHERE country = 'CANADA';

##Sales have been lagging among young families, and you wish to target all family movies for a promotion.
##Identify all movies categorized as _family_ films.
SELECT * FROM category; ##family category  - film_category - film

SELECT title FROM film WHERE film_id IN(
	SELECT film_id FROM film_category WHERE category_id IN(
		SELECT category_id FROM category WHERE name = 'family'
        ));

##Display the most frequently rented movies in descending order.

SELECT * FROM rental;  ### rental inventoryid - inventroy film id - film - titlt

SELECT film.title, COUNT(rental.inventory_id) 
FROM rental 
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON inventory.film_id = film.film_id
GROUP BY rental.inventory_id
ORDER BY COUNT(rental.inventory_id) DESC;


##Write a query to display how much business, in dollars, each store brought in.
SELECT * FROM payment;
        
SELECT staff.store_id, SUM(payment.amount)  AS total_per_store
FROM payment 
JOIN staff ON staff.staff_id = payment.staff_id
GROUP BY staff.store_id;
	
##Write a query to display for each store its store ID, city, and country.
SELECT * FROM category;

SELECT store_id, city, country 
FROM store
	JOIN address ON address.address_id = store.address_id
    JOIN city ON city.city_id = address.city_id
    JOIN country ON country.country_id = city.country_id;

##List the top five genres in gross revenue in descending order.
## (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT category.name, SUM(payment.amount)  AS gross_amount 
FROM category
	JOIN film_category ON category.category_id = film_category.category_id
    JOIN inventory ON film_category.film_id = inventory.film_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    JOIN payment ON rental.rental_id = payment.rental_id
 GROUP BY category.name
 ORDER BY gross_amount DESC
 LIMIT 5 ;
##In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
##Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW Top_five_genres AS 
SELECT category.name, SUM(payment.amount)  AS gross_amount 
FROM category
	JOIN film_category ON category.category_id = film_category.category_id
    JOIN inventory ON film_category.film_id = inventory.film_id
    JOIN rental ON inventory.inventory_id = rental.inventory_id
    JOIN payment ON rental.rental_id = payment.rental_id
 GROUP BY category.name
 ORDER BY gross_amount DESC
 LIMIT 5 ;

##How would you display the view that you created in 8a?;;
SELECT * FROM Top_five_genres;

##You find that you no longer need the view `top_five_genres`. Write a query to delete it` 
DROP VIEW sakila.Top_five_genres;
