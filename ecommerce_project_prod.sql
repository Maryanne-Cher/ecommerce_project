-- Snowflake user creation
-- Step 1: Use an admin role
USE ROLE ACCOUNTADMIN;


-- Step 2: Create the `transform` role and assign it to ACCOUNTADMIN
CREATE ROLE IF NOT EXISTS TRANSFORM;
GRANT ROLE TRANSFORM TO ROLE ACCOUNTADMIN;


-- Step 3: Create a default warehouse
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH;
GRANT OPERATE ON WAREHOUSE COMPUTE_WH TO ROLE TRANSFORM;


-- move from Dev to Prod
-- create prod database and schema
CREATE DATABASE IF NOT EXISTS ecommerce_project_prod;
CREATE SCHEMA IF NOT EXISTS ecommerce_project_prod.source;

-- Step 5: Grant permissions to the `transform` role
GRANT ALL ON WAREHOUSE COMPUTE_WH TO ROLE TRANSFORM;
GRANT ALL ON DATABASE ecommerce_project_prod TO ROLE TRANSFORM;
GRANT ALL ON ALL SCHEMAS IN DATABASE ecommerce_project_prod TO ROLE TRANSFORM;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE ecommerce_project_prod TO ROLE TRANSFORM;
GRANT ALL ON ALL TABLES IN SCHEMA ecommerce_project_prod.source TO ROLE TRANSFORM;
GRANT ALL ON FUTURE TABLES IN SCHEMA ecommerce_project_prod.SOURCE TO ROLE TRANSFORM;


-- copy tables from dev to prod
-- oct_2019 data
CREATE OR REPLACE TABLE ecommerce_project_prod.source.oct_2019 LIKE ecommerce_project.source.oct_2019;

INSERT INTO ecommerce_project_prod.source.oct_2019
SELECT *
FROM ecommerce_project.source.oct_2019;


-- nov_2019 data
CREATE OR REPLACE TABLE ecommerce_project_prod.source.nov_2019 LIKE ecommerce_project.source.nov_2019;

INSERT INTO ecommerce_project_prod.source.nov_2019
SELECT *
FROM ecommerce_project.source.nov_2019;


-- dec_2019 data
CREATE OR REPLACE TABLE ecommerce_project_prod.source.dec_2019 LIKE ecommerce_project.source.dec_2019;

INSERT INTO ecommerce_project_prod.source.dec_2019
SELECT *
FROM ecommerce_project.source.dec_2019;


-- jan_2020 data
CREATE OR REPLACE TABLE ecommerce_project_prod.source.jan_2020 LIKE ecommerce_project.source.jan_2020;

INSERT INTO ecommerce_project_prod.source.jan_2020
SELECT *
FROM ecommerce_project.source.jan_2020;


-- feb_2020 data
CREATE OR REPLACE TABLE ecommerce_project_prod.source.feb_2020 LIKE ecommerce_project.source.feb_2020;

INSERT INTO ecommerce_project_prod.source.feb_2020
SELECT *
FROM ecommerce_project.source.feb_2020;


-- march_2020 data
CREATE OR REPLACE TABLE ecommerce_project_prod.source.mar_2020 LIKE ecommerce_project.source.mar_2020;

INSERT INTO ecommerce_project_prod.source.mar_2020
SELECT *
FROM ecommerce_project.source.mar_2020;


-- april_2020 data
CREATE OR REPLACE TABLE ecommerce_project_prod.source.apr_2020 LIKE ecommerce_project.source.apr_2020;

INSERT INTO ecommerce_project_prod.source.apr_2020
SELECT *
FROM ecommerce_project.source.apr_2020;


-- Create the `dbt` user and assign to the transform role for ecommerce_project_prod
CREATE USER IF NOT EXISTS dbt_mary
  PASSWORD='dbtPassword123'
  LOGIN_NAME='dbt_mary'
  MUST_CHANGE_PASSWORD=FALSE
  DEFAULT_WAREHOUSE='COMPUTE_WH'
  DEFAULT_ROLE=TRANSFORM
  DEFAULT_NAMESPACE='ECOMMERCE_PROJECT_PROD.SOURCE'
  COMMENT='DBT user used for data transformation';
ALTER USER dbt_mary SET TYPE = LEGACY_SERVICE;
GRANT ROLE TRANSFORM TO USER dbt_mary;

