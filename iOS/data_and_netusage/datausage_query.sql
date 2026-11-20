/*
[DLU]
    20-Nov-2026
[DATABASE FILE]
    /private/var/wireless/Library/Databases/DataUsage.sqlite
[NOTES]

*/

SELECT

    ROW_NUMBER() OVER ( ORDER BY ZLIVEUSAGE.ZTIMESTAMP ) AS RowNumber,

    strftime (
        '%F_%H:%M:%f',
        ZLIVEUSAGE.ZTIMESTAMP + 978307200,
        'unixepoch'
    ) AS LiveusageTimestampUtc,

    strftime (
        '%F_%H:%M:%f',
        ZPROCESS.ZFIRSTTIMESTAMP + 978307200,
        'unixepoch'
    ) AS FirstTimestampUtc,

    strftime (
        '%F_%H:%M:%f',
        ZPROCESS.ZTIMESTAMP + 978307200,
        'unixepoch'
    ) AS ProcessTimestampUtc,

    ZPROCESS.ZPROCNAME AS ProcessName,
    ZPROCESS.ZBUNDLENAME AS BundleName,

    /*
    For iOS 18, comment out the ZLIVEUSAGE.ZWIFIIN & ZWIFIOUT columns -- they do not exist
    */
    printf ( '%,d', ZLIVEUSAGE.ZWIFIIN ) AS WifiBytesIn,
    printf ( '%,d', ZLIVEUSAGE.ZWIFIOUT ) AS WifiBytesOut,
    printf ( '%,d', ZLIVEUSAGE.ZWWANIN ) AS WwanBytesIn,
    printf ( '%,d', ZLIVEUSAGE.ZWWANOUT ) AS WwanBytesOut,

    /* Source for each line of data */
    'DataUsage.sqlite; Table:ZLIVEUSAGE(Z_PK:' || ZLIVEUSAGE.Z_PK || '), ' || 'Table: ZPROCESS(Z_PK:' || ZPROCESS.Z_PK || ')' AS DataSource


FROM ZLIVEUSAGE
    LEFT JOIN ZPROCESS ON ZLIVEUSAGE.ZHASPROCESS = ZPROCESS.Z_PK


WHERE
    ZPROCESS.ZPROCNAME LIKE '%compress%' OR
    ZPROCESS.ZBUNDLENAME LIKE '%compress%'


ORDER BY
    ZLIVEUSAGE.ZTIMESTAMP ASC
