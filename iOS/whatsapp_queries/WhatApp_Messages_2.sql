/*
[DLU]
    20-Nov-2026
[URL]
    https://towardsdatAScience.com/analyzing-my-whatsapp-databASe-using-sql-and-redASh-5ef9bd6a0b0
[DATABASE]

[NOTES]
*/


SELECT

    ROW_NUMBER() OVER ( ORDER BY ZWAMESSAGE.ZMESSAGEDATE ) AS RowNumber,

    ZWACHATSESSION.ZPARTNERNAME AS PartnerName,

    CASE ZWAMESSAGE.ZISFROMME
        WHEN 0 THEN ZWAMESSAGE.ZFROMJID
        ELSE ZWAMESSAGE.ZTOJID
    END AS IsFromMe,

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
        ELSE 'Type: [' || ZWAMESSAGE.ZMESSAGETYPE  || ']'
    END AS MessageType,
T
    strftime ( '%F_%H:%M:%f', ZWAMESSAGE.ZMESSAGEDATE + 978307200, 'unixepoch') AS MessageDateUtc,

    ZWAMESSAGE.ZTEXT AS MessageText,

    /* Source for each line of data */
    -- TODO -> update database file name and primary key column name
    '________; Table:_____(____:' ||  _____________ || ')' AS DataSource


FROM ZWACHATSESSION
    INNER JOIN ZWAMESSAGE ON ZWACHATSESSION.ZCONTACTJID == 'FriendNumber'


WHERE
    ZWACHATSESSION.ZSESSIONTYPE == 0
