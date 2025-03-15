Details
1. README.md

    Overview of my experience and purpose of the repository.
    Provided instructions to run scripts, set up tools, and walkthroughs included.
    Technologies covered:
        Oracle, SQL Server, MySQL: Schema design, performance tuning, ETL, and queries.
        dbt Core: Transformation models and macros.
        Python: Data transformations and utility scripts.
        AWS Lambda: Event-driven ETL pipelines.
        Snowflake: Integration and optimization.

2. data-engineering/database-design/oracle/

    Schema Design: Examples of HR and retail schema design, demonstrating normalization, constraints, and relationships.
    Performance Tuning: Scripts for indexing, partitioning, and using Oracle tools like AWR.

3. sql_server/

    ETL Scripts: Full and incremental data load scripts with transactional data.
    Stored Procedures: Procedures for sales summaries, churn analysis, and archival.

4. mysql/

    Data Cleaning: Scripts for deduplication and normalization.
    Complex Queries: Analytical SQL for business KPIs like revenue and product performance.

5. data-engineering/extract-transform-load/dbt-core/

    Models: Include transformations for staging and marts layers, focusing on business use cases (e.g., customer lifetime value, sales summaries).
    Macros: Reusable utilities for generating surrogate keys or validating schemas.

6. cloud-engineering/snowflake/

    Integration: Snowpipe and external stage setup for automated data loading.
    Optimization: Examples of query tuning and materialized views.

7. python/

    Data Transformations: Scripts for cleaning and transforming data, including customer segmentation.
    Utilities: Helper scripts for generating test data or handling null values.

8. etl/aws/lambda/

    ETL Pipeline: A Python-based Lambda function for orchestrating ETL, with documentation on deployment.
    Snowflake Integration: Automate loading S3 files to Snowflake via Lambda.

9. docs/

    Project Overview: High-level overview of the repository.
    Best Practices: Tips and tricks for efficient data engineering.
    Tools Used: Details about the tools and how to set them up.

10. .discovery/

    Blockchain: TBD
    Docker: Examples of containerization with <technology_used>.
    Scala: TBD
    Training: Examples of independent learning and exploratory exercises and labs.
    VBA: Maintained legacy Access database for finance and accounting teams. Examples inside.