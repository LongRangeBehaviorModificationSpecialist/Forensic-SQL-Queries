/*
[DLU]
    13-Nov-2026
[DATABASE PATH]
    \data\data\com.zhiliaoapp.musically\databases
[OS VERSION]
    Android 17 (CP3A.260905.009)
*/

SELECT

    ROW_NUMBER() OVER ( ORDER BY  ) AS "RowNumber",

    msg.msg_uuid AS 'MsgUuid',
    msg.sender AS 'MsgSender',

    CASE
        WHEN msg.type IS '1' THEN 'SystemMsg'
        ELSE msg.type
    END AS 'MsgType',

    msg.status AS 'MsgStatus',
    msg.conversation_id AS 'ConversationId',
    msg.conversation_short_id AS 'ConversationShortId',
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
        ELSE 'N/A'
    END AS 'MsgLocalInfoSendTime',

    -- Change the `msg.sender` value below to the account number obtained from
    -- the device being examined.
    CASE
        WHEN msg.sender = '7455782601761915946' THEN 'Outgoing'
        ELSE 'Incoming'
    END AS 'MsgDirection',

    CASE
        WHEN json_valid(msg.content) AND json_extract(msg.content, '$.text') IS NOT NULL
            THEN json_extract(msg.content, '$.text')
        ELSE NULL
    END AS 'MsgContentText',




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
            THEN json_extract(msg.local_info, '$.aweme_id')
        ELSE NULL
    END AS 'MsgLocalInfoAwemeId',

    msg.scene AS 'MsgScene',

    CASE msg.read_status
        WHEN '0' THEN 'MsgNotRead [0]'
        WHEN '1' THEN 'MsgRead [1]'
    END AS 'MsgReadStatus',

    /* Source for each line of data */
    'File: \data\data\com.zhiliaoapp.musically\databases\7455782601761915946_im.db; Table: msg(_id: ' || msg.msg_uuid || ')' AS "DataSource"

FROM msg

-- WHERE msg.conversation_id IS "0:1:7249187668470367275:7455782601761915946"

WHERE ConversationShortId LIKE '7686356697166102798'
    OR ConversationShortId LIKE '7693212976790389005'
    OR ConversationShortId LIKE '7692959579902558478'
    OR ConversationShortId LIKE '7692992533756100877'
    OR ConversationShortId LIKE '7679578707534692621'
    OR ConversationShortId LIKE '7693668418369356046'
    OR ConversationShortId LIKE '7685611144941912333'
    OR ConversationShortId LIKE '7687819583252267278'
    OR ConversationShortId LIKE '7668894495362957598'
    OR ConversationShortId LIKE '7687120089841598733'
    OR ConversationShortId LIKE '7688224863192744206'
    OR ConversationShortId LIKE '7693052634521501966'
    OR ConversationShortId LIKE '7671824177183899917'
    OR ConversationShortId LIKE '7677716524144214286'
    OR ConversationShortId LIKE '7692672122037256478'
    OR ConversationShortId LIKE '7690301365402304782'
    OR ConversationShortId LIKE '7638962582019948814'
    OR ConversationShortId LIKE '7690816969650602253'
    OR ConversationShortId LIKE '7688213347414180110'
    OR ConversationShortId LIKE '7690829576280654093'
    OR ConversationShortId LIKE '7687476211626885389'
    OR ConversationShortId LIKE '7689161863464550670'
    OR ConversationShortId LIKE '7684867617614266637'
    OR ConversationShortId LIKE '7687494331946533134'
    OR ConversationShortId LIKE '7692850268635627789'

ORDER BY msg.created_time ASC;

-- msg.conversation_id ASC,
