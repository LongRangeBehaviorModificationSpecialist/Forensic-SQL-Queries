/*
[DLU]
    19-Nov-2026
*/


SELECT
    /* Add a row number at the beggining of each row */
    ROW_NUMBER() OVER ( ORDER BY messages.created_timestamp ) AS "RowNumber",

    messages._id AS "MessagesId",
    messages.conversation_id AS "ConversationId",

    /*
    ID of recipient of the message
    Removes unnecessary text at the start of the string to leave just the 10-digit phone number
    Formats string as a U.S. phone number, i.e. (###) ###-####
    */
    CASE
        WHEN LENGTH (messages.recipients ) = 12 AND messages.recipients LIKE '+1%'
            THEN '(' || SUBSTR ( messages.recipients, 3, 3 ) || ') ' || SUBSTR ( messages.recipients, 6, 3 ) || '-' || SUBSTR ( messages.recipients, 9, 4 )
        WHEN LENGTH ( messages.recipients) = 11 AND messages.recipients LIKE '1%'
            THEN '(' || SUBSTR ( messages.recipients, 2, 3 ) || ') ' || SUBSTR ( messages.recipients, 5, 3 ) || '-' || SUBSTR ( messages.recipients, 8, 4 )
        WHEN LENGTH ( messages.recipients) = 10
            THEN '(' || SUBSTR ( messages.recipients, 1, 3 ) || ') ' || SUBSTR ( messages.recipients, 4, 3 ) || '-' || SUBSTR ( messages.recipients, 7, 4 )
        ELSE 'Type ' || messages.recipients
    END AS "Recipients",

    /* Name of recipient (if documented) */
    recipients.cache_name AS "RecipientsCacheName",

    /* Message direction (incoming/outgoing) */
    CASE messages.message_box_type
        WHEN 100 THEN 'Incoming'
        WHEN 102 THEN 'Outgoing'
        ELSE messages.message_box_type
    END AS "MessagesMessageBoxType",

    /* Date/Time the message was created in UTC */
    strftime( '%F_%H:%M:%f', messages.created_timestamp / 1000.0, 'unixepoch' ) AS "CreatedTimeStampUtc",

    /* Date/Time the message was sent in UTC */
    strftime( '%F_%H:%M:%f', messages.sent_timestamp / 1000.0, 'unixepoch' ) AS "SentTimeStampUtc",

    messages.remote_message_uri AS "RemoteMessageUri",

    /* Message content */
    parts.text AS "PartsText",

    parts.content_uri AS "PartsContentUri",

    parts.content_type AS "PartsContentType",
    messages.message_type AS "MessageType",

    /* If the message had an attachment, returns the file name */
    parts.file_name AS "PartsFileName",

    /* Output the attached file size formatted with commas as needed */
    printf('%,d', parts.size) AS "PartsSizeBytes",

    /* Output the message size formatted with commas as needed */
    printf('%,d', messages.message_size) AS "MessageSizeBytes",

    /* Was the message read */
    messages.is_read AS "IsRead?",

    /* Date/Time the message was updated (if any) in UTC */
    strftime( '%F_%H:%M:%f', messages.updated_timestamp / 1000.0, 'unixepoch' ) AS "UpdatedTimestampUtc",

    messages.creator AS "Creator",
    messages.remote_creator AS "RemoteCreator",
    messages.req_app_id AS "ReqAppId",

    /* Source for each line of data */
    'File: \data\data\com.samsung.android.messaging\databases\message_content.db; Table: messages(_id: ' || messages._id || ')' AS "DataSource"


FROM messages

    LEFT OUTER JOIN parts ON messages._id = parts.message_id
    LEFT OUTER JOIN recipients ON messages.conversation_id = recipients._id


ORDER BY messages._id ASC
