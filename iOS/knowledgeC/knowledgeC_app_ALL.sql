/*
[DLU]
    20-Nov-2026
[DATABASE]
    /private/var/mobile/Library/CoreDuet/Knowledge/knowledgeC.db
[NOTES]

*/


SELECT

    ROW_NUMBER() OVER ( ORDER BY ZOBJECT.ZSTARTDATE ) AS RowNumber,

    ZOBJECT.ZVALUESTRING AS ZValueString,
    ZOBJECT.ZSTREAMNAME AS ZStreamName,
    ZSTRUCTUREDMETADATA.Z_DKAPPLICATIONMETADATAKEY__LAUNCHREASON AS LaunchReason,

    strftime ( '%F_%H:%M:%f', ZOBJECT.ZSTARTDATE + 978307200, 'unixepoch' ) AS StartDateUtc,
    strftime ( '%F_%H:%M:%f', ZOBJECT.ZENDDATE + 978307200, 'unixepoch' ) AS EndDateUtc,

    ( ZOBJECT.ZENDDATE - ZOBJECT.ZSTARTDATE ) AS UsageSeconds,

    strftime ( '%F_%H:%M:%f', ZOBJECT.ZCREATIONDATE + 978307200, 'unixepoch' ) AS CreationDateUtc,
    ( ZOBJECT.ZSECONDSFROMGMT / 3600 ) AS DeviceGmtOffset,

    ZOBJECT.ZUUID AS Uuid,

    /* Source for each line of data */
    'knowledgeC.db; Table: ZOBJECT(Z_PK:' || ZOBJECT.Z_PK || ')' AS DataSource


FROM ZOBJECT
    LEFT JOIN ZSTRUCTUREDMETADATA ON ZOBJECT.ZSTRUCTUREDMETADATA = ZSTRUCTUREDMETADATA.Z_PK
    LEFT JOIN ZSOURCE ON ZOBJECT.ZSOURCE = ZSOURCE.Z_PK


WHERE
    (ZSTREAMNAME LIKE '%') AND ZVALUESTRING LIKE '%whatsapp%'


ORDER BY
    ZOBJECT.ZSTARTDATE DESC


--ZSTREAMNAME LIKE '/app/activity' OR
--ZSTREAMNAME LIKE '/app/inFocus' OR
--ZSTREAMNAME LIKE '/app/usage' OR
--ZSTREAMNAME LIKE '/app/intents' OR
--ZSTREAMNAME LIKE '/app/locationActivity' OR
--ZSTREAMNAME LIKE '/app/relevantShortcuts' OR
--ZSTREAMNAME LIKE '/app/webUsage'
