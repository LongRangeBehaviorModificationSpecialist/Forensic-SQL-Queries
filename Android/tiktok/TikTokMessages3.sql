/*
[DLU]
    13-Nov-2026
[DATABASE PATH]
    \data\data\com.zhiliaoapp.musically\databases
[CHANGES]
    Merged JOIN to `attchment` (attchment.uuid = msg.msg_uuid).
    Attachment metadata (local_uri, remote_uri, mime_type, size, media_type)
    is aggregated per message so the output stays one row per message.
    `AttachmentUrl` now prefers the clean `attchment.remote_uri` value and
    falls back to the blob-carved URL only when no attachment row exists.
*/


WITH ParsedMessages AS (

    SELECT

        ROW_NUMBER() OVER() AS 'RowNumber',

        msg.msg_uuid AS 'MsgUuid',
        CAST( msg.sender AS TEXT ) AS 'MsgSender',

        CASE msg.type
            WHEN '1' THEN 'SystemMsg [1]'
            WHEN '7' THEN 'TextMsg [7]'
            WHEN '1802' THEN 'PrivateImage [1802]'
            WHEN '1803' THEN 'PrivateVideo [1803]'
            WHEN '1805' THEN 'Sticker/VideoSticker [1805]'
            WHEN '1809' THEN 'SharedVideo/Photo [1809]'
            WHEN '1813' THEN 'Voice [1813]'
            WHEN '1817' THEN 'ShareRepost [1817]'
            WHEN '1823' THEN 'VoipCallLog [1823]'
            ELSE msg.type
        END AS 'MsgType',

        CASE msg.status
            WHEN '2' THEN 'Sent [2]'
            WHEN '3' THEN 'FailedToSend? [3]'
            WHEN '5' THEN 'Received [5]'
            ELSE msg.status
        END AS 'MsgStatus',

        CASE msg.deleted
            WHEN 0 THEN 'No [0]'
            WHEN 1 THEN 'MessageDeleted [1]'
            ELSE msg.deleted
        END AS 'MsgDeleted',

        CASE msg.is_pinned
            WHEN '0' THEN 'No [0]'
            WHEN '1' THEN 'MessagePinned [1]'
            WHEN NULL THEN NULL
            ELSE msg.is_pinned
        END AS 'MsgIsPinned',

        CAST( msg.conversation_id AS TEXT ) AS 'ConversationId',
        CAST( msg.conversation_short_id AS TEXT ) AS 'ConversationShortId',
        msg.conversation_type AS 'ConversationType',

        -- Unix milliseconds (Java Time)
        datetime( msg.created_time / 1000, 'unixepoch' ) AS 'CreatedTimeUtc',

        CASE
            WHEN json_valid( msg.local_info ) = 1
                AND json_extract( msg.local_info, '$.send_time' ) IS NOT NULL THEN
                CASE
                    WHEN CAST( json_extract( msg.local_info, '$.send_time' ) AS INTEGER ) = 0 THEN 'Zero'
                    ELSE datetime( CAST( json_extract( msg.local_info, '$.send_time' ) AS REAL ) / 1000.0, 'unixepoch' )
                END
            ELSE 'n/a'
        END AS 'MsgLocalInfoSendTime',

        -- Change the `msg.sender` value below to the account number obtained from
        -- the device being examined.
        CASE msg.sender
            WHEN '7455782601761915946' THEN 'Outgoing'
            ELSE 'Incoming'
        END AS 'MsgDirection',

        -- Extracted once here so the outer query can split it cleanly
        CASE
            WHEN json_valid( msg.content ) AND json_extract( msg.content, '$.text' ) IS NOT NULL
                THEN json_extract( msg.content, '$.text' )
            ELSE NULL
        END AS 'MsgContentText',

        -- Parse Attachment URL based on msg.scene / msg.status
        -- (kept as a FALLBACK: the attchment table's remote_uri is preferred;
        --  this carve only fires when no attachment row matched the message)
        CASE
            -- 1. private_image: Carve from fixed offset 0x47 (byte 72) through 0x253344 ('%3D')
            WHEN msg.scene = 'private_image'
                AND length( msg.content_pb ) > 72
                AND instr( substr( msg.content_pb, 72 ), x'253344' ) > 0
                THEN CAST(
                    substr(
                        msg.content_pb, 72, instr( substr( msg.content_pb, 72 ), x'253344' ) + 2
                    ) AS TEXT
                )

            -- 2. private_video: Locate '{"status"' (0x7B2273746174757322) through '"}]}' and extract video_list[0].main_url
            WHEN msg.scene = 'private_video'
                AND instr( msg.content_pb, x'7B2273746174757322' ) > 0
                THEN (
                    WITH VideoJsonSlice AS (
                        SELECT CAST(
                            substr( msg.content_pb, instr( msg.content_pb, x'7B2273746174757322' ) ) AS TEXT
                        ) AS tail
                    )
                    SELECT
                        CASE
                            WHEN instr( tail, '"}]}' ) > 0
                                AND json_valid( substr( tail, 1, instr( tail, '"}]}' ) + 3 ) ) = 1
                                THEN json_extract(
                                    substr( tail, 1, instr( tail, '"}]}' ) + 3 ),
                                    '$.video_list[0].main_url'
                                )

                            WHEN instr( tail, '}]}' ) > 0
                                AND json_valid( substr( tail, 1, instr( tail, '}]}' ) + 2 ) ) = 1
                                THEN json_extract(
                                    substr( tail, 1, instr( tail, '}]}' ) + 2 ),
                                    '$.video_list[0].main_url'
                                )

                            WHEN instr( tail, '"main_url":"' ) > 0
                                THEN substr(
                                    substr( tail, instr( tail, '"main_url":"' ) + 1 ),
                                    1,
                                    instr( substr( tail, instr( tail, '"main_url":"' ) + 12 ), '"' ) - 1
                                )
                            ELSE NULL
                        END
                    FROM VideoJsonSlice
                )

            -- 3. share_video: Carve dynamically from 'https://' (0x68747470733A2F2F) through '%3D' (0x253344)
            -- NOTE: parentheses added around the OR so the instr() guards apply to BOTH scenes
            WHEN ( msg.scene = 'share_video' OR msg.scene = 'share_video_photo' )
                AND instr( msg.content_pb, x'68747470733A2F2F' ) > 0
                AND instr( substr( msg.content_pb, instr( msg.content_pb, x'68747470733A2F2F' ) ), x'253344' ) > 0
                THEN CAST(
                    substr( msg.content_pb,
                        instr( msg.content_pb, x'68747470733A2F2F' ),
                        instr( substr( msg.content_pb, instr( msg.content_pb, x'68747470733A2F2F' ) ), x'253344' ) + 2
                    ) AS TEXT
                )

            ELSE NULL
        END AS 'RawBlobUrl',

        msg.scene AS 'MsgScene',

        CASE
            WHEN json_valid( msg.content ) AND json_extract( msg.content, '$.aweType' ) IS NOT NULL
                THEN json_extract( msg.content, '$.aweType' )
            ELSE NULL
        END AS 'MsgContentAweType',

        -- Unix microseconds timestamp
        datetime( msg.prev_index / 1000000.0, 'unixepoch' ) AS 'MsgPrevIndex',

        -- Unix seconds timestamp
        CASE msg.ttl
            WHEN '0' THEN NULL
            ELSE datetime( msg.ttl, 'unixepoch' )
        END AS 'MsgTtl',

        CASE
            WHEN json_valid( msg.local_info ) AND json_extract( msg.local_info, '$.aweme_id' ) IS NOT NULL
                THEN CAST( json_extract( msg.local_info, '$.aweme_id' ) AS TEXT )
            ELSE NULL
        END AS 'MsgLocalInfoAwemeId',

        CASE msg.read_status
            WHEN '0' THEN 'MsgNotRead [0]'
            WHEN '1' THEN 'MsgRead [1]'
        END AS 'MsgReadStatus',

        /* Source for each line of data */
        'File: \data\data\com.zhiliaoapp.musically\databases\7455782601761915946_im.db; Table:msg(_id: ' || msg.msg_uuid || ')' AS 'DataSource'

    FROM msg

    -- WHERE msg.conversation_short_id IN (
    --     '7668924098387755278',
    --     '7644276119398646797'
    -- )

    ORDER BY msg.created_time ASC
),

