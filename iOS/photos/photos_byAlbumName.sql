/*
[DLU]
    20-Nov-2026
[DATABASE]
    /private/var/mobile/Media/PhotoData/Photos.sqlite
    /private/var/mobile/Library/Photos/Libraries/Syndication.photoslibrary/database/Photos.sqlite
[NOTES]

*/


SELECT

    ROW_NUMBER() OVER ( ORDER BY ZASSET.ZADDEDDATE ) AS RowNumber,

    ZGENERICALBUM.Z_PK AS ZPk,

    ZGENERICALBUM.ZTITLE AS Title,
    ZASSET.ZDIRECTORY AS Directory,
    ZASSET.ZFILENAME AS FileName,
    ZASSET.ZUNIFORMTYPEIDENTIFIER AS UniformTypeIdentifier,

    CASE ZASSET.ZFAVORITE
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || ZASSET.ZFAVORITE || ']'
    END Favorite,

    ZASSET.ZDURATION AS DurationSeconds,

    strftime ( '%F_%H:%M:%f', ZASSET.ZDATECREATED + 978307200, 'unixepoch' ) AS DateCreatedUtc,
    strftime ( '%F_%H:%M:%f', ZASSET.ZADDEDDATE + 978307200, 'unixepoch' ) AS AddedDateUtc,
    strftime ( '%F_%H:%M:%f', ZASSET.ZMODIFICATIONDATE + 978307200, 'unixepoch' ) AS ModificationDateUtc,
    strftime ( '%F_%H:%M:%f', ZASSET.ZTRASHEDDATE + 978307200, 'unixepoch' ) AS TrashedDateUtc,

    ZASSET.ZTHUMBNAILINDEX AS ThumbnailIndex,

    CASE ZASSET.ZLATITUDE
        WHEN '-180.0' THEN '[-180.0]'
        ELSE ZASSET.ZLATITUDE
    END Latitude,

    CASE ZASSET.ZLONGITUDE
        WHEN '-180.0' THEN '[-180.0]'
        ELSE ZASSET.ZLONGITUDE
    END Longitude


FROM ZASSET
    INNER JOIN (
        ZGENERICALBUM INNER JOIN Z_28ASSETS ON ZGENERICALBUM.Z_PK = Z_28ASSETS.Z_28ALBUMS
    ) ON ZASSET.Z_PK = Z_28ASSETS.Z_3ASSETS


ORDER BY ZGENERICALBUM.Z_PK
