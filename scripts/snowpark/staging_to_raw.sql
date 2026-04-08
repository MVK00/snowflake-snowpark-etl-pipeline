##########################################################################################
# Step 1 - To start, we must first import our Snowpark Package
##########################################################################################
# Note: You can add more packages by selecting them using the Packages control and then importing them.

import snowflake.snowpark as snowpark

##########################################################################################
# Step 2 - Truncate the tables before loading the files data into the staging tables
##########################################################################################

def main(session: snowpark.Session):

    # Use SQL to set the current database and schema
    session.sql('USE SCHEMA SNOWPARK_DB.STAGING').collect()

    # Use SQL to Truncate the India Sales Order table
    session.sql('TRUNCATE TABLE SNOWPARK_DB.STAGING.INDIA_SALES_ORDER_CP').collect()

    # Use SQL to Truncate the Usa Sales Order table
    session.sql('TRUNCATE TABLE SNOWPARK_DB.STAGING.USA_SALES_ORDER_CP').collect()

    # Use SQL to Truncate the France Sales Order table
    session.sql('TRUNCATE TABLE SNOWPARK_DB.STAGING.FRANCE_SALES_ORDER_CP').collect()

##########################################################################################
# Step 3 - Load the file data to the respective copy tables
##########################################################################################

# Load the India Sales Order table
    session.sql("""COPY INTO SNOWPARK_DB.STAGING.INDIA_SALES_ORDER_CP
                   FROM @SNOWPARK_DB.STAGING.SNOWPARK_STAGE/India-Sales-Order.csv
                   FILE_FORMAT = (TYPE = CSV SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"')""").collect()
    
    # Load the Usa Sales Order table
    session.sql("""COPY INTO SNOWPARK_DB.STAGING.USA_SALES_ORDER_CP
                   FROM @SNOWPARK_DB.STAGING.SNOWPARK_STAGE/USA-Sales-Order.snappy.parquet
                   FILE_FORMAT = (TYPE = PARQUET)""").collect()
    
    # Load the France Sales Order table
    session.sql("""COPY INTO SNOWPARK_DB.STAGING.FRANCE_SALES_ORDER_CP
                   FROM @SNOWPARK_DB.STAGING.SNOWPARK_STAGE/France-Sales-Order.json
                   FILE_FORMAT = (TYPE = JSON)""").collect()
    
    
    ##########################################################################################
    # Step 4 - Load the data from the COPY tables to the RAW tables
    ##########################################################################################
    
    # Create the India Sales Order raw table dataframe
    df_india_sales_read = session.sql("""SELECT
        ORDER_ID,
        CUSTOMER_NAME,
        MOBILE_MODEL,
        QUANTITY,
        PRICE_PER_UNIT,
        TOTAL_PRICE,
        PROMOTION_CODE,
        ORDER_AMOUNT,
        GST,
        ORDER_DATE,
        PAYMENT_STATUS,
        SHIPPING_STATUS,
        PAYMENT_METHOD,
        PAYMENT_PROVIDER,
        MOBILE_NUMBER,
        DELIVERY_ADDRESS,
        CURRENT_TIMESTAMP() AS INSERT_DTS
    FROM SNOWPARK_DB.STAGING.INDIA_SALES_ORDER_CP""")

# Save above Dataframe as a India Sales order raw table
    df_india_sales_read.write.mode("overwrite").save_as_table("SNOWPARK_DB.RAW.INDIA_SALES_ORDER")


