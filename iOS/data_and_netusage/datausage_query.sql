/*
[DLU]
    09-Mar-2026
[DATABASE FILE]
    /private/var/wireless/Library/Databases/DataUsage.sqlite
*/

SELECT

    ROW_NUMBER() OVER() AS 'RowNumber',

    CASE
        WHEN ZLIVEUSAGE.ZTIMESTAMP IS NULL THEN NULL
        ELSE datetime(ZLIVEUSAGE.ZTIMESTAMP + 978307200, 'unixepoch')
    END AS 'LiveusageTimestampUtc',

    datetime(ZPROCESS.ZFIRSTTIMESTAMP + 978307200, 'unixepoch') AS 'FirstTimestampUtc',
    datetime(ZPROCESS.ZTIMESTAMP + 978307200, 'unixepoch') AS 'ProcessTimestampUtc',

    ZPROCESS.ZPROCNAME AS 'ProcessName',
    ZPROCESS.ZBUNDLENAME AS 'BundleName',
    /*
    For iOS 18, comment out the ZLIVEUSAGE.ZWIFIIN & ZWIFIOUT columns -- they do not exist
    */
    printf("%,d", ZLIVEUSAGE.ZWIFIIN) AS 'WifiBytesIn',
    printf("%,d", ZLIVEUSAGE.ZWIFIOUT) AS 'WifiBytesOut',
    printf("%,d", ZLIVEUSAGE.ZWWANIN) AS 'WwanBytesIn',
    printf("%,d", ZLIVEUSAGE.ZWWANOUT) AS 'WwanBytesOut',

    /* Source for each line of data */
    'DataUsage.sqlite; Table:ZLIVEUSAGE(Z_PK:' || ZLIVEUSAGE.Z_PK || '), ' || 'Table: ZPROCESS(Z_PK:' || ZPROCESS.Z_PK || ')' AS 'DataSource'


FROM ZLIVEUSAGE
    LEFT JOIN ZPROCESS ON ZLIVEUSAGE.ZHASPROCESS = ZPROCESS.Z_PK


WHERE
    ZPROCESS.ZPROCNAME LIKE '%compress%' OR
    ZPROCESS.ZBUNDLENAME LIKE '%compress%'


ORDER BY
    ZLIVEUSAGE.ZTIMESTAMP ASC
