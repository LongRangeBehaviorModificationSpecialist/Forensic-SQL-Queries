/*
Query copied from https://thebinaryhick.blog/2022/06/09/new-msgstore-who-dis-a-look-at-an-updated-whatsapp-on-android/

This query is slightly different as an examiner would also need the group/conversation name along with the party sending the message(s) within the group
*/

SELECT
    ROW_NUMBER() OVER() AS 'RecordNumber',
    --ATTACH DATABASE "[FILE-PATH-TO-DATABASE]" AS 'whatsapp_db';
    message._id AS 'MessageId',

    datetime( message.timestamp / 1000, 'unixepoch' ) AS 'MessageTimestampUtc',

    CASE
        WHEN datetime message.received_timestamp = '0' THEN NULL
        ELSE datetime( message.received_timestamp / 1000, 'unixepoch')
    END AS 'MessageReceivedTimestampUtc',

    chat.subject AS 'ChatSubject',

    CASE
        WHEN message.from_me = 1 THEN 'Self [1]'
        ELSE wa_contacts.wa_name
    END AS 'MessageFromMe',

    CASE
        WHEN message.from_me = 0 THEN 'Incoming [0]'
        WHEN message.from_me = 1 THEN 'Outgoing [1]'
    END AS 'MessageDirection',

    CASE message.message_type
        WHEN 0  THEN 'Text [0]'
        WHEN 1  THEN 'Picture [1]'
        WHEN 2  THEN 'Audio [2]'
        WHEN 3  THEN 'Video [3]'
        WHEN 5  THEN 'Static Location [5]'
        WHEN 7  THEN 'System Message [7]'
        WHEN 9  THEN 'Document [9]'
        WHEN 16 THEN 'Live Location [16]'
        ELSE message.message_type
    END AS 'MessageMessageType',

    message.text_data AS 'MessageTextData',
    message_media.file_path AS 'MessageMediaFilePath',
    printf("%,d", message_media.file_size) AS 'MessageMediaFileSizeBytes',
    message_media.width AS 'MessageMediaWidth',
    message_media.height AS 'MessageMediaHeight',

    CASE message_location.latitude
        WHEN NULL THEN NULL
        ELSE message_location.latitude
    END AS 'MessageLocationLatitudeLiveLocation',

    CASE message_location.longitude
        WHEN NULL THEN NULL
        ELSE message_location.longitude
    END AS 'MessageLocationLongitudeLiveLocation',

    message_location.live_location_share_duration AS 'LiveLocationShareDurationSeconds',
    message_location.live_location_final_latitude AS 'LiveLocationFinalLatitude',
    message_location.live_location_final_longitude AS 'LiveLocationFinalLongitude',

    datetime(message_location.live_location_final_timestamp / 1000, 'UNIXEPOCH') AS 'LiveLocationFinalTimestampUtc'


FROM message
    JOIN chat ON chat._id = message.chat_row_id
    LEFT JOIN jid ON jid._id = message.sender_jid_row_id
    LEFT JOIN message_media ON message_media.message_row_id = message._id
    LEFT JOIN message_location ON message_location.message_row_id = message._id
    LEFT JOIN wa_contacts ON wa_contacts.jid = jid.raw_string


/* Will indicate whether the message is a group message */
WHERE message.recipient_count >= 1


ORDER BY message.timestamp ASC
