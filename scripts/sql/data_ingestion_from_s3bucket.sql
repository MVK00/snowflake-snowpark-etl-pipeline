//Create the Snowpark database
CREATE OR REPLACE DATABASE SNOWPARK_DB;

//Use the newly created database
USE DATABASE SNOWPARK_DB;

//Create the respective schemas
CREATE OR REPLACE SCHEMA STAGING;    -- Schema to store the s3 data
CREATE OR REPLACE SCHEMA RAW;        -- Schema to store the Raw data(historical data)
CREATE OR REPLACE SCHEMA TRANSFORMED; -- Schema to store the transformed data
CREATE OR REPLACE SCHEMA CURATED;     -- Schema to store the curated/aggregated data

//Setup the newly create STAGING Schema
USE SCHEMA SNOWPARK_DB.STAGING;

//Create the respective COPY tables in the above Schema
//India Sales Order Copy table
CREATE OR REPLACE TABLE SNOWPARK_DB.STAGING.INDIA_SALES_ORDER_CP
(
ORDER_ID VARCHAR(100),
CUSTOMER_NAME VARCHAR(1000),
MOBILE_MODEL VARCHAR(1000),
QUANTITY VARCHAR(1000),
PRICE_PER_UNIT VARCHAR(1000),
TOTAL_PRICE VARCHAR(1000),
PROMOTION_CODE VARCHAR(1000),
ORDER_AMOUNT VARCHAR(1000),
GST VARCHAR(1000),
ORDER_DATE VARCHAR(1000),
PAYMENT_STATUS VARCHAR(1000),
SHIPPING_STATUS VARCHAR(1000),
PAYMENT_METHOD VARCHAR(1000),
PAYMENT_PROVIDER VARCHAR(1000),
MOBILE_NUMBER VARCHAR(1000),
DELIVERY_ADDRESS VARCHAR(1000)
);

//USA Sales Order Copy table
-- To store a parquet file/Json we need varient datatype column so we have created this..
CREATE OR REPLACE TABLE SNOWPARK_DB.STAGING.USA_SALES_ORDER_CP
(
SOURCE_DATA VARIANT
);

//France Sales Order Copy table
CREATE OR REPLACE TABLE SNOWPARK_DB.STAGING.FRANCE_SALES_ORDER_CP
(
SOURCE_DATA VARIANT
);

--Now to link snowflake and aws we need to create a storage integration..

//Create the Storage Integration
CREATE OR REPLACE STORAGE INTEGRATION SNOWPARK_INT
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = 'S3'
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::039612852560:role/snowflakesnowparkrole'
STORAGE_ALLOWED_LOCATIONS = ('s3://de-academy-snowpark-data-bucket1/');

describe integration SNOWPARK_INT;

--Now create external stage..
//Create the External Stage
CREATE STAGE SNOWPARK_DB.STAGING.SNOWPARK_STAGE
STORAGE_INTEGRATION = SNOWPARK_INT
URL = 's3://de-academy-snowpark-data-bucket1/';

//Validate the setup of the stage
LS @SNOWPARK_DB.STAGING.SNOWPARK_STAGE;

DESC TABLE SNOWPARK_DB.TRANSFORMED.GLOBAL_SALES_ORDER;