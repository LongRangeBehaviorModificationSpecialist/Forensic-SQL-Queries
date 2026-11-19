/*
[DLU]
    20-Apr-2026
Copied from
    https://towardsdatAScience.com/analyzing-my-whatsapp-databASe-using-sql-and-redASh-5ef9bd6a0b0
*/

SELECT

    ROW_NUMBER() OVER() AS 'RowNumber',

    ZWACHATSESSION.ZPARTNERNAME AS 'PartnerName',

    CASE ZWAMESSAGE.ZISFROMME
        WHEN 0 THEN ZWAMESSAGE.ZFROMJID
        ELSE ZWAMESSAGE.ZTOJID
    END AS 'IsFromMe',

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
        ELSE ZWAMESSAGE.ZMESSAGETYPE
T
    datetime(ZWAMESSAGE.ZMESSAGEDATE + 978307200, 'UNIXEPOCH') AS 'MessageDateUtc',

    ZWAMESSAGE.ZTEXT AS 'Text'


FROM ZWACHATSESSION
    INNER JOIN ZWAMESSAGE ON ZWACHATSESSION.ZCONTACTJID == 'FriendNumber'


WHERE
    ZWACHATSESSION.ZSESSIONTYPE == 0
