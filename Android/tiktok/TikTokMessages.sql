/*
[DLU]
    20-Nov-2026
[DATABASE]
    \data\data\com.zhiliaoapp.musically\databases\<TikTokUserIdNumber>_im.db
[NOTES]
    The <TikTokUserIdNumber> is the 19-digit account number

    Merged JOIN to 'attchment' (attchment.uuid = msg.msg_uuid).
    Attachment metadata (local_uri, remote_uri, mime_type, size, media_type)
    is aggregated per message so the output stays one row per message.
    'AttachmentUrl' now prefers the clean 'attchment.remote_uri' value and
    falls back to the blob-carved URL only when no attachment row exists.
*/


WITH ParsedMessages AS (

    SELECT

        ROW_NUMBER() OVER( ORDER BY msg.created_time ) AS RowNumber,

        msg.msg_uuid AS MsgUuid,
        CAST ( msg.sender AS TEXT ) AS MsgSender,

        CASE msg.type
            WHEN 1 THEN 'SystemMsg'
            WHEN 7 THEN 'TextMsg'
            WHEN 1802 THEN 'PrivateImage'
            WHEN 1803 THEN 'PrivateVideo'
            WHEN 1805 THEN 'Sticker/VideoSticker'
            WHEN 1809 THEN 'SharedVideo/Photo'
            WHEN 1813 THEN 'Voice'
            WHEN 1817 THEN 'ShareRepost'
            WHEN 1823 THEN 'VoipCallLog'
            ELSE 'Type: [' || msg.type || ']'
        END AS MsgType,

        CASE msg.status
            WHEN 2 THEN 'Sent'
            WHEN 3 THEN 'FailedToSend?'
            WHEN 5 THEN 'Received'
            ELSE 'Type: [' || msg.status || ']'
        END AS MsgStatus,

        CASE msg.deleted
            WHEN 0 THEN 'No'
            WHEN 1 THEN 'Yes'
            ELSE 'Type: [' || msg.deleted || ']'
        END AS MsgDeleted,

        CASE msg.is_pinned
            WHEN 0 THEN 'No'
            WHEN 1 THEN 'Yes'
            ELSE 'Type: [' || msg.is_pinned || ']'
        END AS MsgIsPinned,

        CAST ( msg.conversation_id AS TEXT ) AS ConversationId,
        CAST ( msg.conversation_short_id AS TEXT ) AS ConversationShortId,
        msg.conversation_type AS ConversationType,

        -- Unix milliseconds (Java Time)
        strftime ( '%F_%H:%M:%f', msg.created_time / 1000.0, 'unixepoch' ) AS CreatedTimeUtc,

        CASE
            WHEN json_valid ( msg.local_info ) = 1
                AND json_extract ( msg.local_info, '$.send_time' ) IS NOT NULL THEN
                CASE
                    WHEN CAST ( json_extract ( msg.local_info, '$.send_time' ) AS INTEGER ) = 0 THEN 'Zero'
                    ELSE strftime ( '%F_%H:%M:%f', CAST ( json_extract( msg.local_info, '$.send_time' ) AS REAL ) / 1000.0, 'unixepoch' )
                END
            ELSE 'n/a'
        END AS MsgLocalInfoSendTime,

        -- Change the `msg.sender` value below to the account number obtained from
        -- the device being examined.
        CASE msg.sender
            WHEN '7455782601761915946' THEN 'Outgoing'
            ELSE 'Incoming'
        END AS MsgDirection,

        -- Extracted once here so the outer query can split it cleanly
        WHEN json_valid ( msg.content ) AND json_extract ( msg.content, '$.text' ) IS NOT NULL
            THEN json_extract ( msg.content, '$.text' ) AS MsgContentText,

        /*
        Parse Attachment URL based on msg.scene / msg.status
        (kept as a FALLBACK: the attchment table's remote_uri is preferred;
        this carve only fires when no attachment row matched the message)
        */
        CASE
            -- 1. private_image: Carve from fixed offset 0x47 (byte 72) through 0x253344 ('%3D')
            WHEN msg.scene = 'private_image'
                AND LENGTH ( msg.content_pb ) > 72
                AND instr ( substr ( msg.content_pb, 72 ), x'253344' ) > 0
                THEN CAST (
                    substr (
                        msg.content_pb, 72, instr ( substr ( msg.content_pb, 72 ), x'253344' ) + 2
                    ) AS TEXT
                )

            -- 2. private_video: Locate '{status' (0x7B2273746174757322) through '}]}' and extract video_list[0].main_url
            WHEN msg.scene = 'private_video'
                AND instr ( msg.content_pb, x'7B2273746174757322' ) > 0
                THEN (
                    WITH VideoJsonSlice AS (
                        SELECT CAST (
                            substr ( msg.content_pb, instr ( msg.content_pb, x'7B2273746174757322' ) ) AS TEXT
                        ) AS tail
                    )
                    SELECT
                        CASE
                            WHEN instr ( tail, '}]}' ) > 0
                                AND json_valid ( substr ( tail, 1, instr ( tail, '}]}' ) + 3 ) ) = 1
                                THEN json_extract (
                                    substr ( tail, 1, instr ( tail, '}]}' ) + 3 ),
                                    '$.video_list[0].main_url'
                                )

                            WHEN instr ( tail, '}]}' ) > 0
                                AND json_valid ( substr ( tail, 1, instr ( tail, '}]}' ) + 2 ) ) = 1
                                THEN json_extract (
                                    substr ( tail, 1, instr ( tail, '}]}' ) + 2 ),
                                    '$.video_list[0].main_url'
                                )

                            WHEN instr ( tail, 'main_url:' ) > 0
                                THEN substr (
                                    substr ( tail, instr ( tail, 'main_url:' ) + 1 ),
                                    1,
                                    instr ( substr ( tail, instr ( tail, 'main_url:' ) + 12 ), '' ) - 1
                                )
                            ELSE NULL
                        END
                    FROM VideoJsonSlice
                )

            -- 3. share_video: Carve dynamically from 'https://' (0x68747470733A2F2F) through '%3D' (0x253344)
            -- NOTE: parentheses added around the OR so the instr() guards apply to BOTH scenes
            WHEN ( msg.scene = 'share_video' OR msg.scene = 'share_video_photo' )
                AND instr ( msg.content_pb, x'68747470733A2F2F' ) > 0
                AND instr ( substr ( msg.content_pb, instr ( msg.content_pb, x'68747470733A2F2F' ) ), x'253344' ) > 0
                THEN CAST (
                    substr ( msg.content_pb,
                        instr ( msg.content_pb, x'68747470733A2F2F' ),
                        instr ( substr ( msg.content_pb, instr ( msg.content_pb, x'68747470733A2F2F' ) ), x'253344' ) + 2
                    ) AS TEXT
                )

            ELSE NULL
        END AS RawBlobUrl,

        msg.scene AS MsgScene,

        CASE
            WHEN json_valid ( msg.content ) AND json_extract ( msg.content, '$.aweType' ) IS NOT NULL
                THEN json_extract ( msg.content, '$.aweType' )
            ELSE NULL
        END AS MsgContentAweType,

        -- Unix microseconds timestamp
        strftime ( '%F_%H:%M:%f', msg.prev_index / 1000000.0, 'unixepoch' ) AS MsgPrevIndex,

        -- Unix seconds timestamp (no math needed to convert the value)
        strftime ( '%F_%H:%M:%f', msg.ttl, 'unixepoch' ) AS MsgTtl,

        CASE
            WHEN json_valid ( msg.local_info ) AND json_extract ( msg.local_info, '$.aweme_id' ) IS NOT NULL
                THEN CAST ( json_extract ( msg.local_info, '$.aweme_id' ) AS TEXT )
            ELSE NULL
        END AS MsgLocalInfoAwemeId,

        CASE msg.read_status
            WHEN 0 THEN 'MsgNotRead'
            WHEN 1 THEN 'MsgRead'
            ELSE 'Type: [' || msg.read_status || ']'
        END AS MsgReadStatus,

        /* Source for each line of data */
        'File: \data\data\com.zhiliaoapp.musically\databases\7455782601761915946_im.db; Table:msg(_id:' || msg.msg_uuid || ')' AS DataSource


    FROM msg


    ORDER BY msg.created_time ASC
),

