/*
[DLU]
    20-Nov-2026
[DATABASE]
    /private/var/mobile/Library/CoreDuet/Knowledge/knowledgeC.db
[NOTES]

*/


SELECT

    ROW_NUMBER() OVER ( ORDER BY ZOBJECT.ZSTARTDATE ) AS RowNumber,

    ZOBJECT.Z_PK AS ZPk,

    CASE ZOBJECT.ZSTARTDAYOFWEEK
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
        ELSE 'Type: [' || ZOBJECT.ZSTARTDAYOFWEEK || ']'
    END AS StartDayOfWeek,

    strftime ( '%F_%H:%M:%f', ZOBJECT.ZSTARTDATE + 978307200, 'unixepoch' ) AS StartDateUtc,
    strftime ( '%F_%H:%M:%f', ZOBJECT.ZENDDATE + 978307200, 'unixepoch' ) AS EndDateUtc,
    strftime ( '%F_%H:%M:%f', ZOBJECT.ZCREATIONDATE + 978307200, 'unixepoch' ) AS CreationDateUtc,

    ( ZOBJECT.ZSECONDSFROMGMT / 3600 ) AS SecondsFromGmt,
    ( ZOBJECT.ZENDDATE - ZOBJECT.ZSTARTDATE ) AS UsageSeconds,
    ROUND ( ( ( ZOBJECT.ZENDDATE - ZOBJECT.ZSTARTDATE ) / 60.00 ), 4 ) AS UsageMinutes,
    ZOBJECT.ZSTREAMNAME AS StreamName,

    CASE ZOBJECT.ZVALUEINTEGER
        WHEN '0.0' THEN 'False'
        WHEN '1.0' THEN 'True'
        ELSE 'Type: [' || ZOBJECT.ZVALUEINTEGER ']'
    END AS ValueInteger,

    /* Source for each line of data */
    'knowledgeC.db; Table: ZOBJECT(Z_PK:' || ZOBJECT.Z_PK || ')' AS DataSource


FROM ZOBJECT
    LEFT JOIN ZSTRUCTUREDMETADATA on ZOBJECT.ZSTRUCTUREDMETADATA = ZSTRUCTUREDMETADATA.Z_PK
    LEFT JOIN ZSOURCE on ZOBJECT.ZSOURCE = ZSOURCE.Z_PK


WHERE
    ZSTREAMNAME LIKE '/device%'
    --ZSTREAMNAME LIKE '/device/batteryPercentage'
    --or ZSTREAMNAME LIKE '/device/batterySaver'
    --or ZSTREAMNAME LIKE '/device/isLocked'
    --or ZSTREAMNAME LIKE '/device/isPluggedIn'


ORDER BY
    ZOBJECT.ZSTARTDATE DESC
