/*
[DLU]
    19-Nov-2026
iOS11 - WhatsApp messages
    \Application Groups\net.whatsapp.WhatsApp.shared\ChatStorage.sqlite
*/

SELECT

    ROW_NUMBER() OVER ( ORDER BY ZWAMESSAGE.ZMESSAGEDATE ) AS "RowNumber",

    ZWAMESSAGE.z_pk AS "ZPk",

    strftime (
        '%F_%H:%M:%f',
        ZWAMESSAGE.ZMESSAGEDATE + 978307200,
        'unixepoch'
    ) AS "MessageDateUtc",

    ZWACHATSESSION.ZPARTNERNAME AS "PartnerName",

    CASE ZWAMESSAGE.ZISFROMME
        WHEN 0 THEN 'Incoming'
        WHEN 1 THEN 'Outgoing'
        ELSE 'Unknown Value: ' || ZWAMESSAGE.ZISFROMME || ''
    END AS "IsFromMe",

    ZWAMESSAGE.ZFROMJID AS "FromJid",
    ZWAMESSAGE.ZTOJID AS "ToJid",

    strftime (
        '%F_%H:%M:%f',
        ZWAMESSAGE.ZSENTDATE + 978307200,
        'unixepoch'
    ) AS "SentDateUtc",

    CASE ZWAMESSAGE.ZMESSAGETYPE
        WHEN 0 THEN 'Text'
        WHEN 1 THEN 'Image'
        WHEN 2 THEN 'Video'
        WHEN 3 THEN 'VoiceMessage'
        WHEN 4 THEN 'Gif'
        WHEN 5 THEN 'Location'
        WHEN 6 THEN 'GroupEvent'
        WHEN 7 THEN 'Hyperlink'
        WHEN 8 THEN 'Document'
        WHEN 14 THEN 'DeletedMessage'
        WHEN 15 THEN 'Sticker'
        ELSE 'Unknown Value: ' || ZWAMESSAGE.ZMESSAGETYPE || ''
    END AS "MessageType",

    CASE ZWACHATSESSION.ZHIDDEN
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Unknown Value: ' || ZWACHATSESSION.ZHIDDEN || ''
    END AS "Hidden",

    ZWAMESSAGE.ZMEDIASECTIONID AS "MediaSectionId",
    ZWAMEDIAITEM.ZMEDIALOCALPATH AS "MediaLocalPath",
    ZWAMEDIAITEM.ZVCARDSTRING AS "VCardString",

    time ( ZWAMEDIAITEM.ZMOVIEDURATION, 'unixepoch' ) AS "MovieDuration",

    ZWAMESSAGE.ZSTARRED AS "Starred",
    ZWAMEDIAITEM.ZMEDIAURL AS "MediaUrl",

    strftime (
        '%F_%H:%M:%f',
        ZWAMEDIAITEM.ZMEDIAURLDATE + 978307200,
        'unixepoch'
    ) AS "MediaUrlDateUtc",

    ZWAMEDIAITEM.ZTITLE AS "Title",
    ZWAMEDIAITEM.ZLONGITUDE AS "Longitude",
    ZWAMEDIAITEM.ZLATITUDE AS "Latitude",
    ZWAMEDIAITEM.ZFILESIZE AS "Filesize",

    -- Source for each line of data
    'ChatStorage.sqlite; Table: ZWAMESSAGE(Z_PK: ' || ZWAMESSAGE.Z_PK || ')' AS "DataSource"


FROM ZWAMESSAGE
    LEFT JOIN ZWACHATSESSION ON ZWAMESSAGE.ZCHATSESSION = ZWACHATSESSION.Z_PK
    LEFT JOIN ZWAPROFILEPUSHNAME ON ZWAMESSAGE.ZPUSHNAME = ZWAPROFILEPUSHNAME.ZPUSHNAME
    LEFT JOIN ZWAMEDIAITEM ON ZWAMEDIAITEM.ZMESSAGE = ZWAMESSAGE.Z_PK
    LEFT JOIN ZWAMESSAGEINFO ON ZWAMESSAGEINFO.ZMESSAGE = ZWAMESSAGE.Z_PK


ORDER BY
    ZWAMESSAGE.ZMESSAGEDATE DESC
