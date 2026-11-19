/*
[DLU]
    19-Nov-2026
[VERSION]
    Tested on iOS 18
[DATABASE PATH]
    /private/var/mobile/Library/CoreDuet/People/interactionC.db
*/


SELECT

    ROW_NUMBER() OVER ( ORDER BY ZINTERACTIONS.ZSTARTDATE ) AS "RowNumber",

    ZINTERACTIONS.Z_PK AS "ZPk",

    CASE ZINTERACTIONS.ZDIRECTION
        WHEN 0 THEN 'Incoming'
        WHEN 1 THEN 'Outgoing'
        ELSE ZINTERACTIONS.ZDIRECTION
    END AS "MessageDirection",

    ZINTERACTIONS.ZBUNDLEID AS "BundleId",
    ZINTERACTIONS.ZDOMAINIDENTIFIER AS "DomainIdentifier",
    ZINTERACTIONS.ZGROUPNAME AS "GroupName",
    ZINTERACTIONS.ZSENDER AS "Sender",
    Z_2INTERACTIONRECIPIENT.Z_2RECIPIENTS AS "Recipients",
    ZCONTACTS.ZDISPLAYNAME AS "DisplayName",
    ZCONTACTS.ZIDENTIFIER AS "Identifier",
    ZINTERACTIONS.ZCONTENTURL AS "ContentUrl",

    strftime (
        '%F_%H:%M:%f',
        ZINTERACTIONS.ZSTARTDATE + 978307200,
        'unixepoch'
    ) AS "StartDateUtc",

    strftime (
        '%F_%H:%M:%f',
        ZINTERACTIONS.ZENDDATE + 978307200,
        'unixepoch'
    ) AS "EndDateUtc",

    strftime (
        '%F_%H:%M:%f',
        ZINTERACTIONS.ZCREATIONDATE + 978307200,
        'unixepoch'
    ) AS "CreationDateUtc",

    strftime (
        '%F_%H:%M:%f',
        ZINTERACTIONS.ZUPDATEDATE + 978307200,
        'unixepoch'
    ) AS "UpdateDateUtc",

    ZCONTACTS.ZINCOMINGRECIPIENTCOUNT AS "IncomingRecipientCount",

    strftime (
        '%F_%H:%M:%f',
        ZCONTACTS.ZFIRSTINCOMINGRECIPIENTDATE + 978307200,
        'unixepoch'
    ) AS "FirstIncomingRecipientDateUtc",

    ZCONTACTS.ZINCOMINGSENDERCOUNT AS "IncomingSenderCount",

    strftime (
        '%F_%H:%M:%f',
        ZCONTACTS.ZFIRSTINCOMINGSENDERDATE + 978307200,
        'unixepoch'
    ) AS "FirstIncomingSenderDateUtc",

    ZCONTACTS.ZOUTGOINGRECIPIENTCOUNT AS "OutgoingRecipientCount",

    strftime (
        '%F_%H:%M:%f',
        ZCONTACTS.ZFIRSTOUTGOINGRECIPIENTDATE + 978307200,
        'unixepoch'
    ) AS "FirstOutgoingRecipientDateUtc",

    strftime (
        '%F_%H:%M:%f',
        ZCONTACTS.ZLASTINCOMINGRECIPIENTDATE + 978307200,
        'unixepoch'
    ) AS "LastIncomingRecipientDateUtc",

    strftime (
        '%F_%H:%M:%f',
        ZCONTACTS.ZLASTINCOMINGSENDERDATE + 978307200,
        'unixepoch'
    ) AS "LastIncomingSenderDateUtc",

    strftime (
        '%F_%H:%M:%f',
        ZCONTACTS.ZLASTOUTGOINGRECIPIENTDATE + 978307200,
        'unixepoch'
    ) AS "LastOutgoingRecipientDateUtc",

    /* Source for each line of data */
    'interactionC.db; Table: ZINTERACTIONS(Z_PK: ' || ZINTERACTIONS.Z_PK || ')' AS "DataSource"


FROM ZINTERACTIONS
    LEFT JOIN Z_2INTERACTIONRECIPIENT ON ZINTERACTIONS.Z_PK = Z_2INTERACTIONRECIPIENT.Z_3INTERACTIONRECIPIENT
    LEFT JOIN ZCONTACTS ON ZINTERACTIONS.ZSENDER = ZCONTACTS.Z_PK


WHERE
    --To filter between date/time points
    ZINTERACTIONS.ZSTARTDATE BETWEEN 750312000 AND 750449160


ORDER BY
    ZINTERACTIONS.ZSTARTDATE ASC