# Create the USA Sales Order raw table dataframe
    df_usa_sales_read = session.sql("""SELECT
        SOURCE_DATA:"Customer Name"::VARCHAR(1000) AS CUSTOMER_NAME,
        SOURCE_DATA:"Delivery Address"::VARCHAR(1000) AS DELIVERY_ADDRESS,
        SOURCE_DATA:"Mobile Model"::VARCHAR(1000) AS MOBILE_MODEL,
        SOURCE_DATA:"Order Amount"::VARCHAR(1000) AS ORDER_AMOUNT,
        SOURCE_DATA:"Order Date"::VARCHAR(1000) AS ORDER_DATE,
        SOURCE_DATA:"Order ID"::VARCHAR(1000) AS ORDER_ID,
        SOURCE_DATA:"Payment Method"::VARCHAR(1000) AS PAYMENT_METHOD,
        SOURCE_DATA:"Payment Provider"::VARCHAR(1000) AS PAYMENT_PROVIDER,
        SOURCE_DATA:"Payment Status"::VARCHAR(1000) AS PAYMENT_STATUS,
        SOURCE_DATA:"Phone"::VARCHAR(1000) AS PHONE,
        SOURCE_DATA:"Price per Unit"::VARCHAR(1000) AS PRICE_PER_UNIT,
        SOURCE_DATA:"Promotion Code"::VARCHAR(1000) AS PROMOTION_CODE,
        SOURCE_DATA:"Quantity"::VARCHAR(1000) AS QUANTITY,
        SOURCE_DATA:"Shipping Status"::VARCHAR(1000) AS SHIPPING_STATUS,
        SOURCE_DATA:"Tax"::VARCHAR(1000) AS TAX,
        SOURCE_DATA:"Total Price"::VARCHAR(1000) AS TOTAL_PRICE,
        CURRENT_TIMESTAMP() AS INSERT_DTS
    FROM SNOWPARK_DB.STAGING.USA_SALES_ORDER_CP""")

# Save above Dataframe as a USA Sales order raw table
    df_usa_sales_read.write.mode('overwrite').save_as_table("SNOWPARK_DB.RAW.USA_SALES_ORDER")



# Create the France Sales Order raw table dataframe
    df_france_sales_read = session.sql("""SELECT
        B.VALUE:"Customer Name"::VARCHAR(1000) AS CUSTOMER_NAME,
        B.VALUE:"Delivery Address"::VARCHAR(1000) AS DELIVERY_ADDRESS,
        B.VALUE:"Mobile Model"::VARCHAR(1000) AS MOBILE_MODEL,
        B.VALUE:"Order Amount"::VARCHAR(1000) AS ORDER_AMOUNT,
        B.VALUE:"Order Date"::VARCHAR(1000) AS ORDER_DATE,
        B.VALUE:"Order ID"::VARCHAR(1000) AS ORDER_ID,
        B.VALUE:"Payment Method"::VARCHAR(1000) AS PAYMENT_METHOD,
        B.VALUE:"Payment Provider"::VARCHAR(1000) AS PAYMENT_PROVIDER,
        B.VALUE:"Payment Status"::VARCHAR(1000) AS PAYMENT_STATUS,
        B.VALUE:"Phone"::VARCHAR(1000) AS PHONE,
        B.VALUE:"Price per Unit"::VARCHAR(1000) AS PRICE_PER_UNIT,
        B.VALUE:"Promotion Code"::VARCHAR(1000) AS PROMOTION_CODE,
        B.VALUE:"Quantity"::VARCHAR(1000) AS QUANTITY,
        B.VALUE:"Shipping Status"::VARCHAR(1000) AS SHIPPING_STATUS,
        B.VALUE:"Tax"::VARCHAR(1000) AS TAX,
        B.VALUE:"Total Price"::VARCHAR(1000) AS TOTAL_PRICE,
        CURRENT_TIMESTAMP AS INSERT_DTS
    FROM SNOWPARK_DB.STAGING.FRANCE_SALES_ORDER_CP A,
         LATERAL FLATTEN(INPUT => A.SOURCE_DATA) B""")

# Save above Dataframe as a France Sales order raw table
    df_france_sales_read.write.mode('overwrite').save_as_table("SNOWPARK_DB.RAW.FRANCE_SALES_ORDER")


# return our Dataframe
    return "Successfully Executed the Snowpark Code to Load Raw tables from Stagging Layer"
















