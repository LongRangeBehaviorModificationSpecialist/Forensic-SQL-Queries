/*
[DLU]
    20-Nov-2026
[URL]
    https://github.com/ScottKjr3347/iOS_KnowledgeC.db_Queries/blob/main/NotificationUsage_SQLiteQuery
[DATABASE]
    /private/var/mobile/Library/CoreDuet/Knowledge/knowledgeC.db
[NOTES]

*/

SELECT

    ROW_NUMBER() OVER ( ORDER BY ZOBJECT.ZSTARTDATE ) AS RowNumber,

    ZOBJECT.Z_PK AS ZPk,

    strftime ( '%F_%H:%M:%f', ZOBJECT.ZSTARTDATE + 978307200, 'unixepoch' ) AS StartDateUtc,
    strftime ( '%F_%H:%M:%f', ZOBJECT.ZENDDATE + 978307200, 'unixepoch' ) AS EndDateUtc,
    strftime ( '%F_%H:%M:%f', ZOBJECT.ZCREATIONDATE + 978307200, 'unixepoch' ) AS CreationDateUtc,

    ZOBJECT.ZSTREAMNAME AS StreamName,
    ZOBJECT.ZVALUESTRING AS ValueString,
    ZSTRUCTUREDMETADATA.Z_DKNOTIFICATIONUSAGEMETADATAKEY__BUNDLEID AS BundleId,
    ZSTRUCTUREDMETADATA.Z_DKNOTIFICATIONUSAGEMETADATAKEY__IDENTIFIER AS Identifier,

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

    ZOBJECT.ZSTARTSECONDOFDAY AS StartSecondOfDay,

    CASE ZOBJECT.ZENDDAYOFWEEK
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END AS EndDayOfWeek,

    ZOBJECT.ZENDSECONDOFDAY AS EndSecondOfDay,
    ( ZOBJECT.ZSECONDSFROMGMT / 3600 ) AS GmtOffsetHours,

    CASE ZOBJECT.ZHASSTRUCTUREDMETADATA
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
    END AS HasStructuredMetadata,

    ZOBJECT.ZSTRUCTUREDMETADATA AS StructuredMetadata,
    ZOBJECT.ZVALUEINTEGER AS ValueInteger,
    ZOBJECT.ZVALUETYPECODE AS ValueTypeCode,
    ZOBJECT.ZVALUEDOUBLE AS ValueDouble,
    ZOBJECT.ZUUID AS Uuid,
    ZSTRUCTUREDMETADATA.ZMETADATAHASH AS MetadataHash,

    /* Source for each line of data */
    'knowledgeC.db; Table: ZOBJECT(Z_PK:' || ZOBJECT.Z_PK || ')' AS DataSource


FROM ZOBJECT
    LEFT JOIN ZSTRUCTUREDMETADATA ON ZSTRUCTUREDMETADATA.Z_PK = ZOBJECT.ZSTRUCTUREDMETADATA


WHERE
    ZSTREAMNAME IS '/notification/usage'


ORDER BY
    ZOBJECT.ZSTARTDATE ASC
