/*
[DLU]
    20-Nov-2026
[DATABASE]
    /private/var/root/Library/Caches/locationd/cache_encryptedB.db
[NOTES]
    Parse location data from
*/


SELECT

    ROW_NUMBER() OVER ( ORDER BY WifiLocation.timestamp ) AS RowNumber,

    strftime ( '%Y-%m-%dT%H:%M:%SZ', WifiLocation.timestamp + 978307200, 'unixepoch' ) AS TimeStampUtc,
    strftime ( '%Y-%m-%d %H:%M:%S', WifiLocation.timestamp + 978307200, 'unixepoch', 'localtime' ) AS TimeStampLocal,

    /* This will concat the MAC address into a readable format */
    UPPER ( substr ( printf ( '%0!.12x', MAC ), 1, 2 )  || ':' ||
        substr ( printf ( '%0!.12x', MAC ), 3, 2 )  || ':' ||
        substr ( printf ( '%0!.12x', MAC ), 5, 2 )  || ':' ||
        substr ( printf ( '%0!.12x', MAC ), 7, 2 )  || ':' ||
        substr ( printf ( '%0!.12x', MAC ), 9, 2 )  || ':' ||
        substr ( printf ( '%0!.12x', MAC ), 11, 2 )
    ) AS MacAddress,

    WifiLocation.Channel AS Channel,
    WifiLocation.Latitude AS Latitude,
    WifiLocation.Longitude AS Longitude,
    WifiLocation.HorizontalAccuracy AS HorizontalAccuracy,
    WifiLocation.Altitude AS Altitude,
    WifiLocation.Confidence AS Confidence


FROM WifiLocation


ORDER BY WifiLocation.timestamp DESC
