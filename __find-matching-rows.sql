/*
[DLU]
    13-Nov-2026
*/


SELECT
    [columnName] AS 'Matching Rows'
FROM [tableA]
INTERSECT
SELECT
    [columnName] AS 'Matching Rows'
FROM [tableB];


/*
OR
*/


SELECT DISTINCT tableA.columnName AS 'Matching Rows'
FROM [tableA]
INNER JOIN [tableB] ON tableA.columnName = tableB.columnName;