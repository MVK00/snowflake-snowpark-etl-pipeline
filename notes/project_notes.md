# 📘 Snowflake Snowpark Data Pipeline – Project Notes

---

## 🎯 Project Objective

The goal of this project is to build an **end-to-end data pipeline** using:

* AWS (IAM, S3, Glue)
* Snowflake (Stages, Schemas, Tables)
* Snowpark (Python for transformations)

This pipeline ingests raw data, processes it through multiple layers, and produces **analytics-ready datasets**.

---

## 🏗️ Overall Architecture

```
GitHub → AWS Glue → AWS S3 → Snowflake
                                ↓
                    STAGING → RAW → TRANSFORMED → CURATED
```

---

## ☁️ Step 1: AWS Setup

### 🔹 IAM Role Creation

* Created an IAM Role in AWS
* Defined **Trust Policy** to allow Snowflake access

### 🔹 Purpose

* Enables secure communication between:

  * Snowflake
  * AWS S3

---

## 🔄 Step 2: Data Ingestion using AWS Glue

* AWS Glue is used to:

  * Extract data from GitHub
  * Load data into S3 bucket

### ✅ Outcome

* Data is available in S3 for Snowflake to consume

---

## 🔗 Step 3: Snowflake ↔ AWS Integration

### 🔹 Storage Integration

A **Storage Integration** is created to securely connect Snowflake with S3.

```sql
CREATE STORAGE INTEGRATION SNOWPARK_INT
```

### 🔹 External Stage

* Created external stage pointing to S3:

```sql
CREATE STAGE SNOWPARK_DB.STAGING.SNOWPARK_STAGE
```

### ✅ Purpose

* Allows Snowflake to read files directly from S3

---

## 🧱 Step 4: Database & Schema Setup

Created database:

```sql
SNOWPARK_DB
```

### Schemas:

| Schema      | Purpose                        |
| ----------- | ------------------------------ |
| STAGING     | Raw files from S3              |
| RAW         | Structured raw data            |
| TRANSFORMED | Cleaned & processed data       |
| CURATED     | Business-level aggregated data |

---

## 📥 Step 5: Data Loading (STAGING Layer)

### File Formats Used:

* CSV → India
* Parquet → USA
* JSON → France

### Process:

1. Truncated staging tables
2. Loaded data using:

```sql
COPY INTO table FROM @stage
```

### Key Concept:

* Snowflake supports **multi-format ingestion**

---

## 🪵 Step 6: RAW Layer Processing

### Actions Performed:

* Converted semi-structured data (JSON/Parquet) → structured tables
* Used:

  * `VARIANT`
  * `FLATTEN` for JSON
* Standardized column names

### Output Tables:

* `INDIA_SALES_ORDER`
* `USA_SALES_ORDER`
* `FRANCE_SALES_ORDER`

---

## 🔄 Step 7: TRANSFORMED Layer (Snowpark)

### Key Transformations:

#### ✅ 1. Column Standardization

* Renamed columns:

  * GST → TAX
  * PHONE → CONTACT_NUMBER

#### ✅ 2. Added COUNTRY Column

* INDIA / USA / FRANCE

#### ✅ 3. Union of Datasets

* Combined all three country datasets

#### ✅ 4. Handling Missing Values

* Filled null values:

```python
fillna('NA')
```

#### ✅ 5. Feature Engineering

Split `MOBILE_MODEL` into:

* BRAND
* VERSION
* COLOR
* RAM
* MEMORY

#### ✅ 6. Column Reordering

* Structured dataset for analytics

#### ✅ 7. Timestamp Addition

* Added `INSERT_DTS`

### Output:

```
GLOBAL_SALES_ORDER
```

---

## 📊 Step 8: CURATED Layer (Business Logic)

### Created Aggregated Tables:

---

### 🔹 1. Delivered Orders

* Filtered records where:

```
SHIPPING_STATUS = 'Delivered'
```

---

### 🔹 2. Sales by Brand

* Grouped by:

  * MOBILE_BRAND
  * MOBILE_MODEL

* Metric:

  * Total Sales Amount

---

### 🔹 3. Sales by Country & Quarter

* Grouped by:

  * COUNTRY
  * YEAR
  * QUARTER

* Metrics:

  * Total Sales Volume
  * Total Sales Amount

---

## 📦 Final Outputs

| Table                        | Description                  |
| ---------------------------- | ---------------------------- |
| GLOBAL_SALES_ORDER           | Clean unified dataset        |
| GLOBAL_SALES_ORDER_DELIVERED | Delivered orders only        |
| GLOBAL_SALES_ORDER_BRAND     | Brand-level sales            |
| GLOBAL_SALES_ORDER_COUNTRY   | Country & quarterly insights |

---

## 🧠 Key Concepts Learned

### 🔹 Snowflake

* Storage Integration
* External Stages
* COPY INTO
* Semi-structured data handling

### 🔹 Snowpark

* DataFrame API
* Transformations inside Snowflake
* No data movement

### 🔹 AWS

* IAM Roles
* S3 integration
* Glue for ingestion

---

## 🚀 Key Achievements

* Built a complete **ETL pipeline**
* Integrated **AWS + Snowflake**
* Processed **multiple data formats**
* Implemented **Medallion Architecture**
* Used **Snowpark for transformations**

---

## 📌 Conclusion

This project demonstrates how modern data pipelines are built using:

* Cloud storage (S3)
* Data warehouse (Snowflake)
* Processing engine (Snowpark)

The final output provides **business-ready datasets** for analytics and reporting.

---

## 📷 Screenshots (Add Below)

* AWS IAM Role Setup
* S3 Bucket Data
* Snowflake Stage
* Query Outputs
* Snowpark Worksheets

(Add images in `/images` folder and reference here)

---

