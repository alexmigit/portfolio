select * from movies.film;
select * from movies.actor;
select * from sakila.actor;
select * from sakila.store;
select * from sys.sys_config;

show index from film_copy;

/* Listing Constraints on a Table */
SELECT 
    tc.table_name,
    tc.constraint_name,
    kcu.column_name,
    tc.constraint_type
FROM
    information_schema.table_constraints tc,
    information_schema.key_column_usage kcu
WHERE
    tc.table_name = 'film'
        AND tc.table_schema = 'movies'
        AND tc.table_name = kcu.table_name
        AND tc.table_schema = kcu.table_schema
        AND tc.constraint_name = kcu.constraint_name;
        
/* Listing Foreign Keys without Corresponding Indexes */        
        

select * from world.country order by population desc;

SELECT 
    title AS Movie,
    description AS Plot,
    release_year AS Year,
    rating AS Rating,
    special_features AS Features
FROM
    sakila.film
ORDER BY 4 DESC;

SELECT 
    *
FROM
    movies.film
WHERE
    description IS NOT NULL
ORDER BY 4 DESC;

SELECT
    CASE
        WHEN description IS NOT NULL THEN description
        ELSE 0
    END
FROM
    movies.film;

select now() as DTM;

/* 	Leap Year Calculation */
SELECT 
    DAY(LAST_DAY(DATE_ADD(DATE_ADD(DATE_ADD(CURRENT_DATE,
                            INTERVAL - DAYOFYEAR(CURRENT_DATE) DAY),
                        INTERVAL 1 DAY),
                    INTERVAL 1 MONTH))) dy
FROM
    sys_config;

/* Copy movies.film table definition */ 
    CREATE TABLE film_copy AS SELECT * FROM
    movies.film
WHERE
    1 = 0;
    
    select * from movies.film_copy;
    
/* Copy rows from movies.film to movies.film_copy */
insert into film_copy
select * 
from film;

/* Update movies.film_copy to utf8 char set, add pk */	
ALTER TABLE `movies`.`film_copy` 
CHARACTER SET = utf8 ,
ADD PRIMARY KEY (`FilmId`);
;

/* Drop does not have rollback option */
drop table movies.film_copy;

select * from movies.film_copy; #verify film_copy table has been dropped

/* Listing tables in a schema */
SELECT 
    table_catalog, table_schema, table_name, table_comment
FROM
    information_schema.tables
WHERE
    table_schema = 'sys'
        AND table_name LIKE '%$%';

select * from sys.x$session;
select * from sys.x$statement_analysis;

/* Build delimited list with GROUP_CONCAT */
SELECT 
    releaseyear,
    GROUP_CONCAT(title
        ORDER BY title
        SEPARATOR ',') AS tits
FROM
    film
GROUP BY releaseyear;