-- NEW: attachments rolled up per message (attchment.uuid = msg.msg_uuid).
-- Aggregated because attchment has no primary key and can hold more than one
-- row per message; grouping keeps the final output at one row per message.
MsgAttachments AS (
    SELECT
        d.uuid,
        COUNT( * )                              AS 'AttachmentCount',
        GROUP_CONCAT( d.local_uri, char(10) )   AS 'AttachmentLocalUris',
        GROUP_CONCAT( d.remote_uri, char(10) )  AS 'AttachmentRemoteUris',
        GROUP_CONCAT( d.mime_type, ', ' )       AS 'AttachmentMimeTypes',
        GROUP_CONCAT( d.media_type, ',' )       AS 'AttachmentMediaTypes',
        SUM( d.size )                           AS 'AttachmentTotalBytes'
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
        WHEN pm.MsgDirection = 'Incoming' THEN COALESCE( pm.MsgContentText, '' )
        ELSE NULL
    END AS 'IncomingMsg',

    CASE
        WHEN pm.MsgDirection = 'Outgoing' THEN COALESCE( pm.MsgContentText, '' )
        ELSE NULL
    END AS 'OutgoingMsg',

    -- Attachment URL: prefer the clean value recorded in the attchment table;
    -- fall back to decoding the carved blob URL when no attachment row exists.
    CASE
        WHEN ma.AttachmentRemoteUris IS NOT NULL THEN ma.AttachmentRemoteUris
        WHEN pm.RawBlobUrl IS NOT NULL THEN
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE( pm.RawBlobUrl, '%3D', '=' ),
                        '%3D', '='),
                    '%2F', '/'),
                '%2B', '+'),
            '%26', '&')
        ELSE ''
    END AS 'AttachmentUrl',

    -- NEW: attachment metadata columns from the attchment table
    ma.AttachmentCount,
    ma.AttachmentLocalUris   AS 'AttachmentLocalUri',
    ma.AttachmentMimeTypes   AS 'AttachmentMimeType',
    ma.AttachmentTotalBytes  AS 'AttachmentSizeBytes',
    ma.AttachmentMediaTypes  AS 'AttachmentMediaType',

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
