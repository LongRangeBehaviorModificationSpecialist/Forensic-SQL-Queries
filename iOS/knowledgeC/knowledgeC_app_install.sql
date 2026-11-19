/*
[DLU]
    19-Nov-2026
[DATABASE PATH]
    /private/var/mobile/Library/CoreDuet/Knowledge/knowledgeC.db
*/

SELECT

    ROW_NUMBER() OVER ( ORDER BY ZOBJECT.ZCREATIONDATE ) AS "RowNumber",
    ZOBJECT.Z_PK AS "ZPk",

    strftime ( '%F_%H:%M:%f', ZOBJECT.ZCREATIONDATE + 978307200, 'unixepoch' ) AS "CreationDateUtc",
    strftime ( '%F_%H:%M:%f', ZOBJECT.ZSTARTDATE + 978307200, 'unixepoch' ) AS "StartDateUtc",
    strftime ( '%F_%H:%M:%f', ZOBJECT.ZENDDATE + 978307200, 'unixepoch' ) AS "EndDateUtc",

    ( ZOBJECT.ZENDDATE - ZOBJECT.ZSTARTDATE ) AS "UsageSeconds",
    ( ZOBJECT.ZSECONDSFROMGMT / 3600 ) AS "GmtOffsetSeconds",

    CASE ZOBJECT.ZSTARTDAYOFWEEK
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END "StartDayOfWeek",

    ZOBJECT.ZSTREAMNAME AS "StreamName",
    ZOBJECT.ZVALUESTRING AS "ValueString",

    /* Source for each line of data */
    'knowledgeC.db; Table: ZOBJECT(Z_PK:' || ZOBJECT.Z_PK || ')' AS "DataSource"


FROM ZOBJECT
    LEFT JOIN ZSTRUCTUREDMETADATA on ZOBJECT.ZSTRUCTUREDMETADATA = ZSTRUCTUREDMETADATA.Z_PK
    LEFT JOIN ZSOURCE on ZOBJECT.ZSOURCE = ZSOURCE.Z_PK


WHERE
    ZSTREAMNAME IS '/app/install'


ORDER BY
    ZOBJECT.ZSTARTDATE
