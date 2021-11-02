### How websites store info => databases
# relational => tables

### 2 parts of storing / accessing
# database mgmt system: app that stores data at scale and queried for database
# querying language

### relational db mgmt sys
# app that stores data at scale / organizes data in tables

### language / communication w db
# sql: structured query language DSL for relational db
# every col must have datatype specified

### postgresql shell comands
#$ psql
# CREATE DATABSE lecture;
#$ psql lecture
# \d => list tables
# \d table => show schema for tables
# \? list meta commands
# end queries with a ;

### basic sql queries
# SELECT: choose columns to extract from
# FROM: specifies relation (table) you're getting data FROM
# WHERE/WHERE NOT: filters data according to logical exp
  # =, >=, <=, >, <, <>/!=
  # IN, BETWEEN, LIKE, (%)
  # AND, OR
# ORDER BY: sorts results based on specific col
  # ASC, DESC
  # ASC (default)
# LIMIT: how many rows you want in result
# OFFSET: how many rows skip from top
# DISTINCT: removes dups, like arr.uniq
  # SELECT DISTINCT name, type
  # SELECT COUNT(DISTINCT name,)

### NULL
# comparisons to NULL don't work in sql
# represents unknown val
# not a value, it's a non-val
# use NULL and IS NOT NULL to check for null vals

### AGGREGATE FUNCTION
# SUM, AVG, COUNT(*)...
# SELECT COUNT(DISTINCT type) as num_types FROM possessions;

### GROUP BY
# SELECT type FROM possessions GROUP BY type;
# SELECT type, COUNT(*) AS num_items FROM possessions GROUP BY type;
# SELECT type, AVG(*) AS avg_cost FROM possessions GROUP BY type;
# SELECT type, COUNT(*) AS num_items FROM possessions GROUP BY type HAVING COUNT(*) > 5;

### WHERE v. HAVING
# WHERE evaluated before GROUP BY => grouped entries can't be filtered by WHERE
# HAVING evaluated after GROUP BY
# agg fxns are not allowed in where


### ORDER OF OPERATION FOR EXECUTION
# FROM
# JOIN
# WHERE
# GROUP BY
# HAVING
# SELECT
# ORDER BY
# LIMIT / OFFSET


### SUBQUERIES => most common item, cost over $1000
# SELECT *
# FROM possessions
# WHERE
  # cost > 1000
  # name IN (                    # name is included in this subquery
      # SELECT name              # most common item
      # FROM possessions
      # GROUP BY name
      # ORDER BY COUNT(*) DESC
      # LIMIT 1
      # );

# how many types of poss have a total cost over $200?
# SELECT COUNT(*)
# FROM (
  # SELECT type
  # FROM possessions
  # GROUPBY type
  # HAVING SUM(cost) > 200
  # ) AS pricey_posessions;         # FROM needs alias "pricey_posessions"

# who is the owner of the most expensive item - subquery: most expensive item; then instructor
# foreign id to link subquery
# most expensive item => # SELECT * FROM possessions ORDER BY cost DESC LIMIT 1
# owner_id will link ^ to name

# SELECT name
# FROM instructors
# WHERE id = (
  # SELECT owner_id
  # FROM possessions
  # ORDER BY cost DESC
  # LIMIT 1
  # )                               # WHERE doesn't need alias



### When do we join tables rather than using a subquery?
# lots of data across many tables
# subqueries use less memory than joins
# subqueries use more CPU than joins (CPU is usually the bottleneck)
# in practice, this can differ between sql engines

### JOINS
# combine data from multiple tables into one relation using a JOIN
# type of relationships between tables
# one-to many (hierachical)
# many-to-many (horizontal)

### 3 most common JOINS
# INNER JOIN - returns only rows from table1, table2 that match each other. that is the default
# LEFT OUTER JOIN - same as LEFT JOIN - returns all rows in table1, whether or not they match table2 - not supported by all engines
# FULL OUTER JOIN -

### show name of all possessions and their owner_id
# SELECT ny_instructors.name AS owner_name,
      #  possessions.name AS posession_name
# FROM ny_instructors
# JOIN possessions ON ny_instructors.id = possessions.owner_id

### find the total num of possessions owned by each person
# SELECT ny_instructors.name AS owner_name,
      #  COUNT(possessions.name) AS total_possessions
# FROM ny_instructors
# JOIN possessions ON ny_instructors.id = possessions.owner_id
# GROUP BY ny_instructors.name

### which new york instructors don't have any possessions
# SELECT ny_instructors.name AS owner_name
# FROM ny_instructors
# LEFT OUTER JOIN possessions ON ny_instructors.id = possessions.owner_id
# WHERE possessions.id IS NULL;

### get all friendships between SF and NY instructors
# SELECT *
# FROM ny_instructors                                                # which table we're starting from
# JOIN friendship ON ny_instructors.id = friendships.ny_id           # now ny tied to friendships table
# JOIN sf_instructors ON friendships.sf_id = sf_instructors.id       # now friendships tied to sf
# WHERE


### WHAT IS A SELF JOIN
# joins a table back against itself
# must alias the table names
# use descriptive aliases


### get all aa instructors who are also pod leaders - use self join - bc foreign key something something - self referential something ??
# SELECT DISTINCT pod_leaders.names                 # what you wanna return
# FROM ny_instructors AS instructors                # join NY inst to NY inst and alias twice
# JOIN ny_instructors AS pod_leaders
     # ON instructors.pod_leader_id = pod_leaders.id;
