/*
[DLU]
    03-Nov-2026
iOS11 - WhatsApp messages
    \Application Groups\net.whatsapp.WhatsApp.shared\ChatStorage.sqlite
*/

SELECT

    ROW_NUMBER() OVER() AS 'RowNumber',

    ZWAMESSAGE.z_pk AS 'ZPk',

    datetime(ZWAMESSAGE.ZMESSAGEDATE + 978307200, 'unixepoc') AS 'MessageDateUtc',

    ZWACHATSESSION.ZPARTNERNAME AS 'PartnerName',

    CASE ZWAMESSAGE.ZISFROMME
        WHEN 0 THEN 'Incoming [0]'
        WHEN 1 THEN 'Outgoing [1]'
        ELSE 'Unknown Value: ' || ZWAMESSAGE.ZISFROMME || ''
    END AS 'IsFromMe',

    ZWAMESSAGE.ZFROMJID AS 'FromJid',
    ZWAMESSAGE.ZTOJID AS 'ToJid',

    datetime(ZWAMESSAGE.ZSENTDATE + 978307200, 'unixepoc') AS 'SentDateUtc',

    CASE ZWAMESSAGE.ZMESSAGETYPE
        WHEN 0 THEN 'Text [0]'
        WHEN 1 THEN 'Image [1]'
        WHEN 2 THEN 'Video [2]'
        WHEN 3 THEN 'VoiceMessage [3]'
        WHEN 4 THEN 'Gif [4]'
        WHEN 5 THEN 'Location [5]'
        WHEN 6 THEN 'GroupEvent [6]'
        WHEN 7 THEN 'Hyperlink [7]'
        WHEN 8 THEN 'Document [8]'
        WHEN 14 THEN 'DeletedMessage [14]'
        WHEN 15 THEN 'Sticker [15]'
        ELSE 'Unknown Value: ' || ZWAMESSAGE.ZMESSAGETYPE || ''
    END AS 'MessageType',

    CASE ZWACHATSESSION.ZHIDDEN
        WHEN 0 THEN 'No [0]'
        WHEN 1 THEN 'Yes [1]'
        ELSE 'Unknown Value: ' || ZWACHATSESSION.ZHIDDEN || ''
    END AS 'Hidden',

    ZWAMESSAGE.ZMEDIASECTIONID AS 'MediaSectionId',
    ZWAMEDIAITEM.ZMEDIALOCALPATH AS 'MediaLocalPath',
    ZWAMEDIAITEM.ZVCARDSTRING AS 'VCardString',

    time(ZWAMEDIAITEM.ZMOVIEDURATION, 'unixepoc') AS 'MovieDuration',

    ZWAMESSAGE.ZSTARRED AS 'Starred',
    ZWAMEDIAITEM.ZMEDIAURL AS 'MediaUrl',

    datetime(ZWAMEDIAITEM.ZMEDIAURLDATE + 978307200, 'unixepoc') AS 'MediaUrlDateUtc',

    ZWAMEDIAITEM.ZTITLE AS 'Title',
    ZWAMEDIAITEM.ZLONGITUDE AS 'Longitude',
    ZWAMEDIAITEM.ZLATITUDE AS 'Latitude',
    ZWAMEDIAITEM.ZFILESIZE AS 'Filesize',

    -- Source for each line of data
    'ChatStorage.sqlite; Table: ZWAMESSAGE(Z_PK: ' || ZWAMESSAGE.Z_PK || ')' AS 'DataSource'


FROM ZWAMESSAGE
    LEFT JOIN ZWACHATSESSION ON ZWAMESSAGE.ZCHATSESSION = ZWACHATSESSION.Z_PK
    LEFT JOIN ZWAPROFILEPUSHNAME ON ZWAMESSAGE.ZPUSHNAME = ZWAPROFILEPUSHNAME.ZPUSHNAME
    LEFT JOIN ZWAMEDIAITEM ON ZWAMEDIAITEM.ZMESSAGE = ZWAMESSAGE.Z_PK
    LEFT JOIN ZWAMESSAGEINFO ON ZWAMESSAGEINFO.ZMESSAGE = ZWAMESSAGE.Z_PK


ORDER BY
    ZWAMESSAGE.ZMESSAGEDATE DESC
