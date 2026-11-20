/*
[DLU]
    20-Nov-2026
[DATABASE]
    TCC.db
[NOTES]
    Transparancy, Consent, and Control (TCC) Database - Application Permissions
*/


SELECT

    ROW_NUMBER() OVER( ORDER BY ACCESS.LAST_MODIFIED ) AS RowNumber,

    strftime ( '%F_%H:%M:%f', ACCESS.LAST_MODIFIED, 'unixepoch' ) AS LastModified,
    ACCESS.SERVICE AS "Service",
    ACCESS.CLIENT AS Client,

    CASE ACCESS.ALLOWED
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || ACCESS.ALLOWED || ']'
    END AS Allowed,

    ACCESS.CLIENT_TYPE AS ClientType,
    ACCESS.PROMPT_COUNT AS PromptCount,
    ACCESS.INDIRECT_OBJECT_IDENTIFIER AS IndirectObjectIdentifier


FROM ACCESS
