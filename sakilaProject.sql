use sakila;

-- Question 1
-- a. Display the first and last names of all actors from the table `actor`
select first_name, last_name
from actor;

/* b. Display the first and last name of each actor in a single 
column in upper case letters. Name the column `Actor Name`.*/
select concat(first_name," ", last_name) as "Actor Name"
from actor;

-- Question 2
/* a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, 
"Joe." What is one query would you use to obtain this information?*/

select actor_id, first_name, last_name
from actor where first_name = "Joe";

-- b. Find all actors whose last name contain the letters `GEN`:
select first_name, last_name, locate ("GEN", last_name)
from actor where locate("GEN", last_name);

/* c. Find all actors whose last names contain the letters `LI`. 
This time, order the rows by last name and first name, in that order:*/

select last_name, first_name, locate ("LI", last_name)
from actor where locate("LI", last_name);

/* d. Using `IN`, display the `country_id` and `country` columns of the following countries: 
Afghanistan, Bangladesh, and China:*/

select country_id, country
from country
where country IN ('Afghanistan', 'Bangladesh', 'China');

-- Question 3
/* a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
so create a column in the table `actor` named `description` and use the data type `BLOB` 
(Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).*/

ALTER TABLE actor
ADD COLUMN description blob(15) AFTER last_name;

/* b. Very quickly you realize that entering descriptions for each actor is too much effort. 
Delete the `description` column.*/

alter table actor
drop column description;

-- Question 4
-- a. List the last names of actors, as well as how many actors have that last name.
select last_name, COUNT(*) c 
FROM actor GROUP BY last_name HAVING c >= 1;

/* b. List last names of actors and the number of actors who have that last name, 
but only for names that are shared by at least two actors */

select last_name, COUNT(*) c 
FROM actor GROUP BY last_name HAVING c > 1;

/* c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. 
Write a query to fix the record.*/

update actor set first_name = 'HARPO', last_name = 'WILLIAMS'
where first_name = 'GROUCHO';

/* d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
It turns out that `GROUCHO` was the correct name after all! In a single query, 
if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.*/

update actor set first_name = 'GROUCHO', last_name = 'WILLIAMS'
where first_name = 'HARPO';

-- Question 5
-- a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

show create table address;

-- Question 6
/* a. Use `JOIN` to display the first and last names, as well as the address, 
of each staff member. Use the tables `staff` and `address`:*/


select staff.first_name, staff.last_name, address.address
from staff 
join address on staff.address_id = address.address_id;

/* b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
Use tables `staff` and `payment`.*/

select staff.first_name, staff.last_name, payment.amount, payment.payment_date
from staff
join payment on staff.staff_id = payment.staff_id
where amount > 0 and payment_date BETWEEN '2005-08-01 00:00:00' AND '2005-08-31 23:59:00';

/* c. List each film and the number of actors who are listed for that film. 
Use tables `film_actor` and `film`. Use inner join.*/

select title, count(actor_id)
from film
inner join film_actor on film.film_id = film_actor.film_id
group by title;

-- d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

select title, count(inventory_id)
from film
inner join inventory
on film.film_id = inventory.film_id
where title = 'Hunchback Impossible';

/* e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
List the customers alphabetically by last name:*/

select last_name, first_name, sum(amount)
from payment
inner join customer
on payment.customer_id = customer.customer_id
group by payment.customer_id
order by last_name asc;

-- Question 7
/*a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.*/

select title from film
where language_id in
(select language_id 
from language
where name = "English" )
and (title like "K%") or (title like "Q%");

-- b. Use subqueries to display all actors who appear in the film `Alone Trip`

select last_name, first_name
from actor
where actor_id in
(select actor_id from film_actor
where film_id in 
(select film_id from film
where title = "Alone Trip"));

/*c. You want to run an email marketing campaign in Canada, 
for which you will need the names and email addresses of all Canadian customers. 
Use joins to retrieve this information.*/

select country, last_name, first_name, email
from country
left join customer on country.country_id = customer.customer_id
where country = 'Canada';


/* d. Sales have been lagging among young families,
 and you wish to target all family movies for a promotion. 
 Identify all movies categorized as _family_ films.*/

select title, category
from film_list
where category = 'Family';

/*e. Display the most frequently rented movies in descending order. */

select film.title, count(rental.inventory_id)
from inventory 
inner join rental on inventory.inventory_id = rental.inventory_id
inner join film on inventory.film_id = film.film_id
group by rental.inventory_id
order by count(rental.inventory_id) desc;

-- f. Write a query to display how much business, in dollars, each store brought in.

select store.store_id, sum(amount)
from store
inner join staff on store.store_id = staff.store_id
inner join payment on payment.staff_id = staff.staff_id
group by store.store_id
order by sum(amount);

-- g. Write a query to display for each store its store ID, city, and country.

select store_id, city, country
from store
join address on store.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id;

/*h. List the top five genres in gross revenue in descending order. 
(**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.) */

select category, sum(amount)
from film_list
join film on film_list.title = film.title
join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on rental.rental_id = payment.rental_id
group by category
order by sum(amount) desc
limit 5;

-- Question 8
/* a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.*/
create view top_five_genres as 
select category, sum(amount)
from film_list
join film on film_list.title = film.title
join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on rental.rental_id = payment.rental_id
group by category
order by sum(amount) desc
limit 5;

-- b. How would you display the view that you created in 8a?
select * from top_five_genres;

-- c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view top_five_genres;
