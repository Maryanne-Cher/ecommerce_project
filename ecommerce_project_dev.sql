-- Snowflake user creation
-- Step 1: Use an admin role
USE ROLE ACCOUNTADMIN;


-- Step 2: Create the `transform` role and assign it to ACCOUNTADMIN
CREATE ROLE IF NOT EXISTS TRANSFORM;
GRANT ROLE TRANSFORM TO ROLE ACCOUNTADMIN;


-- Step 3: Create a default warehouse
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH;
GRANT OPERATE ON WAREHOUSE COMPUTE_WH TO ROLE TRANSFORM;

-- Step 4: Create a database and schema for the Ecommerce project
CREATE DATABASE IF NOT EXISTS ecommerce_project;
CREATE SCHEMA IF NOT EXISTS ecommerce_project.source;

-- Step 5: Grant permissions to the `transform` role
GRANT ALL ON WAREHOUSE COMPUTE_WH TO ROLE TRANSFORM;
GRANT ALL ON DATABASE ecommerce_project TO ROLE TRANSFORM;
GRANT ALL ON ALL SCHEMAS IN DATABASE ecommerce_project TO ROLE TRANSFORM;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE ecommerce_project TO ROLE TRANSFORM;
GRANT ALL ON ALL TABLES IN SCHEMA ecommerce_project.source TO ROLE TRANSFORM;
GRANT ALL ON FUTURE TABLES IN SCHEMA ecommerce_project.SOURCE TO ROLE TRANSFORM;

-- Step 6: Create Stage
CREATE OR REPLACE STAGE source.ecommerce_stage
 URL= 's3://ecommerce-behavior-mkk'
CREDENTIALS=(AWS_KEY_ID='' AWS_SECRET_KEY='');

--Step 7: Create tables
USE DATABASE ecommerce_project

-- load raw data for month of October
CREATE OR REPLACE TABLE source.oct_2019 (
  event_time STRING,
  event_type VARCHAR,
  product_id INTEGER,
  category_id BIGINT,
  category_code VARCHAR,
  brand VARCHAR,
  price FLOAT,
  user_id BIGINT,
  user_session VARCHAR
);

--load data from s3 bucket
COPY INTO ecommerce_project.source.oct_2019
FROM '@ecommerce_stage/2019-Oct.csv'
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- load raw data for month of November
CREATE OR REPLACE TABLE source.nov_2019 (
  event_time STRING,
  event_type VARCHAR,
  product_id INTEGER,
  category_id BIGINT,
  category_code VARCHAR,
  brand VARCHAR,
  price FLOAT,
  user_id BIGINT,
  user_session VARCHAR
);

--load data from s3 bucket
COPY INTO ecommerce_project.source.nov_2019
FROM '@ecommerce_stage/2019-Nov.csv'
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- load raw data for month of December
CREATE OR REPLACE TABLE source.Dec_2019 (
  event_time STRING,
  event_type VARCHAR,
  product_id INTEGER,
  category_id BIGINT,
  category_code VARCHAR,
  brand VARCHAR,
  price FLOAT,
  user_id BIGINT,
  user_session VARCHAR
);

--load data from s3 bucket
COPY INTO ecommerce_project.source.dec_2019
FROM '@ecommerce_stage/2019-Dec.csv'
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- load raw data for month of January
CREATE OR REPLACE TABLE source.Jan_2020 (
  event_time STRING,
  event_type VARCHAR,
  product_id INTEGER,
  category_id BIGINT,
  category_code VARCHAR,
  brand VARCHAR,
  price FLOAT,
  user_id BIGINT,
  user_session VARCHAR
);

--load data from s3 bucket
COPY INTO ecommerce_project.source.jan_2020
FROM '@ecommerce_stage/2020-Jan.csv'
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- load raw data for month of February
CREATE OR REPLACE TABLE source.Feb_2020 (
  event_time STRING,
  event_type VARCHAR,
  product_id INTEGER,
  category_id BIGINT,
  category_code VARCHAR,
  brand VARCHAR,
  price FLOAT,
  user_id BIGINT,
  user_session VARCHAR
);

--load data from s3 bucket
COPY INTO ecommerce_project.source.feb_2020
FROM '@ecommerce_stage/2020-Feb.csv'
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- load raw data for month of March
CREATE OR REPLACE TABLE source.mar_2020 (
  event_time STRING,
  event_type VARCHAR,
  product_id INTEGER,
  category_id BIGINT,
  category_code VARCHAR,
  brand VARCHAR,
  price FLOAT,
  user_id BIGINT,
  user_session VARCHAR
);

--load data from s3 bucket
COPY INTO ecommerce_project.source.mar_2020
FROM '@ecommerce_stage/2020-Mar.csv'
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- load raw data for month of April
CREATE OR REPLACE TABLE source.apr_2020 (
  event_time STRING,
  event_type VARCHAR,
  product_id INTEGER,
  category_id BIGINT,
  category_code VARCHAR,
  brand VARCHAR,
  price FLOAT,
  user_id BIGINT,
  user_session VARCHAR
);

--load data from s3 bucket
COPY INTO ecommerce_project.source.apr_2020
FROM '@ecommerce_stage/2020-Apr.csv'
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- Create the `dbt` user and assign to the transform role
CREATE USER IF NOT EXISTS dbt_mary
  PASSWORD='dbtPassword123'
  LOGIN_NAME='dbt_mary'
  MUST_CHANGE_PASSWORD=FALSE
  DEFAULT_WAREHOUSE='COMPUTE_WH'
  DEFAULT_ROLE=TRANSFORM
  DEFAULT_NAMESPACE='ECOMMERCE_PROJECT.SOURCE'
  COMMENT='DBT user used for data transformation';
ALTER USER dbt SET TYPE = LEGACY_SERVICE;
GRANT ROLE TRANSFORM TO USER dbt_mary;
