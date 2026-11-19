/*
[DLU]
    19-Nov-2026
*/


SELECT
    *,
    -- Compute time difference between the StartTime value and the EndTime value
    CASE
        WHEN 'StartTime' IS NULL OR 'EndTime' IS NULL THEN NULL
        WHEN 'EndTime' < 'StartTime' THEN 'TimeValueError [`EndTime` is before `StartTime`]'
        ELSE
            --Build human-readable duration only if timestamps are valid
            CASE
                WHEN ( strftime ( '%s', 'EndTime' ) - strftime ( '%s', 'StartTime' ) ) / 31536000 > 0
                THEN ( ( strftime( '%s', 'EndTime' ) - strftime ( '%s', 'StartTime' ) ) / 31536000 ) || ' Years '
                ELSE ''
            END
            ||
            CASE
                WHEN ( ( strftime ( '%s', 'EndTime' ) - strftime ( '%s', 'StartTime' ) ) % 31536000 ) / 86400.0 > 0
                THEN ( ( ( strftime ( '%s', 'EndTime' ) - strftime ( '%s', 'StartTime' ) ) % 31536000 ) / 86400.0 ) || ' Days '
                ELSE ''
            END
            ||
            CASE
                WHEN ( ( strftime ( '%s', 'EndTime' ) - strftime ( '%s', 'StartTime' ) ) % 86400 ) / 3600.0 > 0
                THEN ( ( ( strftime ( '%s', 'EndTime' ) - strftime ( '%s', 'StartTime' ) ) % 86400 ) / 3600.0 ) || ' Hours '
                ELSE ''
            END
            ||
            CASE
                WHEN ( ( strftime ( '%s', 'EndTime' ) - strftime ( '%s', 'StartTime' ) ) % 3600 ) / 60.0 > 0
                THEN ( ( ( strftime ( '%s', 'EndTime' ) - strftime ( '%s', 'StartTime' ) ) % 3600 ) / 60.0 ) || ' Min '
                ELSE ''
            END
            ||
            CASE
                WHEN ( ( strftime ( '%s', 'EndTime' ) - strftime ( '%s', 'StartTime' ) ) % 60.0 ) > 0
                THEN ( ( strftime ( '%s', 'EndTime' ) - strftime ( '%s', 'StartTime' ) ) % 60.0 ) || ' Sec'
                ELSE ''
            END
    END AS TimeSpan


FROM (
    SELECT
        -- Change 'ROWID' to the name of the column containing the primary key
        LAG ( ROWID, 1 ) OVER ( ORDER BY ROWID ) AS "PreviousRowID",
        ROWID AS "RowID",
        ( ROWID - ( LAG ( ROWID, 1 ) OVER ( ORDER BY ROWID ) ) - 1 ) AS "NumberOfMissingRecords",

        -- Change 'ZDATEADDED' to the name of the column containing the timestamp value
        LAG ( datetime ( ZADDEDDATE + 978307200, 'unixepoch' ) ) OVER ( ORDER BY ROWID ) AS "StartTime",
        datetime ( ZADDEDDATE + 978307200, 'unixepoch' ) AS "EndTime"

    FROM ZASSET

) AS "List"


WHERE ROWID - 'PreviousRowID' > 1;
