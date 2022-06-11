CREATE SCHEMA hive.bronze WITH (location='s3a://bronze/')

CREATE SCHEMA hive.silver WITH (location='s3a://silver/')

CREATE SCHEMA hive.gold WITH (location='s3a://gold/')

CREATE TABLE hive.bronze.titles (
  id VARCHAR,
  title VARCHAR,
  type VARCHAR,
  description VARCHAR,
  release_year VARCHAR,
  age_certification VARCHAR,
  runtime VARCHAR,
  genres VARCHAR,
  production_countries VARCHAR,
  seasons VARCHAR,
  imdb_id VARCHAR,
  imdb_score VARCHAR,
  imdb_votes VARCHAR,
  tmdb_popularity VARCHAR,
  tmdb_score VARCHAR
) WITH (
  format='CSV',
  external_location='s3a://bronze/titles/',
  skip_header_line_count=1
)

CREATE TABLE hive.bronze.credits (
  person_id VARCHAR,
  id VARCHAR,
  name VARCHAR,
  character VARCHAR,
  role VARCHAR
) WITH (
  format='CSV',
  external_location='s3a://bronze/credits/',
  skip_header_line_count=1
)

CREATE TABLE delta.silver.titles (
  id VARCHAR,
  title VARCHAR,
  type VARCHAR,
  description VARCHAR,
  release_year VARCHAR,
  age_certification VARCHAR,
  runtime VARCHAR,
  genres VARCHAR,
  production_countries VARCHAR,
  seasons VARCHAR,
  imdb_id VARCHAR,
  imdb_score VARCHAR,
  imdb_votes VARCHAR,
  tmdb_popularity VARCHAR,
  tmdb_score VARCHAR
) WITH (
  location='s3a://silver/titles/'
)

CREATE TABLE delta.silver.credits (
  person_id INTEGER,
  id VARCHAR,
  name VARCHAR,
  character VARCHAR,
  role VARCHAR
) WITH (
  location='s3a://silver/credits/'
)

CREATE TABLE delta.gold.war_movies_participation (
  name VARCHAR,
  total INTEGER
) WITH (
  location = 's3a://gold/war_movies_participation'
)

CREATE TABLE delta.gold.kafka_demo (
  name VARCHAR,
  idade INTEGER
) WITH (
  location = 's3a://gold/kafka_demo'
)
