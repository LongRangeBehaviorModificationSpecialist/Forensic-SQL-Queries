/*
[DLU]
    19-Nov-2026

[Module Metadata]
AUTHOR=[@mikespon]
MODULE_NOTES=Locations from LTE data

[Database Metadata]
DATABASE=cache_encryptedB.db
DATABASEPATH=/private/var/root/Library/Caches/locationd/
PLATFORM=iOS
VERSION=iOS 16.6 (20G75)
*/

SELECT

    ROW_NUMBER() OVER( ORDER BY LteCellLocation.timestamp ) AS "RowNumber",

    strftime ( '%Y-%m-%dT%H:%M:%SZ', LteCellLocation.timestamp + 978307200, 'unixepoch' ) AS "TimeStampUtc",
    strftime ( '%Y-%m-%d %H:%M:%S', LteCellLocation.timestamp + 978307200, 'unixepoch', 'localtime' ) AS "TimeStampLocal",

    LteCellLocation.Latitude AS "Latitude",
    LteCellLocation.Longitude AS "Longitude",
    RTRIM ( LTRIM ( CONCAT ( ROUND ( LteCellLocation.Latitude, 6 ), ',', ROUND ( LteCellLocation.Longitude, 6 ) ) ) ) AS "LatLongMerged",

    LteCellLocation.MCC AS "Mcc",
    LteCellLocation.MNC AS "Mnc",
    LteCellLocation.TAC AS "Tac",
    LteCellLocation.CI AS "Ci",
    LteCellLocation.HorizontalAccuracy AS "HorizontalAccuracy",
    LteCellLocation.Altitude AS "Altitude",
    LteCellLocation.Confidence AS "Confidence"


FROM LteCellLocation


ORDER BY LteCellLocation.timestamp DESC
