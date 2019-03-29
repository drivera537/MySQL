use sakila;

-- Display the first and last names of all actors from the table `actor`
select first_name, last_name
from actor;

-- Display the first and last name of each actor in a single 
-- column in upper case letters. Name the column `Actor Name`.
select concat(first_name," ", last_name) as "Actor Name"
from actor;

-- You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, 
-- "Joe." What is one query would you use to obtain this information?

select actor_id, first_name, last_name
from actor where first_name = "Joe";

-- Find all actors whose last name contain the letters `GEN`:
select first_name, last_name, locate ("GEN", last_name)
from actor where locate("GEN", last_name);

-- Find all actors whose last names contain the letters `LI`. 
-- This time, order the rows by last name and first name, in that order:

select last_name, first_name, locate ("LI", last_name)
from actor where locate("LI", last_name);

-- Using `IN`, display the `country_id` and `country` columns of the following countries: 
-- Afghanistan, Bangladesh, and China:

select country_id, country
from country
where country IN ('Afghanistan', 'Bangladesh', 'China');

-- You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table `actor` named `description` and use the data type `BLOB` 
-- (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).

ALTER TABLE actor
ADD COLUMN description blob(15) AFTER last_name;

-- Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the `description` column.

alter table actor
drop column description;

-- List the last names of actors, as well as how many actors have that last name.
select last_name, COUNT(*) c 
FROM actor GROUP BY last_name HAVING c >= 1;

-- List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors 

select last_name, COUNT(*) c 
FROM actor GROUP BY last_name HAVING c > 1;

-- The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. 
-- Write a query to fix the record.

update actor set first_name = 'HARPO', last_name = 'WILLIAMS'
where first_name = 'GROUCHO';

-- Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
-- It turns out that `GROUCHO` was the correct name after all! In a single query, 
-- if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

update actor set first_name = 'GROUCHO', last_name = 'WILLIAMS'
where first_name = 'HARPO';

-- You cannot locate the schema of the `address` table. Which query would you use to re-create it?

show create table address;

-- Use `JOIN` to display the first and last names, as well as the address, 
-- of each staff member. Use the tables `staff` and `address`:


select staff.first_name, staff.last_name, address.address
from staff 
join address on staff.address_id = address.address_id;

-- Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
-- Use tables `staff` and `payment`.

select staff.first_name, staff.last_name, payment.amount, payment.payment_date
from staff
left join payment on staff.staff_id = payment.staff_id
where cast (payment_date AS DATETIME) + payment_date BETWEEN '2005-08-01 00:00:00' AND '2005-08-31 23:59:00';

