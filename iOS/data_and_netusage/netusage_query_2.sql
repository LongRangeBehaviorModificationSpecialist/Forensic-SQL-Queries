SELECT

    ROW_NUMBER() OVER() AS 'RowNumber',
    ZPROCESS.Z_PK AS 'ZPk',

    datetime(ZPROCESS.ZTIMESTAMP + 978307200, 'UNIXEPOCH') AS 'ProcessTimestampUtc',
    datetime(ZPROCESS.ZFIRSTTIMESTAMP + 978307200, 'UNIXEPOCH') AS 'ProcessFirstTimestampUtc',
    datetime(ZLIVEUSAGE.ZTIMESTAMP + 978307200, 'UNIXEPOCH') AS 'LiveUsageTimestampUtc',

    ZPROCESS.ZBUNDLENAME AS 'BundleName',
    ZPROCESS.ZPROCNAME AS 'ProcName',
    printf("%,d", ZLIVEUSAGE.ZWIFIIN) AS 'WifiBytesIn',
    printf("%,d", ZLIVEUSAGE.ZWIFIOUT) AS 'WifiBytesOut',
    printf("%,d", ZLIVEUSAGE.ZWWANIN) AS 'WwanBytesIn',
    printf("%,d", ZLIVEUSAGE.ZWWANOUT) AS 'WwanBytesOut',
    ZLIVEUSAGE.ZWIREDIN AS 'WiredBytesIn',
    ZLIVEUSAGE.ZWIREDOUT AS 'WiredBytesOut',
    ZLIVEUSAGE.ZXIN AS 'XIn',
    ZLIVEUSAGE.ZXOUT AS 'XOut',

    /* Source for each line of data */
    'netusage.sqlite; Table:ZLIVEUSAGE(Z_PK: ' || ZLIVEUSAGE.Z_PK || ')' AS 'DataSource'


FROM ZLIVEUSAGE
    LEFT JOIN ZPROCESS ON ZPROCESS.Z_PK = ZLIVEUSAGE.ZHASPROCESS


WHERE
    ZPROCESS.ZBUNDLENAME LIKE '%compress%'


ORDER BY
    ZLIVEUSAGE.Z_PK ASC