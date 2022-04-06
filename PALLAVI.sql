USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

select count(*) from director_mapping;
select count(*) from genre;
select count(*) from movie;
select count(*) from names;
select count(*) from ratings;
select count(*) from role_mapping;


-- THESE STMTS WILL COUNT THE NO OF COLUMNS IN GIVEN SCHEMA WITH NAME IMBD


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- select * from movie limit 2;
SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS NULL_ID,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS NULL_TITLE,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS NULL_YEAR,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS NULL_DATEPUBLISHED,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS NULL_DURATION,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS NULL_COUNTRY,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS NULL_GROSSINCOME,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS NULL_LANGUAGES,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS NULL_PRDCOMPANY
FROM   movie; 


-- IF THERE IS NO VALUE OR NULL IT WILL RETURN 1 ELSE IT WILL RETURN 
-- NO OF TIMES IT WILL RETURN 1 WILL GET ADDED USING SUM FUNCTION TO FIND TOTAL NULL VALUES IN EACH COLUMN


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year     AS Year,
       Count(id)AS number_of_movies
FROM   movie
GROUP  BY year;
-- USING COUNT ALL ID ARE COUNTED TO GET COUNT PER YEAR
SELECT Month(date_published) AS month_num,
       Count(id)             AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 
-- USING COUNT ALL ID ARE COUNTED TO GET COUNT PER MONTH .MONTH IS EXTRACTED USING MONTH()







/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT Count(id) AS movie_count,year
FROM   movie
WHERE  ( country LIKE '%USA%'
          OR country LIKE '%India%' )
       AND year = 2019; 
-- IN COLUMNS IF ANY OF THE VALUE MATCHES WITH USA OR  INDIA THEN FOR THESE COUNTRIES ID ARE COUNTED 
/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT( genre )
FROM   genre; 


-- DISTINCT WILL RETURN UNIQUE GENRE LIST

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
WITH top_genre AS
(
           SELECT     genre,
                      Count(g.movie_id) AS movies_count ,
                      year
           FROM       genre g
           INNER JOIN movie m
           ON         g.movie_id=m.id
           GROUP BY   genre
           ORDER BY   Count(g.movie_id) DESC)
SELECT genre,
       movies_count ,
       year
FROM   top_genre
ORDER BY movies_count DESC 
;
-- GENRE WISE WE CAN COUNT THE NO OF IDS AND USING ORDER BY AND DESC WE FIND THE TOP GENRE

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_select
     AS (SELECT Count(genre)AS count_genre,
                movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING count_genre = 1)
SELECT Count(movie_id)
FROM   genre_select; 

-- HERE WE CALUCLATE THE GENRE COUNT AND WITH THE MOVIE_ID WE FIND HOW MANY BELONGS TO 1 GENRE ONLY

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre,
       round(Avg(duration),2) AS avg_duration
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
GROUP  BY genre
ORDER  BY avg_duration DESC; 
-- USING AVG FUNCTION WE FIND THE AVERAGE DURATION AND ROUNDED IT UP TO 2 DECIMAL POINTS

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
DROP VIEW IF EXISTS thriller_genre_rank ;
/* In the above  drop command we are dropping the views incase it exists before*/

CREATE VIEW thriller_genre_rank
AS
  SELECT genre,
         Count(movie_id)                    AS movie_count,
         Rank()
           OVER (
             ORDER BY Count(movie_id) DESC) AS genre_rank
  FROM   genre
  GROUP  BY genre;
-- VIEW IS CREATED TO FIND THE GENRE RANK OF ALL GENRE 
SELECT *
FROM   thriller_genre_rank
WHERE  genre = "thriller"; 

-- FILTERED OUT THE RANK OF THRILLER GENRE


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings; 

/* MIN,MAX ARE THE PREDEFINED FUNCTIONS TO GET MINIMUM AND MAXIMUM VALUES OF ANY COLUMNS */


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH top10_rank
     AS (SELECT title,
                avg_rating,
                Dense_rank()
                  OVER(
                    ORDER BY avg_rating DESC) AS movie_rank
         FROM   ratings r
                INNER JOIN movie m
                        ON r.movie_id = m.id)
