/*
[DLU]
    13-Nov-2026
[DATABASE PATH]
    \data\data\com.zhiliaoapp.musically\databases
[OS VERSION]
    Android 17 (CP3A.260905.009)
*/


WITH ParsedMessages AS (
    SELECT
        ROW_NUMBER() OVER() AS 'RowNumber',

        msg.msg_uuid AS 'MsgUuid',
        CAST(msg.sender AS TEXT) AS 'MsgSender',

        CASE
            WHEN msg.type IS '1' THEN 'SystemMsg [1]'
            WHEN msg.type IS '7' THEN 'TextMsg [7]'
            WHEN msg.type IS '1802' THEN 'PrivateImage [1802]'
            WHEN msg.type IS '1803' THEN 'PrivateVideo [1803]'
            WHEN msg.type IS '1805' THEN 'Sticker/VideoSticker [1805]'
            WHEN msg.type IS '1809' THEN 'SharedVideo/Photo [1809]'
            WHEN msg.type IS '1813' THEN 'Voice [1813]'
            WHEN msg.type IS '1817' THEN 'ShareRepost [1817]'
            WHEN msg.type IS '1823' THEN 'VoipCallLog [1823]'
            ELSE msg.type
        END AS 'MsgType',

        CASE msg.status
            WHEN '2' THEN 'Sent [2]'
            WHEN '3' THEN 'FailedToSend? [3]'
            WHEN '5' THEN 'Received [5]'
            ELSE msg.status
        END AS 'MsgStatus',

        CASE
            WHEN msg.deleted IS '0' THEN 'No [0]'
            WHEN msg.deleted IS '1' THEN 'MessageDeleted [1]'
            ELSE msg.deleted
        END AS "MsgDeleted",

        CASE
            WHEN msg.is_pinned IS '0' THEN 'No [0]'
            WHEN msg.is_pinned IS '1' THEN 'MessagePinned [1]'
            WHEN msg.is_pinned IS NULL THEN NULL
            ELSE msg.is_pinned
        END AS "MsgIsPinned",

        CAST(msg.conversation_id AS TEXT) AS 'ConversationId',
        CAST(msg.conversation_short_id AS TEXT) AS 'ConversationShortId',
        msg.conversation_type AS 'ConversationType',

        -- Unix milliseconds (Java Time)
        datetime(msg.created_time / 1000, 'unixepoch') AS 'CreatedTimeUtc',

        CASE
            WHEN json_valid(msg.local_info) = 1
                AND json_extract(msg.local_info, '$.send_time') IS NOT NULL THEN
                CASE
                    WHEN CAST(json_extract(msg.local_info, '$.send_time') AS INTEGER) = 0 THEN 'Zero'
                    ELSE datetime(CAST(json_extract(msg.local_info, '$.send_time') AS REAL) / 1000.0, 'unixepoch')
                END
            ELSE 'n/a'
        END AS 'MsgLocalInfoSendTime',

        -- Change the `msg.sender` value below to the account number obtained from
        -- the device being examined.
        CASE
            WHEN msg.sender = '7455782601761915946' THEN 'Outgoing'
            ELSE 'Incoming'
        END AS 'MsgDirection',

        -- Extracted once here so the outer query can split it cleanly
        CASE
            WHEN json_valid(msg.content) AND json_extract(msg.content, '$.text') IS NOT NULL
                THEN json_extract(msg.content, '$.text')
            ELSE NULL
        END AS 'MsgContentText',

        -- Parse Attachment URL based on msg.scene / msg.status
        -- Replace 'your_blob_column' below with the actual BLOB column name (e.g., msg.content_pb or msg.ext)
        CASE
            -- 1. private_image: Carve from fixed offset 0x47 (byte 72) through 0x253344 ('%3D')
            WHEN msg.scene = 'private_image'
                AND length(msg.content_pb) > 72
                AND instr(substr(msg.content_pb, 72), x'253344') > 0
                THEN CAST(
                    substr(
                        msg.content_pb,
                        72,
                        instr(substr(msg.content_pb, 72), x'253344') + 2
                    ) AS TEXT
                )

            -- 2. private_video: Locate '{"status"' (0x7B2273746174757322) through '"}]}' and extract video_list[0].main_url
            WHEN msg.scene = 'private_video'
                AND instr(msg.content_pb, x'7B2273746174757322') > 0
                THEN (
                    WITH VideoJsonSlice AS (
                        SELECT CAST(
                            substr(
                                msg.content_pb,
                                instr(msg.content_pb, x'7B2273746174757322')
                            ) AS TEXT
                        ) AS tail
                    )
                    SELECT
                        CASE
                            WHEN instr(tail, '"}]}') > 0
                                AND json_valid(substr(tail, 1, instr(tail, '"}]}') + 3)) = 1
                                THEN json_extract(substr(tail, 1, instr(tail, '"}]}') + 3), '$.video_list[0].main_url')

                            WHEN instr(tail, '}]}') > 0
                                AND json_valid(substr(tail, 1, instr(tail, '}]}') + 2)) = 1
                                THEN json_extract(substr(tail, 1, instr(tail, '}]}') + 2), '$.video_list[0].main_url')

                            WHEN instr(tail, '"main_url":"') > 0
                                THEN substr(
                                    substr(tail, instr(tail, '"main_url":"') + 12),
                                    1,
                                    instr(substr(tail, instr(tail, '"main_url":"') + 12), '"') - 1
                                )
                            ELSE NULL
                        END
                    FROM VideoJsonSlice
                )

            -- 3. share_video: Carve dynamically from 'https://' (0x68747470733A2F2F) through '%3D' (0x253344)
            -- (Change msg.status to msg.scene if 'share_video' is stored in the scene column)
            WHEN msg.scene = 'share_video' OR msg.scene = 'share_video_photo'
                AND instr(msg.content_pb, x'68747470733A2F2F') > 0
                AND instr(
                    substr(msg.content_pb, instr(msg.content_pb, x'68747470733A2F2F')),
                    x'253344'
                ) > 0
                THEN CAST(
                    substr(
                        msg.content_pb,
                        instr(msg.content_pb, x'68747470733A2F2F'),
                        instr(
                            substr(msg.content_pb, instr(msg.content_pb, x'68747470733A2F2F')),
                            x'253344'
                        ) + 2
                    ) AS TEXT
                )

            ELSE NULL
        END AS 'RawBlobUrl',

        msg.scene AS 'MsgScene',

        CASE
            WHEN json_valid(msg.content) AND json_extract(msg.content, '$.aweType') IS NOT NULL
                THEN json_extract(msg.content, '$.aweType')
            ELSE NULL
        END AS 'MsgContentAweType',

        -- Unix microseconds timestamp
        datetime(msg.prev_index / 1000000.0, 'unixepoch') AS 'MsgPrevIndex',

        -- Unix seconds timestamp
        CASE
            WHEN msg.ttl IS '0' THEN NULL
            ELSE datetime(msg.ttl, 'unixepoch')
        END AS 'MsgTtl',

        CASE
            WHEN json_valid(msg.local_info) AND json_extract(msg.local_info, '$.aweme_id') IS NOT NULL
                THEN CAST(json_extract(msg.local_info, '$.aweme_id') AS TEXT)
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
    --     '7686356697166102798',
    --     '7693212976790389005',
    --     '7692959579902558478',
    --     '7692992533756100877',
    --     '7679578707534692621',
    --     '7693668418369356046',
    --     '7685611144941912333',
    --     '7687819583252267278',
    --     '7668894495362957598',
    --     '7687120089841598733',
    --     '7688224863192744206',
    --     '7693052634521501966',
    --     '7671824177183899917',
    --     '7677716524144214286',
    --     '7692672122037256478',
    --     '7690301365402304782',
    --     '7638962582019948814',
    --     '7690816969650602253',
    --     '7688213347414180110',
    --     '7690829576280654093',
    --     '7687476211626885389',
    --     '7689161863464550670',
    --     '7684867617614266637',
    --     '7687494331946533134',
    --     '7692850268635627789'
    -- )
    -- AND msg.scene = 'private_image' OR msg.scene = 'private_video'

    WHERE msg.scene = 'private_image' OR msg.scene = 'private_video' OR msg.scene = 'share_video' OR msg.scene = 'share_video_photo'

    ORDER BY msg.created_time ASC
)

SELECT
    RowNumber,
    MsgUuid,
    MsgSender,
    MsgType,
    MsgStatus,
    ConversationId,
    ConversationShortId,
    ConversationType,
    CreatedTimeUtc,
    MsgLocalInfoSendTime,
    MsgDirection,

    CASE
        WHEN MsgDirection = 'Incoming' THEN COALESCE(MsgContentText, '')
        ELSE ''
    END AS 'IncomingMsg',

    CASE
        WHEN MsgDirection = 'Outgoing' THEN COALESCE(MsgContentText, '')
        ELSE ''
    END AS 'OutgoingMsg',

    -- Decode percent-encoded characters from the carved URL
    CASE
        WHEN RawBlobUrl IS NOT NULL THEN
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(RawBlobUrl, '%3D', '='),
                        '%3D', '='),
                    '%2F', '/'),
                '%2B', '+'),
            '%26', '&')
        ELSE ''
    END AS 'AttachmentUrl',

    MsgContentAweType,
    MsgPrevIndex,
    MsgTtl,
    MsgLocalInfoAwemeId,
    MsgScene,
    MsgReadStatus,
    DataSource

FROM ParsedMessages;
