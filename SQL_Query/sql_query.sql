
SELECT COUNT(*) AS total_count FROM dbo.[Year 2009-2010];

SELECT COUNT(*) AS total_count FROM dbo.[Year 2010-2011];


-- COMBINE BOTH YEARS DATA AND CONVERTING DATA TYPE SAFELY 


SELECT
    Invoice,
    StockCode,
    Description,
    Quantity,
    COALESCE(
        TRY_CONVERT(datetime2, InvoiceDate, 120),
        TRY_CONVERT(datetime2, InvoiceDate, 105)
    ) AS InvoiceDate,
    TRY_CONVERT(decimal(10,2), Price) AS Price,
    customer_id,
    Country,
    '2009-2010' AS SourceSheet
INTO dbo.RetailCombined
FROM dbo.[Year 2009-2010]

UNION ALL

SELECT
    Invoice,
    StockCode,
    Description,
    Quantity,
    COALESCE(
        TRY_CONVERT(datetime2, InvoiceDate, 120),
        TRY_CONVERT(datetime2, InvoiceDate, 105)
    ) AS InvoiceDate,
    TRY_CONVERT(decimal(10,2), Price) AS Price,
    customer_id,
    Country,
    '2010-2011' AS SourceSheet
FROM dbo.[Year 2010-2011];



-- CONFIRM THE CONVERSION WORKED CLEANLY 

SELECT COUNT(*) AS total_rows FROM RetailCombined


SELECT COUNT(*) AS failed_date FROM RetailCombined 
WHERE InvoiceDate IS NULL 

SELECT COUNT(*) AS failed_price FROM RetailCombined
WHERE price IS NULL;



-- CHECK 1: MISSING CUSTOMER_ID ROWS 


SELECT COUNT(*) AS missing_customer_id 
FROM RetailCombined
WHERE customer_id IS NULL; 


-- CHECK 2: NEGATIVE OR ZERO QUANTITY 


SELECT COUNT(*) AS negative_qty 
FROM RetailCombined
WHERE quantity<=0;



-- CHECK 3: MISSING DESCRIPTION ROWS 


SELECT COUNT(*) AS missing_description 
FROM RetailCombined 
WHERE description IS NULL 


-- CHECK 4: EXACT DUPLICATE ROWS

SELECT invoice,stockcode,description,quantity,invoicedate,price,customer_id,country, COUNT(*) AS duplicate_count

FROM RetailCombined

GROUP BY invoice,stockcode,description,quantity,invoicedate,price,customer_id,country

HAVING COUNT(*) > 1;



-- DEDUPLICATE AND PRODUCE THE FINAL CLEANED TABLE 



WITH deduplicate AS (

SELECT *, 
ROW_NUMBER() OVER(PARTITION BY invoice,stockcode,description,quantity,invoicedate,price,customer_id,country 
ORDER BY (SELECT NULL)) AS row_num
FROM RetailCombined
)

SELECT invoice,stockcode,description,quantity,invoicedate,price,customer_id,country
INTO retail_cleaned 
FROM deduplicate
WHERE row_num = 1



SELECT * FROM retail_cleaned

