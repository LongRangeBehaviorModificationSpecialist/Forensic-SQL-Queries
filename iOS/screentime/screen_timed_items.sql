/*
[DLU]
    20-Nov-2026
[DATABASE]
    RMAdminStore-Local.sqlite,
    RMAdminStore-Cloud.sqlite
[NOTES]

*/


SELECT

    DISTINCT

        ROW_NUMBER() OVER ( ORDER BY ZUSAGEBLOCK.ZSTARTDATE ) AS RowNumber,

        strftime (
            '%F_%H:%M:%f',
            ZUSAGEBLOCK.ZSTARTDATE + 978307200,
            'unixepoch'
        ) AS StartDateUtc,

        ZUSAGEBLOCK.ZSCREENTIMEINSECONDS AS ScreenTimeInSeconds,
        ( ZUSAGEBLOCK.ZSCREENTIMEINSECONDS / 60.00 ) AS ScreentimeMinutes,
        ZCOREUSER.ZGIVENNAME AS GivenName,
        ZCOREUSER.ZFAMILYNAME AS FamilyMame,
        ZCOREDEVICE.ZNAME AS "Name",

        CASE ZCOREDEVICE.ZPLATFORM
            WHEN 0 THEN 'Unknown'
            WHEN 1 THEN 'macOS'
            WHEN 2 THEN 'iOS'
            WHEN 4 THEN 'Apple Watch'
            ELSE 'Type: [' || ZCOREDEVICE.ZPLATFORM || ']'
        END AS Platform,

        ZCOREDEVICE.ZIDENTIFIER AS Identifier,
        ZCOREDEVICE.ZLOCALUSERDEVICESTATE AS LocalUserDeviceState,

        strftime (
            '%F_%H:%M:%f',
            ZUSAGEBLOCK.ZLONGESTSESSIONSTARTDATE + 978307200,
            'unixepoch'
        ) AS LongestSessionStartDateUtc,

        strftime (
            '%F_%H:%M:%f',
            ZUSAGEBLOCK.ZLONGESTSESSIONENDDATE + 978307200,
            'unixepoch'
        ) AS LongestSessionEndDateUtc,

        strftime (
            '%F_%H:%M:%f',
            ZUSAGEBLOCK.ZLASTEVENTDATE + 978307200,
            'unixepoch'
        ) AS LastEventDateUtc,

        ( ZUSAGEBLOCK.ZLONGESTSESSIONENDDATE - ZUSAGEBLOCK.ZLONGESTSESSIONSTARTDATE ) AS LongestSessionTimeSeconds,
        ( ( ZUSAGEBLOCK.ZLONGESTSESSIONENDDATE - ZUSAGEBLOCK.ZLONGESTSESSIONSTARTDATE ) / 60.00 ) AS LongestSessionTimeMinutes,
        ZCOREUSER.ZFAMILYMEMBERTYPE AS FamilyMemberType,
        ZCOREUSER.ZAPPLEID AS AppleId,
        ZCOREUSER.ZDSID AS Dsid,
        ZCOREUSER.ZALTDSID AS AltDsid


FROM ZUSAGETIMEDITEM
    LEFT JOIN ZUSAGECATEGORY ON ZUSAGECATEGORY.Z_PK = ZUSAGETIMEDITEM.ZCATEGORY
    LEFT JOIN ZUSAGEBLOCK ON ZUSAGECATEGORY.ZBLOCK = ZUSAGEBLOCK.Z_PK
    LEFT JOIN ZUSAGE ON ZUSAGEBLOCK.ZUSAGE = ZUSAGE.Z_PK
    LEFT JOIN ZCOREUSER ON ZUSAGE.ZUSER = ZCOREUSER.Z_PK
    LEFT JOIN ZCOREDEVICE ON ZUSAGE.ZDEVICE = ZCOREDEVICE.Z_PK


ORDER BY
    ZUSAGEBLOCK.ZSTARTDATE ASC
