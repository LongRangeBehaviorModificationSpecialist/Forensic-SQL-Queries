/*
[DLU]
    19-Nov-2026
Copied from
    https://towardsdatascience.com/analyzing-my-whatsapp-database-using-sql-and-redash-5ef9bd6a0b0
*/

CREATE view group_messages AS

SELECT

    ROW_NUMBER() OVER ( ORDER BY ZWAMESSAGE.ZMESSAGEDATE ) AS "RowNumber",

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

    CASE ZWAMESSAGE.ZISFROMME
        WHEN 0 THEN ZWAMESSAGE.ZFROMJID
        ELSE ZWAMESSAGE.ZTOJID
    END AS "GroupId",

    CASE ZWAMESSAGE.ZMESSAGETYPE
        WHEN 0 THEN 'Text'
        WHEN 1 THEN 'Image'
        WHEN 2 THEN 'Video'
        WHEN 3 THEN 'Voice Message'
        WHEN 4 THEN 'Gif'
        WHEN 5 THEN 'Location'
        WHEN 6 THEN 'Group Event'
        WHEN 7 THEN 'Hyperlink'
        WHEN 8 THEN 'Document'
        WHEN 14 THEN 'Deleted Message'
        WHEN 15 THEN 'Sticker'
        ELSE 'Unknown Value: ' || ZWAMESSAGE.ZMESSAGETYPE || ''
    END AS "MessageType",

    ZWAMESSAGE.ZTEXT AS "MessageText",
    friend_chat_session.ZPARTNERNAME AS "FriendChatSessionPartnerName",
    ZWAGROUPMEMBER.ZMEMBERJID AS "MemberJid"


FROM ZWACHATSESSION
    INNER JOIN ZWAMESSAGE ON ZWACHATSESSION.ZCONTACTJID == "Group ID"
    LEFT JOIN ZWAGROUPMEMBER ON ZWAMESSAGE.ZGROUPMEMBER == ZWAGROUPMEMBER.Z_PK
    LEFT JOIN ZWACHATSESSION AS friend_chat_session ON ZWAGROUPMEMBER.ZMEMBERJID == friend_chat_session.ZCONTACTJID


WHERE
    ZWACHATSESSION.ZSESSIONTYPE == 1 AND message_type NOT IN ('unknown', 'group_event');
