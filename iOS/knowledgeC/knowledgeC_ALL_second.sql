/*
Copied from https://www.mac4n6.com/blog/2018/8/5/knowledge-is-power-using-the-knowledgecdb-database-on-macos-and-ios-to-determine-precise-user-and-application-usage

[DLU]
    03-Nov-2026
[DATABASE PATH]
    /private/var/mobile/Library/CoreDuet/Knowledge/knowledgeC.db
*/


SELECT

    ROW_NUMBER() OVER() AS 'RowNumber.',
    ZOBJECT.Z_PK AS 'ZPk',
    ZOBJECT.ZSOURCE AS 'Source',

    datetime(ZOBJECT.ZCREATIONDATE + 978307200, 'unixepoch') AS 'CreationDateUtc',

    CASE ZOBJECT.ZSTARTDAYOFWEEK
        WHEN 1 THEN '1 [Sunday]'
        WHEN 2 THEN '2 [Monday]'
        WHEN 3 THEN '3 [Tuesday]'
        WHEN 4 THEN '4 [Wednesday]'
        WHEN 5 THEN '5 [Thursday]'
        WHEN 6 THEN '6 [Friday]'
        WHEN 7 THEN '7 [Saturday]'
    END 'StartDayOfWeek',

    datetime(ZOBJECT.ZSTARTDATE + 978307200, 'unixepoch') AS 'StartDateUtc',
    datetime(ZOBJECT.ZENDDATE + 978307200, 'unixepoch') AS 'EndDateUtc',

    (ZOBJECT.ZENDDATE - ZOBJECT.ZSTARTDATE) AS 'Usage(Sec)',
    ZSOURCE.ZDEVICEID AS 'DeviceId',
    ZOBJECT.ZSTREAMNAME AS 'StreamName',
    ZOBJECT.ZVALUESTRING AS 'ValueString',
    ZSTRUCTUREDMETADATA.Z_DKAPPLICATIONACTIVITYMETADATAKEY__ACTIVITYTYPE AS 'ActivityType',
    ZSTRUCTUREDMETADATA.Z_DKAPPLICATIONACTIVITYMETADATAKEY__TITLE AS 'Title',
    ZSTRUCTUREDMETADATA.Z_DKAPPLICATIONACTIVITYMETADATAKEY__USERACTIVITYREQUIREDSTRING AS 'UserActivityRequiredString',

    datetime(ZSTRUCTUREDMETADATA.Z_DKAPPLICATIONACTIVITYMETADATAKEY__EXPIRATIONDATE + 978307200, 'unixepoch') AS 'ExpirationDateUtc',

    ZSTRUCTUREDMETADATA.Z_DKINTENTMETADATAKEY__INTENTCLASS AS 'IntentClass',
    ZSTRUCTUREDMETADATA.Z_DKINTENTMETADATAKEY__INTENTVERB AS 'IntentVerb',
    ZSTRUCTUREDMETADATA.Z_DKINTENTMETADATAKEY__SERIALIZEDINTERACTION AS 'SerializedInteraction',
    ZSOURCE.ZBUNDLEID AS 'BundleId',

    /* Source for each line of data */
    'knowledgeC.db; Table: ZOBJECT(Z_PK:' || ZOBJECT.Z_PK || ')' AS 'DataSource'


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