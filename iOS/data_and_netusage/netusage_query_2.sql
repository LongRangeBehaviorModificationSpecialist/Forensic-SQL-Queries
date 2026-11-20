/*
[DLU]
    20-Nov-2026
[DATABASE]

[NOTES]

*/


SELECT

    ROW_NUMBER() OVER ( ORDER BY ZPROCESS.ZTIMESTAMP ) AS RowNumber,

    ZPROCESS.Z_PK AS ZPk,

    strftime (
        '%F_%H:%M:%f',
        ZPROCESS.ZTIMESTAMP + 978307200,
        'unixepoch'
    ) AS ProcessTimeStampUtc,

    strftime (
        '%F_%H:%M:%f',
        ZPROCESS.ZFIRSTTIMESTAMP + 978307200,
        'unixepoch'
    ) AS ProcessFirstTimeStampUtc,

    strftime (
        '%F_%H:%M:%f',
        ZLIVEUSAGE.ZTIMESTAMP + 978307200,
        'unixepoch'
    ) AS LiveUsageTimeStampUtc,

    ZPROCESS.ZBUNDLENAME AS BundleName,
    ZPROCESS.ZPROCNAME AS ProcName,

    printf ( '%,d', ZLIVEUSAGE.ZWIFIIN ) AS WifiBytesIn,
    printf ( '%,d', ZLIVEUSAGE.ZWIFIOUT ) AS WifiBytesOut,
    printf ( '%,d', ZLIVEUSAGE.ZWWANIN ) AS WwanBytesIn,
    printf ( '%,d', ZLIVEUSAGE.ZWWANOUT ) AS WwanBytesOut,

    ZLIVEUSAGE.ZWIREDIN AS WiredBytesIn,
    ZLIVEUSAGE.ZWIREDOUT AS WiredBytesOut,
    ZLIVEUSAGE.ZXIN AS XIn,
    ZLIVEUSAGE.ZXOUT AS XOut,

    /* Source for each line of data */
    'netusage.sqlite; Table:ZLIVEUSAGE(Z_PK: ' || ZLIVEUSAGE.Z_PK || ')' AS DataSource


FROM ZLIVEUSAGE
    LEFT JOIN ZPROCESS ON ZPROCESS.Z_PK = ZLIVEUSAGE.ZHASPROCESS


WHERE
    ZPROCESS.ZBUNDLENAME LIKE '%compress%'


ORDER BY
    ZLIVEUSAGE.Z_PK ASC
