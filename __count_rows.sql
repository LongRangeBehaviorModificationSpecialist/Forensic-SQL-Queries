/*
[DLU]
    19-Nov-2026
*/


-- Count number of rows meeting a condition
SELECT
    [columnName],
    COUNT( * ) AS "occurrences"
FROM [tableName]
GROUP BY [columnName]
HAVING COUNT( * ) > 1;


-- Return each duplicate value along with how many times it appears
-- If you only want the values themselves, drop the count
-- Will find all values that occur more than two times
SELECT [columnName]
FROM [tableName]
GROUP BY [columnName]
HAVING COUNT( * ) > 2;


-- If you want full row, not just the values (will find two or more)
SELECT *
FROM (
    SELECT
        *,
        COUNT( * ) OVER ( PARTITION BY [columnName] ) AS "num"
    FROM [tableName]
) t
WHERE "num" >=2;