SELECT *
FROM   top10_rank
WHERE  movie_rank <= 10; 

/* USING DENSE_RANK FUNCTION HERE WE ARE CHECKING TOP 10 MOVIES */



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings 
GROUP  BY median_rating
ORDER  BY median_rating; 

-- WE HAVE TO FIND MOVIE COUNT PER MEDIAN RATING 
-- HERE USING COUNT FUNCTION WE CALCULATE THE COUNT AND GROUPED IT USING THE MEDIAN_RATING COLUMN

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
/* IN PRODUCTION_COMPANY COLUMN FEW VALUES ARE NULL AND HAVING MAXIMUM
 COUNT OF MOVIES,SO WE ARE NOT CONSIDERING THOSE ROWS TO FIND THE RANK */
 
WITH top_production_company
     AS (SELECT production_company,
                Count(id)                    AS movie_count,
                Dense_rank()
                  OVER(
                    ORDER BY Count(id) DESC) AS prod_comapny_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   top_production_company
WHERE  prod_comapny_rank = 1; 
-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT DISTINCT( genre )         AS genre,
               Count(g.movie_id) AS movie_count
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country = "USA"
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY Count(g.movie_id); 

-- HERE WE HAVE TO SATISFY VARIOUS CONDITIONS TO GET ANSWERS
-- IF WE NEED TO SATISFY ALL MENTIONED CONDITIONS WE HAVE TO USE "AND" LOGICAL FUNCTION


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT title,
       avg_rating,
       genre
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON r.movie_id = g.movie_id
WHERE  title REGEXP '^The'
       AND avg_rating > 8
ORDER  BY avg_rating; 

-- REGEXP IS FOR PATTERN MATCHING

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
-- select date_published from movie;  yyyy-mm-dd
SELECT Count(movie_id),
       median_rating,
       date_published
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND median_rating = 8
ORDER  BY date_published; 


-- BETWEEN IS USED TO FIND THE RECORDS WITHIN RANGE MENTIONED 



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
--- select languages from movie;
SELECT languages,
       total_votes AS total_votes
FROM   ratings r
       INNER JOIN movie m
               ON m.id = r.movie_id
WHERE  languages = "german"
        OR languages = "italian"
GROUP  BY languages; 

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT Sum(CASE
             WHEN NAME IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM   names; 

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top3_genre AS
(
           SELECT     genre,
                      Count(g.movie_id) AS movie_count
           FROM       movie m
           INNER JOIN ratings r
           ON         r.movie_id=m.id
           INNER JOIN genre g
           ON         g.movie_id=m.id
           WHERE      avg_rating>8
           GROUP BY   genre
           ORDER BY   Count(g.movie_id) DESC limit 3 ), top3_directors AS
(
           SELECT     NAME                                         AS director_name,
                      Count(g.movie_id)                            AS movie_count,
                      Rank() OVER(ORDER BY Count(g.movie_id) DESC) AS director_rank
           FROM       names n
           INNER JOIN director_mapping dm
           ON         n.id=dm.name_id
           INNER JOIN genre g
           ON         dm.movie_id=g.movie_id
           INNER JOIN ratings r
           ON         r.movie_id= g.movie_id,
                      top3_genre
           WHERE      g.genre IN (top3_genre.genre)
           AND        avg_rating>8
           GROUP BY   director_name
           ORDER BY   movie_count DESC)
SELECT director_name,
       movie_count
FROM   top3_directors
WHERE  director_rank<=3;



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top2_actors AS
(
           SELECT     NAME              AS actor_name ,
                      Count(r.movie_id) AS movie_count
           FROM       names n
           INNER JOIN role_mapping rm
           ON         n.id = rm.name_id
           INNER JOIN movie m
           ON         m.id = rm.movie_id
           INNER JOIN ratings r
           ON         r.movie_id = m.id
           WHERE      r.median_rating >= 8
           GROUP BY   actor_name
           ORDER BY   movie_count DESC)
SELECT *
FROM   top2_actors LIMIT 2;
/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH top3_production_company
     AS (SELECT production_company,
                Sum(total_votes)                    AS vote_count,
                Rank()
                  OVER(
                    ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         GROUP  BY production_company)
SELECT *
FROM   top3_production_company
WHERE  prod_comp_rank <= 3;




/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- WEIGHTED AVERAGE IS CALCULATED AS  the sum of (PERCENT_MARGIN * UNITS) divided by the sum of UNITS
WITH top_actors
     AS (SELECT NAME
                AS
                actor_name,
                total_votes,
                Count(m.id)
                AS
                   movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2)
                AS
                   actor_avg_rating,
                Dense_rank()
                  OVER(
                    ORDER BY Sum(avg_rating*total_votes)/Sum(total_votes)DESC )
                AS
                   actor_rank
        FROM   ratings r
                INNER JOIN movie m
                        ON r.movie_id = m.id
                INNER JOIN role_mapping rm
                        ON rm.movie_id = m.id
                INNER JOIN names n
                        ON n.id = rm.name_id
         WHERE  country = "india"
                AND category = "actor"
         GROUP  BY NAME
         HAVING Count(m.id) >= 5)
SELECT actor_name,
       total_votes,
       movie_count,
       actor_avg_rating,
       actor_rank
FROM   top_actors; 

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top5_actresses
     AS (SELECT NAME
                AS
                   actress_name,
                total_votes,
                Count(m.id)
                AS
                   movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2)
                AS
                   actress_avg_rating,
                Dense_rank()
                  OVER(
                    ORDER BY (Sum(avg_rating*total_votes)/Sum( total_votes))
                  DESC )
                AS
                actress_rank
         FROM   ratings r
                INNER JOIN movie m
                        ON r.movie_id = m.id
                INNER JOIN role_mapping rm
                        ON rm.movie_id = m.id
                INNER JOIN names n
                        ON n.id = rm.name_id
         WHERE  country = "india"
                AND languages = "hindi"
                AND category = "actress"
         GROUP  BY NAME
         HAVING Count(m.id) >= 3)
SELECT actress_name,
       total_votes,
       movie_count,
       actress_avg_rating,
       actress_rank
FROM   top5_actresses
WHERE  actress_rank <= 5; 
/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT title,
       genre,
       avg_rating,
       CASE
         WHEN avg_rating > 8 THEN "superhit movies"
         WHEN avg_rating BETWEEN 7 AND 8 THEN "hit movies"
         WHEN avg_rating BETWEEN 5 AND 7 THEN "one-time-watch movies"
         WHEN avg_rating < 5 THEN 'Flop movie'
       END AS MOVIE_STATUS
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  genre = "thriller"
ORDER  BY avg_rating DESC; 




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_duration AS
(
           SELECT     genre,
                      Round(Avg(duration), 2) AS avg_duration
           FROM       movie m
           INNER JOIN genre g
           ON         m.id = g.movie_id
           GROUP BY   genre )
SELECT   *,
         sum(avg_duration) OVER w1 AS running_total_duration,
         avg(avg_duration) OVER w2 AS moving_avg_duration
FROM     genre_duration window w1  AS (ORDER BY genre rows UNBOUNDED PRECEDING) ,
         w2                        AS (ORDER BY genre rows 13 PRECEDING);

-- I USED HERE WINDOW FUNCTION AND USED IT IN SELECT STMT

-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

DROP VIEW IF EXISTS convert_inr;

DROP VIEW IF EXISTS remove_$;

DROP VIEW IF EXISTS currency_convert; /* In the above three drop commands we are dropping the views incase it exists before*/
CREATE VIEW convert_inr
AS
  (SELECT id,
          Convert(Replace(Replace (worlwide_gross_income, 'INR', ''), ' ', ''),
          decimal) *
          0.013 AS gross_income
   FROM   movie
   WHERE  Substr(worlwide_gross_income, 1, 3) = 'INR'); /* A view called convert_inr is created to convert three worldwide_gross_income values which were in INR currency to dollars as per
                                                          current conversion rate. Also we have replaced the substring INR from the worldwide_gross_income column to make it standardized numeric column*/
CREATE VIEW remove_$
AS
  (SELECT id,
          Convert(Replace(Replace (worlwide_gross_income, '$', ''), ' ', ''),
          decimal) AS
          gross_income
   FROM   movie
   WHERE  Substr(worlwide_gross_income, 1, 1) = '$'); /* And we have created an another view remove_$ we have replaced the substring $ from the worldwide_gross_income column 
                                                        to make it standardized numeric column */
CREATE VIEW currency_convert
AS
  (SELECT *
   FROM   convert_inr
   UNION ALL
   SELECT *
   FROM   remove_$); /* We have taken a union all of both above views created inorder to get the complete
                                 standardized numeric column for worldwide_gross_income.
                                                   In this current view we have also removed the null values that was present in worldwide_gross_income
                                                   field which gave us 4273 records*/
WITH genre_data
     AS (WITH top_3_genre
              AS (SELECT genre,
                         COUNT(movie_id)                    AS number_of_movies,
                         RANK()
                           OVER(
                             ORDER BY COUNT(movie_id) desc) AS genre_rank
                  FROM   genre AS g
                         INNER JOIN movie AS m
                                 ON g.movie_id = m.id
                  GROUP  BY genre)
         SELECT genre
          FROM   top_3_genre
          WHERE  genre_rank < 4),
     top_5
     AS (SELECT genre,
                YEAR,
                title                           AS movie_name,
                worlwide_gross_income,
                DENSE_RANK()
                  OVER(
                    PARTITION BY YEAR
                    ORDER BY gross_income desc) AS movie_rank
         FROM   movie AS m
                INNER JOIN currency_convert cc USING(id)
                INNER JOIN genre AS g
                        ON m.id = g.movie_id
         WHERE  genre IN (SELECT genre
                          FROM   genre_data))
SELECT *
FROM   top_5
WHERE  movie_rank <= 5; 






-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT     production_company,
           Count(movie_id),
           Rank()OVER(ORDER BY Count(movie_id) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id=r.movie_id
WHERE      median_rating>=8
AND        position(',' IN languages)>0
AND        production_company IS NOT NULL
GROUP BY   production_company limit 2;



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

 WITH top3_actresses
     AS (SELECT NAME                                AS actress_name,
                Sum(total_votes)                    AS total_votes,
                Count(g.movie_id)                   AS movie_count,
                avg_rating                          AS actress_avg_rating,
                row_number()
                  OVER(
                    ORDER BY  Count(g.movie_id)  DESC) AS actress_rank
         FROM   genre g
                INNER JOIN ratings r
                        ON r.movie_id = g.movie_id
                INNER JOIN movie m
                        ON m.id = r.movie_id
                INNER JOIN role_mapping rm
                        ON rm.movie_id = m.id
                INNER JOIN names n
                        ON n.id = rm.name_id
         WHERE  genre = 'drama'
                AND avg_rating > 8
                AND category = 'actress'
         GROUP  BY NAME
         ORDER BY actress_avg_rating DESC)
SELECT *
FROM   top3_actresses
WHERE  actress_rank <= 3; 



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH directors AS
(
           SELECT     name_id AS director_id,
                      NAME    AS director_name,
                      r.movie_id ,
                      duration,
                      avg_rating,
                      date_published,
                      total_votes,
                      Lead(date_published, 1) OVER( partition by name ORDER BY date_published) AS next_date
           FROM       ratings r
           INNER JOIN movie m 
           ON         m.id = r.movie_id
           INNER JOIN director_mapping dm
           ON         dm.movie_id = m.id
           INNER JOIN names n 
           ON         n.id = dm.name_id )
SELECT   director_id,
         director_name,
         Count(movie_id)                                                     AS number_of_movies,
         Round(Sum(Datediff(next_date, date_published))/(Count(movie_id)-1)) AS avg_inter_movie_days,
         avg_rating,
         Sum(total_votes) AS total_votes,
         Min(avg_rating)  AS min_rating,
         Max(avg_rating)  AS max_rating,
         Sum(duration)    AS total_duration
FROM     directors
GROUP BY director_id
ORDER BY number_of_movies DESC limit 9;



