/*
[DLU]
    20-Nov-2026
[DATABASE PATH]
    /private/var/mobile/Library/AddressBook/AddressBook.sqlitedb
[NOTES]

*/


SELECT

    ROW_NUMBER() OVER ( ABPerson.CreationDate ) AS RowNumber,

    ABPerson.ROWID AS RowId,
    ABPerson.First AS Rirst,
    ABPerson.Middle AS Middle,
    ABPerson.Last AS "Last",
    ABPerson.Organization AS Organization,
    ABPerson.Department AS Department,
    ABPerson.Birthday AS Birthday,
    ABPerson.JobTitle AS JobTitle,
    ABPerson.Note AS Note,

    ( SELECT value FROM ABMultiValue WHERE property = 3 AND record_id = ABPerson.ROWID AND label = (
        SELECT ROWID FROM ABMultiValueLabel WHERE value = '_$!<Work>!$_' ) ) AS WorkPhone,

    ( SELECT value FROM ABMultiValue WHERE property = 3 AND record_id = ABPerson.ROWID AND label = (
        SELECT ROWID FROM ABMultiValueLabel WHERE value = '_$!<Mobile>!$_' ) ) AS MobilePhone,

    ( SELECT value FROM ABMultiValue WHERE property = 3 AND record_id = ABPerson.ROWID AND label = (
        SELECT ROWID FROM ABMultiValueLabel WHERE value = '_$!<Home>!$_' ) ) AS HomePhone,

    ( SELECT value FROM ABMultiValue WHERE property = 3 AND record_id = ABPerson.ROWID AND label IS NULL ) AS PhoneOther,

    ( SELECT GROUP_CONCAT ( value, ' | ' ) FROM ABMultiValue WHERE property = 4 AND record_id = ABPerson.ROWID ) AS Email,

    ( SELECT value FROM ABMultiValueEntry WHERE parent_id IN (
        SELECT ROWID FROM ABMultiValue WHERE record_id = ABPerson.ROWID ) AND key = (
            SELECT ROWID FROM ABMultiValueEntryKey WHERE LOWER ( value ) = 'street' ) ) AS "Address",

    ( SELECT value FROM ABMultiValueEntry WHERE parent_id IN (
        SELECT ROWID FROM ABMultiValue WHERE record_id = ABPerson.ROWID ) AND key = (
            SELECT ROWID FROM ABMultiValueEntryKey WHERE LOWER ( value ) = 'city' ) ) AS City,

    ( SELECT value FROM ABMultiValueEntry WHERE parent_id IN (
        SELECT ROWID FROM ABMultiValue WHERE record_id = ABPerson.ROWID ) AND key = (
            SELECT ROWID FROM ABMultiValueEntryKey WHERE LOWER ( value ) = 'state' ) ) AS "State",

    ( SELECT value FROM ABMultiValueEntry WHERE parent_id IN (
        SELECT ROWID FROM ABMultiValue WHERE record_id = ABPerson.ROWID ) AND key = (
            SELECT ROWID FROM ABMultiValueEntryKey WHERE LOWER ( value ) = 'zip' ) ) AS ZipCode,

    ( SELECT value FROM ABMultiValueEntry WHERE parent_id IN (
        SELECT ROWID FROM ABMultiValue WHERE record_id = ABPerson.ROWID ) AND key = (
            SELECT ROWID FROM ABMultiValueEntryKey WHERE LOWER ( value ) = 'country' ) ) AS Country,

    ( SELECT GROUP_CONCAT ( value, '; ' ) FROM ABMultiValue WHERE property = 22 AND record_id = ABPerson.ROWID ) AS Url,

    ABPersonFullTextSearch_content.c21RelatedNames AS RelatedNames,
    ABPersonFullTextSearch_content.c19SocialProfile AS SocialProfile,

    ( SELECT GROUP_CONCAT (
        CASE ABMultiValueEntry.key
            WHEN 1 THEN 'Service: ' || value
            WHEN 2 THEN 'Username: ' || value
            WHEN 3 THEN 'URL: ' || value
            ELSE ABMultiValueEntry.key || ': ' || value
        END, ' | ' )
        FROM ABMultiValueEntry WHERE parent_id IN (
            SELECT ROWID FROM ABMultiValue WHERE record_id = ABPerson.ROWID ) ) AS Services,

    CASE
        WHEN LENGTH ( ABPerson.CreationDate ) = 18
            THEN strftime ( '%F_%H:%M:%f', ( ABPerson.CreationDate / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( ABPerson.CreationDate ) = 9
            THEN strftime ( '%F_%H:%M:%f', ABPerson.CreationDate + 978307200, 'unixepoch' )
        ELSE 'Type: [' || ABPerson.CreationDate || ']'
    END AS CreationDateUtc,

    CASE
        WHEN LENGTH ( ABPerson.ModificationDate ) = 18
            THEN strftime ( '%F_%H:%M:%f', ( ABPerson.ModificationDate / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( ABPerson.ModificationDate ) = 9
            THEN strftime ( '%F_%H:%M:%f', ABPerson.ModificationDate + 978307200, 'unixepoch' )
        ELSE 'Type: [' || ABPerson.ModificationDate || ']'
    END AS ModificationDateUtc,

    /* Source for each line of data */
    'AddressBook.sqlitedb; Table:ABPerson(ROWID:' || ABPerson.ROWID || ')' AS DataSource


FROM ABPerson
    LEFT OUTER JOIN ABPersonFullTextSearch_content ON ABPerson.ROWID = ABPersonFullTextSearch_content.ROWID


ORDER BY
    ABPerson.ROWID
