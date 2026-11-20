/*
[DLU]
    20-Nov-2026
[URL]
    Original query copied from https://www.mac4n6.com/blog/2018/8/5/knowledge-is-power-using-the-knowledgecdb-database-on-macos-and-ios-to-determine-precise-user-and-application-usage
[DATABASE]
    /private/var/mobile/Library/CoreDuet/Knowledge/knowledgeC.db
[NOTES]

*/


SELECT

    ROW_NUMBER() OVER ( ORDER BY ZOBJECT.ZCREATIONDATE ) AS RowNumber,

    ZOBJECT.Z_PK AS ZPk,
    ZOBJECT.ZSOURCE AS Source,

    strftime ( '%F_%H:%M:%f', ZOBJECT.ZCREATIONDATE + 978307200, 'unixepoch' ) AS CreationDateUtc,

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

    strftime ( '%F_%H:%M:%f', ZOBJECT.ZSTARTDATE + 978307200, 'unixepoch' ) AS StartDateUtc,
    strftime ( '%F_%H:%M:%f', ZOBJECT.ZENDDATE + 978307200, 'unixepoch' ) AS EndDateUtc,

    (ZOBJECT.ZENDDATE - ZOBJECT.ZSTARTDATE) AS UsageSeconds,
    ZSOURCE.ZDEVICEID AS DeviceId,
    ZOBJECT.ZSTREAMNAME AS StreamName,
    ZOBJECT.ZVALUESTRING AS ValueString,
    ZSTRUCTUREDMETADATA.Z_DKAPPLICATIONACTIVITYMETADATAKEY__ACTIVITYTYPE AS ActivityType,
    ZSTRUCTUREDMETADATA.Z_DKAPPLICATIONACTIVITYMETADATAKEY__TITLE AS Title,
    ZSTRUCTUREDMETADATA.Z_DKAPPLICATIONACTIVITYMETADATAKEY__USERACTIVITYREQUIREDSTRING AS UserActivityRequiredString,

    strftime ( '%F_%H:%M:%f', ZSTRUCTUREDMETADATA.Z_DKAPPLICATIONACTIVITYMETADATAKEY__EXPIRATIONDATE + 978307200, 'unixepoch' ) AS ExpirationDateUtc,

    ZSTRUCTUREDMETADATA.Z_DKINTENTMETADATAKEY__INTENTCLASS AS IntentClass,
    ZSTRUCTUREDMETADATA.Z_DKINTENTMETADATAKEY__INTENTVERB AS IntentVerb,
    ZSTRUCTUREDMETADATA.Z_DKINTENTMETADATAKEY__SERIALIZEDINTERACTION AS SerializedInteraction,
    ZSOURCE.ZBUNDLEID AS BundleId,

    /* Source for each line of data */
    'knowledgeC.db; Table: ZOBJECT(Z_PK:' || ZOBJECT.Z_PK || ')' AS DataSource


FROM ZOBJECT
    LEFT JOIN ZSTRUCTUREDMETADATA ON ZOBJECT.ZSTRUCTUREDMETADATA = ZSTRUCTUREDMETADATA.Z_PK
    LEFT JOIN ZSOURCE ON ZOBJECT.ZSOURCE = ZSOURCE.Z_PK


WHERE
    ZSTREAMNAME IS '/app/activity'
    OR
    ZSTREAMNAME IS '/app/inFocus'
    OR
    ZSTREAMNAME IS '/app/intents'
    -- AND
    -- ZBUNDLEID IS 'com.toyopagroup.picaboo'


ORDER BY
    ZOBJECT.ZSTARTDATE ASC
