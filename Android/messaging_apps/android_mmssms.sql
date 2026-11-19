/*
[DLU]
    19-Nov-2026
*/


------------------------------------------------------
/*
This query is for MMS messages from the mmssms.db
*/
------------------------------------------------------


SELECT
    /* Add a row number at the beggining of each row */
    ROW_NUMBER() OVER ( ORDER BY pdu.date ) AS "RowNumber",

    pdu._id AS "PduId",
    pdu.thread_id AS "PduThreadId",

    /* Date/Time of the message in UTC */
    CASE
        WHEN pdu.date > 0 THEN strftime( '%F_%H:%M:%f', pdu.date, 'unixepoch' )
        ELSE '[N/A]'
    END AS "PduDate",

    /* Date/Time the message was sent in UTC */
    CASE
        WHEN pdu.date_sent > 0 THEN strftime( '%F_%H:%M:%f', pdu.date_sent, 'unixepoch' )
        ELSE '[N/A]'
    END as "PduDateSentUtc",

    /* Message direction (incoming/outgoing) */
    CASE pdu.msg_box
        WHEN 1 THEN 'Incoming'
        WHEN 2 THEN 'Outgoing'
        ELSE 'Type ' || pdu.msg_box
    END AS "PduMsgBox",

    /* Was the message read */
    pdu.read AS "PduRead",

    /* Phone number of the message sender */
    /* Removes unnecessary text at the start of the string to leave just the 10-digit phone number */
    CASE
        WHEN ( SELECT SUBSTR ( address, 3 ) FROM addr WHERE pdu._id = addr.msg_id AND addr.type = 137 AND addr.address LIKE '%+1%' ) IS NULL
            THEN ( SELECT address FROM addr WHERE pdu._id = addr.msg_id AND addr.type = 137 )
        ELSE ( SELECT SUBSTR ( address, 3 ) FROM addr WHERE pdu._id = addr.msg_id AND addr.type = 137 AND addr.address LIKE '%+1%' )
    END AS "From",

    /* Phone number of the message recipient */
    /* Removes unnecessary text at the start of the string to leave just the 10-digit phone number */
    CASE
        WHEN ( SELECT SUBSTR ( address, 3 ) FROM addr WHERE pdu._id = addr.msg_id AND addr.type = 151 AND addr.address LIKE '%+1%' ) IS NULL
            THEN ( SELECT address FROM addr WHERE pdu._id = addr.msg_id AND addr.type = 151 )
        ELSE ( SELECT SUBSTR ( address, 3 ) FROM addr WHERE pdu._id = addr.msg_id AND addr.type = 151 AND addr.address LIKE '%+1%' )
    END AS "To",

    /* If the message was CCed to anyone, it will be listed here */
    ( SELECT address FROM addr WHERE pdu._id = addr.msg_id AND addr.type = 130 ) AS "Cc",

    /* If the message was BCCed to anyone, it will be listed here */
    ( SELECT address FROM addr WHERE pdu._id = addr.msg_id AND addr.type = 129 ) AS "Bcc",

    part._id AS "PartId",
    part.seq AS "PartSeq",
    part.ct AS "PartCt",

    /* File name of the attached file (if any) */
    part.cl AS "PartCl",

    /* File path of the attached file (if any) */
    part._data AS "PartData",
    /* Message content */
    part.text  AS "PartText",
    pdu.creator AS "PduCreator",
    pdu.sim_imsi AS "PduSimImsi",
    pdu.correlation_tag AS "PduCorrelationTag",
    pdu.ct_l AS "PduCtL",

    /* Source for each line of data */
    'File: \data\data\com.android.providers.telephony\databases\mmssms.db; Table: pdu(_id: ' || pdu._id || ')' AS "DataSource"


FROM pdu
    LEFT JOIN part ON part.mid=pdu._id


/* Groups the messages first by the `_id` value, then by `date` and then by `part_id` */
ORDER BY pdu._id, pdu.date, part_id


------------------------------------------------------
/*
Query for just SMS messages from the mmssms.db
*/
------------------------------------------------------


SELECT
    /* Add a row number at the beggining of each row */
    ROW_NUMBER() OVER( ORDER BY sms.date ) AS "RowNumber",

    sms._id AS "SmsId",
    sms.thread_id AS "SmsThreadId",

    /*
    Removes unnecessary text at the start of the string to leave just the 10-digit phone number
    Formats string as a U.S. phone number, i.e. (###) ###-####
    */
    CASE
        WHEN LENGTH ( sms.address ) = 12 AND sms.address LIKE '%+1%'
            THEN '(' ||
                SUBSTR ( sms.address, 3, 3 ) || ') ' ||
                SUBSTR ( sms.address, 6, 3 ) || '-' ||
                SUBSTR ( sms.address, 9, 4 )
        WHEN LENGTH ( sms.address ) = 10
            THEN '(' ||
                SUBSTR ( sms.address, 1, 3 ) || ') ' ||
                SUBSTR ( sms.address, 4, 3 ) || '-' ||
                SUBSTR ( sms.address, 7, 4 )
        ELSE 'Type ' || sms.address
    END AS "SmsAddress",

    sms.person AS "SmsPerson",

    /* Date/Time of the message */
    CASE
        WHEN sms.date > 0 THEN strftime( '%Y-%m-%d %H:%M:%S', sms.date / 1000.0, 'unixepoch' )
        ELSE '[N/A]'
    END AS "SmsDateUtc",

    /* Message direction (incoming/outgoing) */
    CASE sms.type
        WHEN 1 THEN 'Incoming'
        WHEN 2 THEN 'Outgoing'
        ELSE 'Type ' || sms.type
    END AS "SmsDirection",

    /* Was the message read */
    CASE sms.read
        WHEN 0 THEN 'Unread'
        WHEN 1 THEN 'Read'
        ELSE 'Type ' || sms.read
    END AS "SmsRead",

    /* Was a subject listed for the message */
    sms.subject AS "SmsSubject",

    /* Message content */
    sms.body AS "SmsBody",

    /*
    Removes unnecessary text at the start of the string to leave just the 10-digit phone number
    Formats string as a U.S. phone number, i.e. (###) ###-####
    */
    CASE
        WHEN LENGTH ( sms.service_center ) = 12 AND sms.service_center LIKE '%+1%'
            THEN '(' ||
                SUBSTR ( sms.service_center, 3, 3 ) || ') ' ||
                SUBSTR ( sms.service_center, 6, 3 ) || '-' ||
                SUBSTR ( sms.service_center, 9, 4 )
        ELSE 'Type ' || sms.service_center
    END AS "SmsServiceCenter",

    sms.creator AS "SmsCreator",
    sms.correlation_tag AS "SmsCorrelationTag",
    sms.sim_imsi AS "SmsSimImsi",

    /* Source for each line of data */
    'File: \data\data\com.android.providers.telephony\databases\mmssms.db; Table: sms(_id: ' || sms._id || ')' AS "DataSource"

FROM sms

/* Groups the messages first by the `thread_id` value and then by the `date` value */
ORDER BY sms.thread_id, sms.date
