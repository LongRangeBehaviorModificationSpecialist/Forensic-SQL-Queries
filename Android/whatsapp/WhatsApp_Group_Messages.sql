/*
Original query copied from https://thebinaryhick.blog/2022/06/09/new-msgstore-who-dis-a-look-at-an-updated-whatsapp-on-android/

This query is slightly different as an examiner would also need the group/conversation name along with the party sending the message(s) within the group
*/

--ATTACH DATABASE "[FILE-PATH-TO-DATABASE]" AS 'whatsapp_db';

SELECT
    ROW_NUMBER() OVER ( ORDER BY message.timestamp ) AS "RowNumber",
    message._id AS "MessageId",

    strftime ( '%F_%H:%M:%f', message.timestamp / 1000.0, 'unixepoch' ) AS "MessageTimestampUtc",
    strftime ( '%F_%H:%M:%f', message.received_timestamp / 1000.0, 'unixepoch' ) AS "MessageReceivedTimestampUtc",

    chat.subject AS "ChatSubject",

    CASE
        WHEN message.from_me = 1 THEN 'Self'
        ELSE 'Type ' || wa_contacts.wa_name
    END AS "MessageFromMe",

    CASE message.from_me
        WHEN 0 THEN 'Incoming'
        WHEN 1 THEN 'Outgoing'
        ELSE 'Type ' || message.from_me
    END AS "MessageDirection",

    CASE message.message_type
        WHEN 0 THEN 'Text'
        WHEN 1 THEN 'Picture'
        WHEN 2 THEN 'Audio'
        WHEN 3 THEN 'Video'
        WHEN 5 THEN 'Static Location'
        WHEN 7 THEN 'System Message'
        WHEN 9 THEN 'Document'
        WHEN 16 THEN 'Live Location'
        ELSE 'Type ' || message.message_type
    END AS "MessageType",

    message.text_data AS "TextData",
    message_media.file_path AS "MediaFilePath",
    printf ( '%,d', message_media.file_size ) AS "MediaFileSizeBytes",
    message_media.width AS "MediaWidth",
    message_media.height AS "MediaHeight",
    message_location.latitude AS "LocationLatitudeLiveLocation",
    message_location.longitude AS "LocationLongitudeLiveLocation",
    message_location.live_location_share_duration AS "LiveLocationShareDurationSeconds",
    message_location.live_location_final_latitude AS "LiveLocationFinalLatitude",
    message_location.live_location_final_longitude AS "LiveLocationFinalLongitude",

    strftime ( '%F_%H:%M:%f', message_location.live_location_final_timestamp / 1000.0, 'unixepoch' ) AS "LiveLocationFinalTimestampUtc"


FROM message
    JOIN chat ON chat._id = message.chat_row_id
    LEFT JOIN jid ON jid._id = message.sender_jid_row_id
    LEFT JOIN message_media ON message_media.message_row_id = message._id
    LEFT JOIN message_location ON message_location.message_row_id = message._id
    LEFT JOIN wa_contacts ON wa_contacts.jid = jid.raw_string


/* If >= 1, then it will indicate whether the message is a group message */
-- WHERE message.recipient_count >= 1


ORDER BY message.timestamp ASC