/*
NEW: attachments rolled up per message (attchment.uuid = msg.msg_uuid).
Aggregated because attchment has no primary key and can hold more than one
row per message; grouping keeps the final output at one row per message.
*/
MsgAttachments AS (

    SELECT

        d.uuid,
        COUNT ( * )                              AS AttachmentCount,
        GROUP_CONCAT ( d.local_uri, char(10) )   AS AttachmentLocalUris,
        GROUP_CONCAT ( d.remote_uri, char(10) )  AS AttachmentRemoteUris,
        GROUP_CONCAT ( d.mime_type, ', ' )       AS AttachmentMimeTypes,
        GROUP_CONCAT ( d.media_type, ',' )       AS AttachmentMediaTypes,
        SUM ( d.size )                           AS AttachmentTotalBytes


    FROM (
        SELECT DISTINCT
            uuid, local_uri, remote_uri, mime_type, media_type, size
        FROM attchment
    ) d


    GROUP BY d.uuid
)

SELECT

    pm.RowNumber,
    pm.MsgUuid,
    pm.MsgSender,
    pm.MsgType,
    pm.MsgStatus,
    pm.MsgDeleted,
    pm.MsgIsPinned,
    pm.ConversationId,
    pm.ConversationShortId,
    pm.ConversationType,
    pm.CreatedTimeUtc,
    pm.MsgLocalInfoSendTime,
    pm.MsgDirection,

    CASE
        WHEN pm.MsgDirection = 'Incoming' THEN COALESCE ( pm.MsgContentText, '' )
        ELSE NULL
    END AS IncomingMsg,

    CASE
        WHEN pm.MsgDirection = 'Outgoing' THEN COALESCE ( pm.MsgContentText, '' )
        ELSE NULL
    END AS OutgoingMsg,

    /*
    Attachment URL: prefer the clean value recorded in the attchment table;
    fall back to decoding the carved blob URL when no attachment row exists.
    */
    CASE
        WHEN ma.AttachmentRemoteUris IS NOT NULL THEN ma.AttachmentRemoteUris
        WHEN pm.RawBlobUrl IS NOT NULL THEN
            REPLACE (
                REPLACE (
                    REPLACE (
                        REPLACE (
                            REPLACE ( pm.RawBlobUrl, '%3D', '=' ),
                        '%3D', '='),
                    '%2F', '/'),
                '%2B', '+'),
            '%26', '&')
        ELSE ''
    END AS AttachmentUrl,

    -- NEW: attachment metadata columns from the attchment table
    ma.AttachmentCount,
    ma.AttachmentLocalUris   AS AttachmentLocalUri,
    ma.AttachmentMimeTypes   AS AttachmentMimeType,
    ma.AttachmentTotalBytes  AS AttachmentSizeBytes,
    ma.AttachmentMediaTypes  AS AttachmentMediaType,

    pm.MsgContentAweType,
    pm.MsgPrevIndex,
    pm.MsgTtl,
    pm.MsgLocalInfoAwemeId,
    pm.MsgScene,
    pm.MsgReadStatus,
    pm.DataSource


FROM ParsedMessages pm


LEFT JOIN MsgAttachments ma ON ma.uuid = pm.MsgUuid


ORDER BY pm.RowNumber;
