/*
[DLU]
    03-Nov-2026

For use with the CallHistory.storedata database
located at: /private/var/mobile/Library/CallHistoryDB/CallHistory.storedata
Use 'DESC' for decending order (most recent date at the top) OR can use 'ASC' for acending order
*/


SELECT

    ROW_NUMBER() OVER() AS 'RowNumber',
    ZCALLRECORD.Z_PK AS 'ZPk',

    ZCALLRECORD.ZADDRESS AS 'Partner(s)',
    ZCALLRECORD.ZLOCATION AS 'Location',

    datetime(ZCALLRECORD.ZDATE + 978307200, 'unixepoch') AS 'CallDateTimeUtc',
    datetime((ZCALLRECORD.ZDATE + 978307200) + ZCALLRECORD.ZDURATION, 'unixepoch') AS 'CallEndDateTimeUtc',
    TIME(ZCALLRECORD.ZDURATION, 'unixepoch') AS 'CallDuration',

    CASE ZCALLRECORD.ZANSWERED
        WHEN 0 THEN 'NotAnswered [0]'
        WHEN 1 THEN 'Answered [1]'
        ELSE 'UnknownValue: ' || ZCALLRECORD.ZANSWERED || ''
    END AS 'CallStatus',

    CASE ZCALLRECORD.ZORIGINATED
        WHEN 0 THEN 'Incoming [0]'
        WHEN 1 THEN 'Outgoing [1]'
        ELSE 'UnknownValue: ' || ZCALLRECORD.ZORIGINATED || ''
    END as 'CallDirection',

    CASE ZCALLRECORD.ZCALLTYPE
        WHEN 1 THEN 'Standard [1]'
        WHEN 8 THEN 'FullAVFaceTime [8]'
        WHEN 16 THEN 'FaceTimeAudioOnly [16]'
        ELSE 'UnknownValue :' || ZCALLRECORD.ZCALLTYPE || ''
    END AS 'CallType',

    ZCALLRECORD.ZSERVICE_PROVIDER AS 'ServiceProvider',

    /* Source for each line of data */
    'CallHistory.storedata; Table: ZCALLRECORD(Z_PK:' || ZCALLRECORD.Z_PK || ')' AS 'DataSource'


FROM ZCALLRECORD


ORDER BY
    ZCALLRECORD.ZDATE DESC
