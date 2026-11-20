/*
[DLU]
    20-Nov-2026
[DATABASE]
    /private/var/mobile/Library/SMS/sms.db
    /private/var/mobile/Library/AddressBook/AddressBook.sqlitedb
[NOTES]
    Tested on iOS 18
*/


SELECT

    ROW_NUMBER() OVER ( ORDER BY message.date ) AS RowNumber,

    message.ROWID AS MessageRowId,
    message.guid AS MessageGuid,
    message.handle_id AS MessageHandleId,
    chat_message_join.message_id AS ChatMessageJoinMessageId,
    message.account AS MessageAccount,
    chat.ROWID AS ChatRowId,
    chat.guid AS ChatGuid,
    message.service AS MessageService,

    CASE
        WHEN LENGTH ( message.date ) = 18
            THEN strftime ( '%F_%H:%M:%f', ( message.date / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( message.date ) = 9
            THEN strftime ( '%F_%H:%M:%f', message.date + 978307200, 'unixepoch' )
        ELSE 'RawData: [' || message.date || ']'
    END AS MessageDateUtc,

    CASE
        WHEN LENGTH ( message.date_delivered ) = 18
            THEN strftime ( '%F_%H:%M:%f', ( message.date_delivered / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( message.date_delivered ) = 9
            THEN strftime ( '%F_%H:%M:%f', message.date_delivered + 978307200, 'unixepoch' )
        ELSE 'RawData: [' || message.date_delivered || ']'
    END AS MessageDateDeliveredUtc,

    CASE
        WHEN LENGTH ( message.date_read ) = 18
            THEN strftime ( '%F_%H:%M:%f', ( message.date_read / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( message.date_read ) = 9
            THEN strftime ( '%F_%H:%M:%f', message.date_read + 978307200, 'unixepoch' )
        ELSE 'RawData: [' || message.date_read || ']'
    END AS MessageDateReadUtc,

    CASE
        WHEN LENGTH ( message.date_edited ) = 18
            THEN strftime ( '%F_%H:%M:%f', ( message.date_edited / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( message.date_edited ) = 9
            THEN strftime ( '%F_%H:%M:%f', message.date_edited + 978307200, 'unixepoch' )
        ELSE 'RawData: [' || message.date_edited || ']'
    END AS MessageDateEditedUtc,

    CASE
        WHEN chat_message_join.chat_id = NULL THEN '*DELETED MESSAGE*'
        ELSE 'No'
    END AS WasDeleted,

    CASE message.is_from_me
        WHEN 0 THEN 'Received'
        WHEN 1 THEN 'Sent'
        ELSE 'Type: [' || message.is_from_me || ']'
    END AS MessageIsFromMe,

    CASE message.is_delayed
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.is_delayed || ']'
    END AS MessageIsDelayed,

    CASE message.is_empty
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.is_empty || ']'
    END AS MessageIsEmpty,

    CASE message.is_archive
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.is_archive || ']'
    END AS MessageIsArchive,

    CASE message.is_finished
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.is_finished || ']'
    END AS MessageIsFinished,

    CASE message.is_audio_message
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.is_audio_message || ']'
    END AS MessageIsAudioMessage,

    CASE message.is_played
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.is_played || ']'
    END AS MessageIsPlayed,

    CASE
        WHEN LENGTH ( message.date_played ) = 18
            THEN strftime ( '%F_%H:%M:%f', ( message.date_played / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( message.date_played ) = 9
            THEN strftime ( '%F_%H:%M:%f', message.date_played + 978307200, 'unixepoch' )
        ELSE 'RawData: [' || message.date_played || ']'
    END AS MessageDatePlayedUtc,

    CASE message.is_emote
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.is_emote || ']'
    END AS MessageIsEmote,

    CASE message.is_forward
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.is_forward || ']'
    END AS MessageIsForward,

    CASE message.is_auto_reply
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.is_auto_reply || ']'
    END AS MessageIsAutoReply,

    CASE message.is_system_message
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.is_system_message || ']'
    END AS MessageIsSystemMessage,

    CASE message.is_service_message
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.is_service_message || ']'
    END AS MessageIsServiceMessage,

    CASE message.is_spam
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.is_spam || ']'
    END AS MessageIsSpam,

    CASE message.was_data_detected
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.was_data_detected || ']'
    END AS MessageWasDataDetected,

    CASE message.ck_sync_state
        WHEN 0 THEN 'Not Synced'
        WHEN 1 THEN 'Synced'
        ELSE 'Type: [' || message.ck_sync_state || ']'
    END AS MessageCkSyncState,

    CASE
        WHEN LENGTH ( handle.id ) = 14 AND handle.id LIKE '%p:+1%'
            THEN '(' ||
            SUBSTR ( handle.id, 5, 3 ) || ') ' ||
            SUBSTR ( handle.id, 8, 3 ) || '-' ||
            SUBSTR ( handle.id, 11, 4 )
        WHEN LENGTH ( handle.id ) = 12 AND handle.id LIKE '+1%'
            THEN '(' ||
            SUBSTR ( handle.id, 3, 3 ) || ') ' ||
            SUBSTR ( handle.id, 6, 3 ) || '-' ||
            SUBSTR ( handle.id, 9, 4 )
        WHEN LENGTH ( handle.id ) = 11 AND handle.id LIKE '1%'
            THEN '(' ||
            SUBSTR ( handle.id, 2, 3 ) || ') ' ||
            SUBSTR ( handle.id, 5, 3 ) || '-' ||
            SUBSTR ( handle.id, 8, 4 )
        WHEN LENGTH ( handle.id ) = 10
            THEN '(' ||
            SUBSTR ( handle.id, 1, 3 ) || ') ' ||
            SUBSTR ( handle.id, 4, 3 ) || '-' ||
            SUBSTR ( handle.id, 7, 4 )
        ELSE handle.id
    END AS HandleId,

    CASE chat.style
        WHEN 43 THEN 'GroupChat'
        WHEN 45 THEN 'P2P'
        ELSE 'Type: [' || chat.style || ']'
    END AS ChatStyle,

    chat_message_join.chat_id AS ChatMessageJoinChatId,

    CASE message.item_type
        WHEN 0 THEN 'Message'
        WHEN 1 THEN 'GroupParticipantAdded'
        WHEN 2 THEN 'GroupRenamed'
        WHEN 3 THEN 'GroupActionType-0=Participant_Leaves/GroupActionType-1=GroupPhotoChanged-3'
        WHEN 4 THEN 'LocationSharingData'
        WHEN 5 THEN 'Unknown'
        WHEN 6 THEN 'Unknown'
        ELSE 'Type: [' || message.item_type || ']'
    END AS MessageItemType,

    message.subject AS MessageSubject,
    message.text AS MessageText,
    message.reply_to_guid AS MessageReplyToGuid,

    SUBSTR ( message.associated_message_guid, 5, 36 ) AS MessageAssociatedMessageGuid,

    CASE message.associated_message_type
        WHEN 0 THEN 'Unknown Value'
        WHEN 2 THEN 'Apple Payment Sent'
        WHEN 3 THEN 'Apple Payment Requested'
        WHEN 2000 THEN 'LOVED Reaction'
        WHEN 2001 THEN 'LIKED Reaction'
        WHEN 2002 THEN 'DISLIKED Reaction'
        WHEN 2003 THEN 'LAUGHED Reaction'
        WHEN 2004 THEN 'EMPHASIZED Reaction'
        WHEN 2005 THEN 'QUESTIONED Reaction'
        WHEN 3000 THEN 'Removed LOVED Reaction'
        WHEN 3001 THEN 'Removed LIKE Reaction'
        WHEN 3002 THEN 'Removed DISLIKE Reaction'
        WHEN 3003 THEN 'Removed LAUGH Reaction'
        WHEN 3004 THEN 'Removed EXCLAMATION Reaction'
        WHEN 3005 THEN 'Removed QUESTION Reaction'
        ELSE 'Type: [' || message.associated_message_type || ']'
    END AS MessageAssociatedMessageType,

    message.balloon_bundle_id AS MessageBalloonBundleId,

    CASE message.was_delivered_quietly
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.was_delivered_quietly
    END AS WasDeliveredQuietly,

    CASE message.expressive_send_style_id
        WHEN 'comessage.apple.messages.effect.CKSpotlightEffect' THEN 'SpotlightEffect'
        WHEN 'comessage.apple.messages.effect.CKSparklesEffect' THEN 'SparklesEffect'
        WHEN 'comessage.apple.messages.effect.CKLasersEffect' THEN 'LaserEffect'
        WHEN 'comessage.apple.messages.effect.CKHeartEffect' THEN 'HeartEffect'
        WHEN 'comessage.apple.messages.effect.CKHappyBirthdayEffect' THEN 'HappyBirthdayEffect'
        WHEN 'comessage.apple.messages.effect.CKFireworksEffect' THEN 'FireworksEffect'
        WHEN 'comessage.apple.messages.effect.CKEchoEffect' THEN 'EchoEffect'
        WHEN 'comessage.apple.messages.effect.CKConfettiEffect' THEN 'ConfettiEffect'
        WHEN 'comessage.apple.MobileSMS.expressivesend.loud' THEN 'SMSExpressiveSendLoud'
        WHEN 'comessage.apple.MobileSMS.expressivesend.invisibleink' THEN 'SMSExpressiveSendInvisibleInk'
        WHEN 'comessage.apple.MobileSMS.expressivesend.impact' THEN 'SMSExpressiveSendImpact'
        WHEN 'comessage.apple.MobileSMS.expressivesend.gentle' THEN 'SMSExpressiveSendGentle'
        ELSE 'Type: [' || message.expressive_send_style_id || ']'
    END AS MessageExpressiveSendStyleId,

    CASE message.is_read
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || message.is_read || ']'
    END AS MessageIsRead,

    CASE message.share_status
        WHEN 0 THEN 'Not Shared'
        WHEN 1 THEN 'Shared'
        ELSE 'Type: [' || message.share_status || ']'
    END AS MessageShareStatus,

    CASE message.share_direction
        WHEN 0 THEN 'Received'
        WHEN 1 THEN 'Sent'
        ELSE 'Type: [' || message.share_direction || ']'
    END AS MessageShareDirection,

    chat.display_name AS ChatDisplayName,

    CASE attachment.is_outgoing
        WHEN 0 THEN 'Incoming'
        WHEN 1 THEN 'Outgoing'
        ELSE 'Type: [' || attachment.is_outgoing || ']'
    END AS AttachmentIsOutgoing,

    message_attachment_join.attachment_id AS MessageAttachmentJoinAttachmentId,
    attachment.filename AS AttachmentFileName,
    attachment.transfer_name AS AttachmentTransferName,

    CASE
        WHEN attachment.total_bytes > 0
            THEN printf ( '%,d', attachment.total_bytes )
        ELSE 'Type: [' || attachment.total_bytes || ']'
    END AS AttachmentTotalBytes,

    attachment.mime_type AS AttachmentMimeType,
    attachment.uti AS AttachmentUti,

    -- Date the attachment was created
    CASE
        WHEN LENGTH ( attachment.created_date ) = 18
            THEN strftime ( '%F_%H:%M:%f', ( attachment.created_date / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( attachment.created_date ) = 9
            THEN strftime ( '%F_%H:%M:%f', attachment.created_date + 978307200, 'unixepoch' )
        ELSE 'RawData: [' || attachment.created_date || ']'
    END AS AttachmentCreatedDateUtc,

    -- Source for each line of data
    'sms.db; Table:messages(ROWID:' || message.ROWID || ')' AS DataSource


FROM message
    LEFT JOIN message_attachment_join ON message.ROWID = message_attachment_join.message_id
    --LEFT JOIN attachment ON message_attachment_join.attachment_id = attachment.ROWID
    LEFT JOIN attachment ON attachment.ROWID = message_attachment_join.attachment_id
    LEFT JOIN chat_message_join ON message.ROWID = chat_message_join.message_id
    LEFT JOIN chat ON chat_message_join.chat_id = chat.ROWID
    LEFT JOIN handle ON message.handle_id = handle.ROWID


-- WHERE
--     message.associated_message_type != 0
    -- message.expressive_send_style_id != NULL

    /*
    To filter between date/time points
    Between 10-11-2024 00:00:00 ET and 10-12-2024 at 14:06:00 ET
    */
    -- message.date BETWEEN 750312000000000000 AND 750449160000000000

    /*
    When `chat_message_join.chat_id` is NULL, that means that the message was deleted,
    but there is still a record of the message in the message table.
    It is likely that the vacuum functions has not run to delete the message from the table
    */
    --chat_message_join.chat_id IS NULL


ORDER BY
    message.date ASC
