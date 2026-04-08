# ❄️ Snowflake Snowpark ETL Pipeline

##  Overview

End-to-end data pipeline built using **Snowflake, Snowpark, AWS S3, and AWS Glue**.
Processes raw data into **analytics-ready datasets** using a multi-layer architecture.

---

## 🏗️ Architecture

```bash
GitHub → AWS Glue → AWS S3 → Snowflake
                                ↓
                    STAGING → RAW → TRANSFORMED → CURATED
```

---

##  Tech Stack

* Snowflake
* Snowpark (Python)
* AWS S3
* AWS Glue
* SQL

---

##  Key Features

* Multi-format ingestion (CSV, JSON, Parquet)
* Snowpark-based transformations
* End-to-end ETL pipeline
* Aggregated business insights

---

## 📊 Outputs

* Global Sales Orders
* Delivered Orders
* Sales by Brand
* Sales by Country & Quarter

---

## 📁 Project Structure

```bash
snowflake-snowpark-etl-pipeline/
├── scripts/
│   ├── sql/
│   └── snowpark/
├── notes/
├── images/
└── README.md
```

---

## 🧠 Notes

Detailed explanation available here:

```bash
notes/project_notes.md
```
