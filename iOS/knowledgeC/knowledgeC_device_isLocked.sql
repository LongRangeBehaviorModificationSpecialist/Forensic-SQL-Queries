/*
[DLU]
    20-Nov-2026
[DATABASE]
    /private/var/mobile/Library/CoreDuet/Knowledge/knowledgeC.db
[NOTES]

*/


SELECT

    ROW_NUMBER() OVER ( ORDER BY ZOBJECT.ZCREATIONDATE ) AS RowNumber,

    ZOBJECT.Z_PK AS ZPk,

    strftime ( '%F_%H:%M:%f', ZOBJECT.ZCREATIONDATE + 978307200, 'unixepoch' ) AS CreationDateUtc,
    strftime ( '%F_%H:%M:%f', ZOBJECT.ZSTARTDATE + 978307200, 'unixepoch' ) AS StartDateUtc,
    strftime ( '%F_%H:%M:%f', ZOBJECT.ZENDDATE + 978307200, 'unixepoch' ) AS EndDateUtc,

    ( ZOBJECT.ZENDDATE - ZOBJECT.ZSTARTDATE ) AS UsageSeconds,
    ( ZOBJECT.ZSECONDSFROMGMT / 3600 ) AS GmtOffsetHours,

    CASE ZOBJECT.ZSTARTDAYOFWEEK
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
        ELSE 'Type: [' || ZOBJECT.ZSTARTDAYOFWEEK || ']'
    END StartDayOfWeek,

    ZOBJECT.ZSTREAMNAME AS StreamName,
    ZOBJECT.ZVALUESTRING AS ValueString,

    CASE ZOBJECT.ZVALUEINTEGER
        WHEN '0.0' THEN 'Unlocked'
        WHEN '1.0' THEN 'Locked'
        ELSE 'Type: [' || ZOBJECT.ZVALUEINTEGER || ']'
    END AS ValueInteger,

    /* Source for each line of data */
    'knowledgeC.db; Table: ZOBJECT(Z_PK:' || ZOBJECT.Z_PK || ')' AS DataSource


FROM ZOBJECT


WHERE
    ZSTREAMNAME LIKE '/device/isLocked'


ORDER BY
    ZOBJECT.ZSTARTDATE DESC
