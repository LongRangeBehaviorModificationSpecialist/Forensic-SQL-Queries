/*
[DLU]
    20-Nov-2026
[NOTES]
    Finds matching data in different tables of the same database.
*/


SELECT

    [columnName] AS MatchingRows

FROM [tableA]

INTERSECT

SELECT

    [columnName] AS MatchingRows

FROM [tableB];


/*
OR
*/


SELECT

    DISTINCT

        tableA.columnName AS MatchingRows

FROM [tableA]

INNER JOIN [tableB] ON tableA.columnName = tableB.columnName;