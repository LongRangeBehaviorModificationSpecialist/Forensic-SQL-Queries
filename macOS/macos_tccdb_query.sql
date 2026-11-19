/*
MODULE_NOTES = Transparancy, Consent, and Control (TCC) Database - Application Permissions

[Database Metadata]
DATABASE = TCC.db
PLATFORM = macOS
VERSIONS = 10.14, 10.15

QUERY=
*/

SELECT
    datetime ( LAST_MODIFIED, 'unixepoch' ) AS "LastModified",
    SERVICE AS "Service",
    CLIENT AS "Client",

    CASE ALLOWED
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Contact Examiner for Further'
    END AS "Allowed",

    CLIENT_TYPE AS "ClientType",
    PROMPT_COUNT AS "PromptCount",
    INDIRECT_OBJECT_IDENTIFIER AS "IndirectObjectIdentifier"

FROM ACCESS
