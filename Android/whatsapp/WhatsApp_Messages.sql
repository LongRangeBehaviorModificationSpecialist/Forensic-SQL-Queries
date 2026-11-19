/*
Query copied from https://thebinaryhick.blog/2022/06/09/new-msgstore-who-dis-a-look-at-an-updated-whatsapp-on-android/

[DLU]
    18-Nov-2026
[PATH]
    /data/data/com.whatsapp/databases
[FILES]
    msgstore.db
    wa.db
*/


-- ATTACH DATABASE 'file:./wa.db?mode=rw' AS wa_db;

WITH ParsedMessages AS (

    SELECT

        ROW_NUMBER() OVER( ORDER BY message._id ) AS 'RecordNumber',

        message._id AS 'MessageId',
        message.chat_row_id AS 'MessageChatRowId',

        CASE message.from_me
            WHEN '0' THEN 'Incoming'
            WHEN '1' THEN 'Outgoing'
        END AS 'MessageFromMe',

        datetime( message.timestamp / 1000, 'unixepoch' ) AS 'MessageTimestampUtc',

        CASE
            WHEN message.received_timestamp = '0' THEN NULL
            ELSE datetime( message.received_timestamp / 1000, 'unixepoch' )
        END AS 'MessageReceivedTimestampUtc',

        CASE
            WHEN message.receipt_server_timestamp = '-1' THEN '-1'
            ELSE datetime( message.receipt_server_timestamp / 1000, 'unixepoch' )
        END AS 'MessageReceiptServerTimestampUtc',

        CASE
            WHEN receipt_device.receipt_device_timestamp = '0' THEN NULL
            ELSE datetime( receipt_device.receipt_device_timestamp / 1000, 'unixepoch' )
        END AS 'ReceiptDeviceTimestampUtc',

        CASE
            WHEN receipt_user.read_timestamp is '0' THEN NULL
            ELSE datetime( receipt_user.read_timestamp / 1000, 'unixepoch' )
        END AS 'ReceiptUserReadTimestampUtc',

        CASE message.recipient_count
            WHEN NULL THEN NULL
            WHEN '0' THEN 'DirectMessage'
            WHEN '1' THEN 'GroupMessage'
            ELSE message.recipient_count
        END AS 'MessageRecipientCount',

        CASE wa_contacts.wa_name
            WHEN NULL THEN NULL
            ELSE wa_contacts.wa_name
        END AS 'WaContactsWaName',

        CASE wa_contacts.sort_name
            WHEN NULL THEN NULL
            ELSE wa_contacts.sort_name
        END AS 'WaContactsSortName',

        CASE wa_contacts.display_name
            WHEN NULL THEN NULL
            ELSE wa_contacts.display_name
        END AS 'WaContactsDisplayName',

        CASE wa_contacts.given_name
            WHEN NULL THEN NULL
            ELSE wa_contacts.given_name
        END AS 'WaContactsGivenName',

        sender_jid.raw_string AS 'SenderJid',
        chat_jid.raw_string AS 'ChatJid',
        COALESCE( pn_jid.raw_string, pn_jid.user || '@' || pn_jid.server ) AS 'PnJidResolvedFromLid',
        wa_contacts.jid AS 'WaContactsJid',
        wa_contacts.number AS 'WaContactsNumber',
        wa_contacts.raw_contact_id AS 'WaContactsRawContactID',

        CASE wa_contacts.is_starred
            WHEN NULL THEN NULL
            WHEN '0' THEN 'NotStarred'
            WHEN '1' THEN 'Starred'
            ELSE wa_contacts.is_starred
        END AS 'WaContactsIsStarred',

        CASE wa_contacts.is_contact_synced
            WHEN NULL THEN NULL
            WHEN '0' THEN 'NotSynced'
            WHEN '1' THEN 'Synced'
            ELSE wa_contacts.is_contact_synced
        END AS 'WaContactsIsContactSynced',

        CASE message.message_type
            WHEN '0'  THEN 'Text'
            WHEN '1'  THEN 'Picture'
            WHEN '2'  THEN 'Audio'
            WHEN '3'  THEN 'Video'
            WHEN '4'  THEN 'Gif'
            WHEN '5'  THEN 'Static Location'
            WHEN '7'  THEN 'System Message'
            WHEN '9'  THEN 'Document'
            WHEN '14' THEN 'Deleted Message'
            WHEN '15' THEN 'Sticker'
            WHEN '16' THEN 'Live Location'
            ELSE message.message_type
        END AS 'MessageType',

        message.text_data AS 'MessageText',

        CASE message.status
            WHEN '0'  THEN 'Received Message / Read By Local User [0]'
            WHEN '6'  THEN 'Sent Unsuccessful (No Response From Server) [6]'
            WHEN '13' THEN 'Sent Successful [13]'
        END AS 'MessageStatus',

        message_media.mime_type AS 'MessageMediaMimeType',
        message_media.file_path AS 'MessageMediaFilePath',
        message_media.message_url AS 'MessageMediaMessageUrl',
        printf("%,d", message_media.file_size) AS 'MessageMediaFileSizeBytes',

        CASE
            WHEN message_media.media_key_timestamp = '0' THEN NULL
            ELSE datetime( message_media.media_key_timestamp / 1000, 'unixepoch' )
        END AS 'MessageMediaKeyTimestampUtc',

        message_media.width AS 'MessageMediaWidth',
        message_media.height AS 'MessageMediaHeight',
        message_media.media_duration AS 'MessageMediaDuration',

        message_location.latitude AS 'MessageLocationLatitude',
        message_location.longitude AS 'MessageLocationLongitude',
        message_location.live_location_share_duration AS 'LiveLocationShareDurationSeconds',
        message_location.live_location_final_latitude AS 'LiveLocationFinalLatitude',
        message_location.live_location_final_longitude AS 'LiveLocationFinalLongitude',

        CASE
            WHEN message_location.live_location_final_timestamp IS NULL THEN NULL
            ELSE datetime( message_location.live_location_final_timestamp / 1000, 'unixepoch' )
        END AS 'LiveLocationFinalTimestamp',

        /* Source for each line of data */
        'File: /data/data/com.whatsapp/databases/msgstore.db; Table:message(_id:' || message._id || ')' AS 'DataSource'

    FROM message

    JOIN chat ON chat._id = message.chat_row_id

    /* Actual sender JID - populated for group messages, typically NULL/0 in 1:1 chats */
    LEFT JOIN jid AS sender_jid ON sender_jid._id = message.sender_jid_row_id

    /* Remote party of the chat; mirrors the database's own chat_view definition */
    LEFT JOIN jid AS chat_jid ON chat_jid._id = COALESCE( chat.account_jid_row_id, chat.jid_row_id )

    /* If the effective JID is a LID, resolve it to the phone-number JID via jid_map */
    LEFT JOIN jid_map
        ON jid_map.lid_row_id = COALESCE( NULLIF( message.sender_jid_row_id, 0 ), chat_jid._id )
    LEFT JOIN jid AS pn_jid ON pn_jid._id = jid_map.jid_row_id

    /*
    Contacts live in the attached wa.db; match on the best available JID string
    If you change the name of the attached database from `wa_db`, ensure that you
    change the `wa_db.wa_contacts` name to the the name of the attached database
    */
    -- LEFT JOIN wa_db.wa_contacts AS wa_contacts
    LEFT JOIN wa_db.wa_contacts AS wa_contacts
        ON wa_contacts.jid = CASE
            WHEN COALESCE( sender_jid.raw_string, chat_jid.raw_string ) LIKE '%@lid'
                THEN COALESCE( pn_jid.raw_string, pn_jid.user || '@' || pn_jid.server )
            ELSE COALESCE(
                sender_jid.raw_string, sender_jid.user || '@' || sender_jid.server,
                chat_jid.raw_string, chat_jid.user || '@' || chat_jid.server
            )
        END

    LEFT JOIN receipt_device ON receipt_device.message_row_id = message._id
    LEFT JOIN receipt_user ON receipt_user.message_row_id = message._id
    LEFT JOIN message_media ON message_media.message_row_id = message._id
    LEFT JOIN message_location ON message_location.message_row_id = message._id
)

