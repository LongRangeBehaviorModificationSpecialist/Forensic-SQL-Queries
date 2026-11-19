/*
[DLU]
    19-Nov-2026
[FILE PATH]
    /private/var/mobile/Library/SMS/sms.db
[FILE PATH]
    /private/var/mobile/Library/AddressBook/AddressBook.sqlitedb
*/

-- ATTACH DATABASE 'AddressBook.sqlitedb' AS 'AddressBook_db';

SELECT

    /* Add a row number at the beggining of each row */
    ROW_NUMBER() OVER( message.date ) AS "RowNumber",
    message.ROWID AS "RowId",
    chat_message_join.message_id AS "CMJMessageId",

    /*
    When `chat_message_join.chat_id` is NULL, that means the message was deleted,
    but there is still a record of the message in the message table.
    It is likely that the vacuum functions has not run to delete the message from the table
    */
    chat_message_join.chat_id AS "CMJChatId",

    CASE
        WHEN LENGTH ( message.date ) = 18
            THEN strftime ( '%F_%H:%M:%fZ', ( message.date / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( message.date ) = 9
            THEN strftime ( '%F_%H:%M:%fZ', message.date + 978307200, 'unixepoch' )
        ELSE 'Type ' || message.date
    END AS "MessageDateUtc",

    CASE message.is_delivered
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type ' || message.is_delivered
    END AS "IsDelivered",

    CASE
        WHEN LENGTH ( message.date_delivered ) = 18
            THEN strftime ( '%F_%H:%M:%fZ', ( message.date_delivered / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( message.date_delivered ) = 9
            THEN strftime ( '%F_%H:%M:%fZ', message.date_delivered + 978307200, 'unixepoch' )
        WHEN message.date_delivered IS 0 THEN '[N/A]'
        ELSE 'Type ' || message.date_delivered
    END AS "DateDeliveredUtc",

    CASE
        WHEN LENGTH ( message.date_read ) = 18
            THEN strftime ( '%F_%H:%M:%fZ', ( message.date_read / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( message.date_read ) = 9
            THEN strftime ( '%F_%H:%M:%fZ', message.date_read + 978307200, 'unixepoch' )
        WHEN message.date_read IS 0 THEN '[N/A]'
        ELSE 'Type ' || message.date_read
    END AS "DateReadUtc",

    CASE
        WHEN LENGTH ( message.date_edited ) = 18
            THEN strftime ( '%F_%H:%M:%fZ', ( message.date_edited / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( message.date_edited ) = 9
            THEN strftime ( '%F_%H:%M:%fZ', message.date_edited + 978307200, 'unixepoch' )
        WHEN message.date_edited IS 0 THEN '[N/A]'
        ELSE 'Type ' || message.date_edited
    END AS "DateEditedUtc",

    CASE
        WHEN LENGTH ( message.date_retracted) = 18
            THEN strftime ( '%F_%H:%M:%fZ', ( message.date_retracted / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( message.date_retracted ) = 9
            THEN strftime ( '%F_%H:%M:%fZ', message.date_retracted + 978307200, 'unixepoch' )
        WHEN message.date_retracted IS 0 THEN '[N/A]'
        ELSE 'Type ' || message.date_retracted
    END AS "DateRetractedUtc",

    CASE
        WHEN LENGTH ( chat_recoverable_message_join.delete_date ) = 18
            THEN strftime ( '%F_%H:%M:%fZ', ( chat_recoverable_message_join.delete_date / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( chat_recoverable_message_join.delete_date) = 9
            THEN strftime ( '%F_%H:%M:%fZ', chat_recoverable_message_join.delete_date + 978307200, 'unixepoch' )
        WHEN chat_recoverable_message_join.delete_date IS 0 THEN '[N/A]'
        ELSE 'Type ' || chat_recoverable_message_join.delete_date
    END AS "CRMJDeleteDateUtc",

    CASE message.share_status
        WHEN 0 THEN 'Not Shared'
        WHEN 1 THEN 'Shared'
        ELSE 'Type ' || message.share_status
    END AS "ShareStatus",

    CASE message.share_direction
        WHEN 0 THEN 'Received'
        WHEN 1 THEN 'Sent'
        ELSE 'Type ' || message.share_direction
    END AS "ShareDirection",


    handle.ROWID AS "HandleRowId",

    /*
    Handle ID of the message
    Removes unnecessary text at the start of the string to leave just the 10-digit phone number
    Formats string as a U.S. phone number, i.e. (###) ###-####
    */
    CASE
        WHEN LENGTH ( handle.id ) = 14 AND handle.id LIKE '%p:+1%'
            THEN '(' || SUBSTR ( handle.id, 5, 3 ) || ') ' || SUBSTR ( handle.id, 8, 3 ) || '-' || SUBSTR ( handle.id, 11, 4 )
        WHEN LENGTH ( handle.id ) = 12 AND handle.id LIKE '+1%'
            THEN '(' || SUBSTR ( handle.id, 3, 3 ) || ') ' || SUBSTR ( handle.id, 6, 3 ) || '-' || SUBSTR ( handle.id, 9, 4 )
        WHEN LENGTH ( handle.id ) = 11 AND handle.id LIKE '1%'
            THEN '(' || SUBSTR ( handle.id, 2, 3 ) || ') ' || SUBSTR ( handle.id, 5, 3 ) || '-' || SUBSTR ( handle.id, 8, 4 )
        WHEN LENGTH ( handle.id ) = 10
            HEN '(' || SUBSTR ( handle.id, 1, 3 ) || ') ' || SUBSTR ( handle.id, 4, 3 ) || '-' || SUBSTR ( handle.id, 7, 4 )
        WHEN handle.id IS NULL THEN '[N/A]'
        ELSE 'Type ' || handle.id
    END AS "HandleId",

    CASE chat.style
        WHEN 43 THEN 'Group Chat'
        WHEN 45 THEN 'P2P'
        ELSE 'Type ' || chat.style
    END AS "ChatStyle",

    CASE message.is_from_me
        WHEN 0 THEN 'Incoming'
        WHEN 1 THEN 'Outgoing'
        ELSE '[Unknown Value : ' || message.is_from_me || ']'
    END AS "MessageIsFromMe",

    CASE message.type
        WHEN 0 THEN 'Message'
        WHEN 1 THEN 'Group Participant Added'
        WHEN 2 THEN 'Group Renamed'
        WHEN 3 THEN 'GroupActionType 0=Participant_Leaves/GroupActionType 1=GroupPhotoChanged'
        WHEN 4 THEN 'Location Sharing Data'
        WHEN 5 THEN 'Unknown'
        WHEN 6 THEN 'Unknown'
        ELSE '[Unknown Value : ' || message.type || ']'
    END AS "MessageType",

    message.service AS "MessageService",

    /*
    Message account
    Removes unnecessary text at the start of the string to leave just the 10-digit phone number
    Formats string as a U.S. phone number, i.e. (###) ###-####
    */
    CASE
        WHEN LENGTH(message.account) = 14 AND message.account LIKE '%p:+1%' THEN '(' || SUBSTR(message.account, 5, 3) || ') ' || SUBSTR(message.account, 8, 3) || '-' || SUBSTR(message.account, 11, 4)
        WHEN LENGTH(message.account) = 12 AND message.account LIKE '+1%' THEN '(' || SUBSTR(message.account, 3, 3) || ') ' || SUBSTR(message.account, 6, 3) || '-' || SUBSTR(message.account, 9, 4)
        WHEN LENGTH(message.account) = 11 AND message.account LIKE '1%' THEN '(' || SUBSTR(message.account, 2, 3) || ') ' || SUBSTR(message.account, 5, 3) || '-' || SUBSTR(message.account, 8, 4)
        WHEN LENGTH(message.account) = 10 THEN '(' || SUBSTR(message.account, 1, 3) || ') ' || SUBSTR(message.account, 4, 3) || '-' || SUBSTR(message.account, 7, 4)
        WHEN message.account IS NULL THEN '[N/A]'
        ELSE 'Type ' || message.account
    END AS "MessageAccount",

    message.cache_roomnames AS "MessageCacheRoomnames",

    CASE
        WHEN message.text IS NULL THEN '**NO TEXT**'
        ELSE message.text
    END AS "MessageText",

    chat.display_name AS "ChatDisplayName",

    CASE message.cache_has_attachments
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE '[Unknown Value : ' || message.cache_has_attachments || ']'
    END AS "MessageCacheHasAttachments",

    CASE attachment.is_outgoing
        WHEN 0 THEN 'Incoming'
        WHEN 1 THEN 'Outgoing'
        ELSE '[Unknown Value : ' || attachment.is_outgoing || ']'
    END AS "AttachmentIsOutgoing",

    attachment.ROWID AS "AttachmentRowId",
    attachment.filename AS "AttachmentFilename",
    attachment.transfer_name AS "AttachmentTransferName",
    printf ( '%,d', attachment.total_bytes ) AS "AttachmentTotalBytes",
    attachment.mime_type AS "AttachmentMimeType",
    attachment.guid AS "AttachmentGuid",
    attachment.attribution_info AS "AttachmentAttributionInfo",

    /* Date the attachment was created */
    CASE
        WHEN LENGTH ( attachment.created_date ) = 18
            THEN strftime ( '%F_%H:%M:%fZ', ( attachment.created_date / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( attachment.created_date ) = 9
            THEN strftime ( '%F_%H:%M:%fZ', attachment.created_date + 978307200, 'unixepoch' )
        WHEN attachment.created_date IS NULL THEN '[N/A]'
        ELSE 'Type ' || attachment.created_date
    END AS "AttachmentCreatedDateUtc",

    attachment.uti AS "AttachmentUti",
    -- observed values 5 (temp folder) & 6 (Library)
    attachment.transfer_state AS "AttachmentTransferState",
    hex ( attachment.user_info ) AS "AttachmentUserInfo(bplist)",
    chat.room_name AS "ChatRoomName",

    CASE
        WHEN LENGTH ( chat.chat_identifier ) = 14 AND chat.chat_identifier LIKE '%p:+1%'
            THEN '(' ||
                SUBSTR ( chat.chat_identifier, 5, 3 ) ||
                ') ' ||
                SUBSTR ( chat.chat_identifier, 8, 3 ) ||
                '-' ||
                SUBSTR ( chat.chat_identifier, 11, 4 )
        WHEN LENGTH ( chat.chat_identifier ) = 12 AND chat.chat_identifier LIKE '+1%'
            THEN '(' ||
                SUBSTR ( chat.chat_identifier, 3, 3 ) ||
                ') ' ||
                SUBSTR ( chat.chat_identifier, 6, 3 ) ||
                '-' ||
                SUBSTR ( chat.chat_identifier, 9, 4 )
        WHEN LENGTH ( chat.chat_identifier ) = 11 AND chat.chat_identifier LIKE '1%'
            THEN '(' ||
                SUBSTR ( chat.chat_identifier, 2, 3 ) ||
                ') ' ||
                SUBSTR ( chat.chat_identifier, 5, 3 ) ||
                '-' ||
                SUBSTR ( chat.chat_identifier, 8, 4)
        WHEN LENGTH ( chat.chat_identifier ) = 10
            THEN '(' ||
                SUBSTR ( chat.chat_identifier, 1, 3 ) ||
                ') ' ||
                SUBSTR ( chat.chat_identifier, 4, 3 ) ||
                '-' ||
                SUBSTR ( chat.chat_identifier, 7, 4 )
        WHEN chat.chat_identifier IS NULL THEN '[N/A]'
        ELSE 'Type ' || chat.chat_identifier
    END AS "ChatIdentifier",

    CASE
        WHEN LENGTH ( chat.last_addressed_handle ) = 14 AND chat.last_addressed_handle LIKE '%p:+1%'
            THEN '(' ||
                SUBSTR ( chat.last_addressed_handle, 5, 3 ) ||
                ') ' ||
                SUBSTR ( chat.last_addressed_handle, 8, 3 ) ||
                '-' ||
                SUBSTR ( chat.last_addressed_handle, 11, 4 )
        WHEN LENGTH ( chat.last_addressed_handle ) = 12 AND chat.last_addressed_handle LIKE '+1%'
            THEN '(' ||
                SUBSTR ( chat.last_addressed_handle, 3, 3 ) ||
                ') ' ||
                SUBSTR ( chat.last_addressed_handle, 6, 3 ) ||
                '-' ||
                SUBSTR ( chat.last_addressed_handle, 9, 4 )
        WHEN LENGTH ( chat.last_addressed_handle ) = 11 AND chat.last_addressed_handle LIKE '1%'
            THEN '(' ||
                SUBSTR ( chat.last_addressed_handle, 2, 3 ) ||
                ') ' ||
                SUBSTR ( chat.last_addressed_handle, 5, 3 ) ||
                '-' ||
                SUBSTR ( chat.last_addressed_handle, 8, 4 )
        WHEN LENGTH ( chat.last_addressed_handle ) = 10
            THEN '(' ||
                SUBSTR ( chat.last_addressed_handle, 1, 3 ) ||
                ') ' ||
                SUBSTR ( chat.last_addressed_handle, 4, 3 ) ||
                '-' ||
                SUBSTR ( chat.last_addressed_handle, 7, 4 )
        WHEN chat.last_addressed_handle IS NULL THEN '[N/A]'
        ELSE 'Type ' || chat.last_addressed_handle
    END AS "ChatLastAddressedHandle",

    CASE message.was_data_detected
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE '[Unknown Value : ' || message.was_data_detected || ']'
    END AS "MessageWasDataDetected",

    message.item_type AS "MessageItemType",

    CASE message.is_empty
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE '[Unknown Value : ' || message.is_empty || ']'
    END AS "MessageIsEmpty",

    CASE message.is_archive
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE '[Unknown Value : ' || message.is_archive || ']'
    END AS "MessageIsArchive",

    CASE message.is_finished
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE '[Unknown Value : ' || message.is_finished || ']'
    END AS "MessageIsFinished",

    CASE message.is_audio_message
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE '[Unknown Value : ' || message.is_audio_message || ']'
    END AS "MessageIsAudioMessage",

    CASE message.is_delayed
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE '[Unknown Value : ' || message.is_delayed || ']'
    END AS "MessageIsDelayed",

    CASE message.is_emote
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE '[Unknown Value : ' || message.is_emote || ']'
    END AS "MessageIsEmote",

    message.guid AS "MessageGuid",
    chat.account_id AS "ChatAccountId",
    chat.group_id AS "ChatGroupId",
    chat.guid AS "ChatGuid",

    /* Source for each line of data */
    'sms.db; Table:messages(ROWID:' || message.ROWID || ')' AS "DataSource"


FROM message
    LEFT JOIN message_attachment_join ON message.ROWID = message_attachment_join.message_id
    LEFT JOIN chat_recoverable_message_join ON message.ROWID = chat_recoverable_message_join.message_id
    LEFT JOIN chat_message_join ON message.ROWID = chat_message_join.message_id
    LEFT JOIN attachment ON attachment.ROWID = message_attachment_join.attachment_id
    LEFT JOIN chat ON chat_message_join.chat_id = chat.ROWID
    LEFT JOIN handle ON message.handle_id = handle.ROWID


ORDER BY
    message.date ASC,
    message.ROWID
