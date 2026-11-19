/*
[DLU]
    19-Nov-2026

For use with the CallHistory.storedata database
located at: /private/var/mobile/Library/CallHistoryDB/CallHistory.storedata
Use 'DESC' for decending order (most recent date at the top) OR can use 'ASC' for acending order
*/


SELECT

    ROW_NUMBER() OVER ( ORDER BY ZCALLRECORD.ZDATE ) AS "RowNumber",

    ZCALLRECORD.Z_PK AS "ZPk",

    ZCALLRECORD.ZADDRESS AS "Partners",
    ZCALLRECORD.ZLOCATION AS "Location",

    strftime (
        '%F_%H:%M:%f',
        ZCALLRECORD.ZDATE + 978307200,
        'unixepoch'
    ) AS "CallDateTimeUtc",

    -- End time calculated based on the ZDATE plus the ZDURATION
    strftime (
        '%F_%H:%M:%f',
        ( ( ZCALLRECORD.ZDATE + 978307200 ) + ZCALLRECORD.ZDURATION ),
        'unixepoch'
    ) AS "CallEndDateTimeUtc",

    TIME ( ZCALLRECORD.ZDURATION, 'unixepoch' ) AS "CallDuration",

    CASE ZCALLRECORD.ZANSWERED
        WHEN 0 THEN 'NotAnswered'
        WHEN 1 THEN 'Answered'
        ELSE 'UnknownValue: ' || ZCALLRECORD.ZANSWERED || ''
    END AS "CallStatus",

    CASE ZCALLRECORD.ZORIGINATED
        WHEN 0 THEN 'Incoming'
        WHEN 1 THEN 'Outgoing'
        ELSE 'UnknownValue: ' || ZCALLRECORD.ZORIGINATED || ''
    END as "CallDirection",

    CASE ZCALLRECORD.ZCALLTYPE
        WHEN 1 THEN 'Standard'
        WHEN 8 THEN 'FullAVFaceTime'
        WHEN 16 THEN 'FaceTimeAudioOnly'
        ELSE 'UnknownValue :' || ZCALLRECORD.ZCALLTYPE || ''
    END AS "CallType",

    ZCALLRECORD.ZSERVICE_PROVIDER AS "ServiceProvider",

    /* Source for each line of data */
    'CallHistory.storedata; Table: ZCALLRECORD(Z_PK:' || ZCALLRECORD.Z_PK || ')' AS "DataSource"


FROM ZCALLRECORD


ORDER BY
    ZCALLRECORD.ZDATE DESC
