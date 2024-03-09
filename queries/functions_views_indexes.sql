-- TP 2 Data Engineering Diploma (Functions, Views, and Indexes)

-- Create a view combining data from two tables
CREATE VIEW
    products_last_year AS
SELECT
    time_year, -- Year of the event
    product_name, -- Product name
    product_id -- Product ID
FROM
    sales AS s -- Sales table
    LEFT JOIN time AS t -- Dates table
    ON s.time_id = t.time_id -- Relationship between sales and dates
    LEFT JOIN products AS p -- Products table
    ON p.product_id = s.product_id -- Relationship between sales and products
WHERE
    time_year = 2018; -- Filter by specific year 
    
-- Verify that the view was created correctly
SELECT
    *
FROM
    products_last_year;

-- Create a temporary 
CREATE TEMPORARY VIEW IF NOT EXISTS all_regions AS
SELECT
    region_name -- Region name
FROM
    regions;

-- Verify that the temporary view was created correctly
SELECT
    *
FROM
    all_regions;

-- Transaction management 
BEGIN TRANSACTION; -- Insert a new record
INSERT INTO
    PRODUCTS (product_id, product_name)
VALUES
    (1001, 'Shampoo');

COMMIT;

-- Verify that the record was inserted correctly
SELECT
    *
FROM
    products
WHERE
    product_name = 'Shampoo';

-- Create an index to facilitate searching for values in the SALES table
-- Measure the query execution time before creating the index
EXPLAIN QUERY PLAN
SELECT
    COUNT(*),
    SUM(
        CASE
            WHEN transaction_amount >= 0 THEN transaction_amount
            ELSE 0
        END
    ) AS total_positive_amount,
    AVG(
        CASE
            WHEN transaction_amount >= 0 THEN transaction_amount
            ELSE 0
        END
    ) AS average_positive_amount,
    MIN(transaction_amount) AS minimum_amount,
    MAX(transaction_amount) AS maximum_amount
FROM
    sales; -- The execution time was 0.002 seconds. 
    
-- Create the index
CREATE INDEX idx_transaction_amount ON sales (transaction_amount);

-- Execute the query after creating the index
EXPLAIN QUERY PLAN
SELECT
    COUNT(*),
    SUM(
        CASE
            WHEN transaction_amount >= 0 THEN transaction_amount
            ELSE 0
        END
    ) AS total_positive_amount,
    AVG(
        CASE
            WHEN transaction_amount >= 0 THEN transaction_amount
            ELSE 0
        END
    ) AS average_positive_amount,
    MIN(transaction_amount) AS minimum_amount,
    MAX(transaction_amount) AS maximum_amount
FROM
    sales;

-- Now the query executes in 0.001 seconds.
-- It is important to note that the choice of where to place the index follows business rules
-- since this query will be constantly used, we decided to apply the index