SELECT

    pm.RecordNumber,
    pm.MessageId,
    pm.MessageChatRowId,
    pm.MessageTimestampUtc,
    pm.MessageReceivedTimestampUtc,
    pm.MessageReceiptServerTimestampUtc,
    pm.ReceiptDeviceTimestampUtc,
    pm.ReceiptUserReadTimestampUtc,
    pm.MessageRecipientCount,
    pm.WaContactsWaName,
    pm.WaContactsSortName,
    pm.WaContactsDisplayName,
    pm.WaContactsGivenName,
    pm.SenderJid,
    pm.ChatJid,
    pm.PnJidResolvedFromLid,
    pm.WaContactsJid,
    pm.WaContactsNumber,
    pm.WaContactsRawContactID,
    pm.WaContactsIsStarred,
    pm.WaContactsIsContactSynced,
    pm.MessageFromMe,
    pm.MessageType,

    CASE
        WHEN pm.MessageFromMe = 'Incoming' THEN COALESCE( pm.MessageText, '' )
        ELSE NULL
    END AS 'IncomingMsgText',

    CASE
        WHEN pm.MessageFromMe = 'Outgoing' THEN COALESCE( pm.MessageText, '' )
        ELSE NULL
    END AS 'OutgoingMsgText',

    pm.MessageStatus,
    pm.MessageMediaMimeType,
    pm.MessageMediaFilePath,
    pm.MessageMediaMessageUrl,
    pm.MessageMediaFileSizeBytes,
    pm.MessageMediaKeyTimestampUtc,
    pm.MessageMediaWidth,
    pm.MessageMediaHeight,
    pm.MessageMediaDuration,
    pm.MessageLocationLatitude,
    pm.MessageLocationLongitude,
    pm.LiveLocationShareDurationSeconds,
    pm.LiveLocationFinalLatitude,
    pm.LiveLocationFinalLongitude,
    pm.LiveLocationFinalTimestamp,
    pm.DataSource


FROM ParsedMessages pm

WHERE pm.WaContactsWaName LIKE '%Jaycee%'

ORDER BY pm.MessageTimestampUtc ASC;

-- DETACH DATABASE wa_db;
