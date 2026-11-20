/*
[DLU]
    20-Nov-2026
[DATABASE]
    /private/var/mobile/Media/PhotoData/Photos.sqlite
    /private/var/mobile/Library/Photos/Libraries/Syndication.photoslibrary/database/Photos.sqlite
[NOTES]

*/


SELECT

    /* Add a row number at the beggining of each row */
    ROW_NUMBER() OVER ( ORDER BY ZASSET.ZADDEDDATE ) AS RowNumber,

    ZASSET.Z_PK AS ZPk,

    ZASSET.ZADDITIONALATTRIBUTES AS AdditionalAttributes,
    ZDETECTEDFACE.ZASSETFORFACE AS AssetForFace,

    CASE ZASSET.ZKIND
        WHEN 0 THEN 'Photo'
        WHEN 1 THEN 'Video'
        ELSE 'Type: [' || ZASSET.ZKIND || ']'
    END AS AssetKind,

    ZASSET.ZUNIFORMTYPEIDENTIFIER AS UniformTypeIdentifier,

    CASE
        WHEN LENGTH ( ZASSET.ZDATECREATED ) = 18
            THEN strftime ( '%F_%H:%M:%f', ( ZASSET.ZDATECREATED / 1000000000.0 ) + 978307200, 'unixepoch' )
        WHEN LENGTH ( ZASSET.ZDATECREATED ) = 9
            THEN strftime ( '%F_%H:%M:%f', ZASSET.ZDATECREATED + 978307200, 'unixepoch' )
        ELSE 'RawData: [' || ZASSET.ZDATECREATED || ']'
    END AS DareCreatedUtc,

    ZADDITIONALASSETATTRIBUTES.ZEXIFTIMESTAMPSTRING AS ExifTimeStampStringUtc,

    strftime ( '%F_%H:%M:%f', ZASSET.ZADDEDDATE + 978307200, 'unixepoch' ) AS AddedDateUtc,
    strftime ( '%F_%H:%M:%f', ZADDITIONALASSETATTRIBUTES.ZSCENEANALYSISTIMESTAMP + 978307200, 'unixepoch' ) AS SceneAnalysisTimeStampUtc,
    strftime ( '%F_%H:%M:%f', ZASSET.ZANALYSISSTATEMODIFICATIONDATE + 978307200, 'unixepoch' ) AS AnalysisStateModificationDateUtc,

    ZASSET.ZDIRECTORY AS Directory,
    ZASSET.ZFILENAME AS AssetFileName,
    CONCAT ( ZASSET.ZDIRECTORY, '/', ZASSET.ZFILENAME ) AS FullFilePath,
    ZADDITIONALASSETATTRIBUTES.ZORIGINALFILENAME AS OriginalFileName,
    ZGENERICALBUM.ZTITLE AS Title,
    ZADDITIONALASSETATTRIBUTES.ZCREATORBUNDLEID AS CreatorBundleId,
    ZADDITIONALASSETATTRIBUTES.ZEDITORBUNDLEID AS EditorBundleId,

    CASE ZASSET.ZSAVEDASSETTYPE
        WHEN 0 THEN 'Saved via other source'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Photo Streams Data'
        WHEN 3 THEN 'Local Photo Library Asset'
        WHEN 4 THEN 'Photo Cloud Sharing Data Asset'
        WHEN 5 THEN 'PhotoBooth Photo Library Asset'
        WHEN 6 THEN 'Cloud Photo Library Asset'
        WHEN 7 THEN 'Still Testing'
        WHEN 8 THEN 'iCloudLink Cloud Master Moment Asset'
        WHEN 12 THEN 'SWY Syndication PL Asset/Auto Displayed in LPL'
        ELSE 'Type: [' || ZASSET.ZSAVEDASSETTYPE || ']'
    END AS SavedAssetTypeLpl,

    CASE
        WHEN ZASSET.ZFACEAREAPOINTS > 0 THEN 'Yes'
        ELSE 'Type: [' || ZASSET.ZFACEAREAPOINTS || ']'
    END AS FaceAreaPoints,

    ZPERSON.ZDISPLAYNAME AS PersonDisplayName,
    ZPERSON.ZFULLNAME AS PersonFullName,
    ZPERSON.ZFACECOUNT AS PersonFaceCount,
    ZDETECTEDFACE.ZPERSONFORFACE AS PersonForFace,
    hex ( ZPERSON.ZCONTACTMATCHINGDICTIONARY ) AS ContactMatchingDictionaryHex,
    ZPERSON.ZPERSONUUID AS PersonUuid,
    ZDETECTEDFACE.ZQUALITYMEASURE AS QualityMeasure,

    CASE ZDETECTEDFACE.ZAGETYPE
        WHEN 1 THEN 'Baby/Toddler'
        WHEN 2 THEN 'Baby/Toddler'
        WHEN 3 THEN 'Child/Young Adult'
        WHEN 4 THEN 'Young Adult/Adult'
        WHEN 5 THEN 'Adult'
        ELSE 'Type: [' || ZDETECTEDFACE.ZAGETYPE || ']'
    END AS AgeType,

    CASE ZDETECTEDFACE.ZGENDERTYPE
        WHEN 1 THEN 'Male'
        WHEN 2 THEN 'Female'
        ELSE 'Type: [' || ZDETECTEDFACE.ZGENDERTYPE || ']'
    END AS GenderType,

    CASE ZDETECTEDFACE.ZGLASSESTYPE
        WHEN 1 THEN 'Eye'
        WHEN 2 THEN 'Sun'
        WHEN 3 THEN 'None'
        ELSE 'Type: [' || ZDETECTEDFACE.ZGLASSESTYPE || ']'
    END AS GlassesType,

    CASE ZDETECTEDFACE.ZFACIALHAIRTYPE
        WHEN 1 THEN 'None'
        WHEN 2 THEN 'Beard/Mustache'
        WHEN 3 THEN 'Goatee'
        WHEN 5 THEN 'Stubble'
        ELSE 'Type: [' || ZDETECTEDFACE.ZFACIALHAIRTYPE || ']'
    END AS FacialHairType,

    CASE ZDETECTEDFACE.ZHAIRTYPE
        WHEN 2 THEN 'Bald'
        WHEN 3 THEN 'Not Bald'
        ELSE 'Type: [' || ZDETECTEDFACE.ZHAIRTYPE || ']'
    END AS HairType,

    ZASSET.ZORIGINALCOLORSPACE AS OriginalColorSpace,
    ZASSET.ZDURATION AS Duration,
    ZASSET.ZVIDEOCPDURATIONVALUE AS VideoCpDurationValue,

    CASE ZASSET.ZCOMPLETE
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || ZASSET.ZCOMPLETE || ']'
    END AS IsComplete,

    CASE ZASSET.ZVISIBILITYSTATE
        WHEN 0 THEN 'Visible'
        WHEN 1 THEN 'Photo Streams Data'
        WHEN 2 THEN 'Burst'
        ELSE 'Type: [' || ZASSET.ZVISIBILITYSTATE || ']'
    END AS VisibilityState,

    CASE ZASSET.ZFAVORITE
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || ZASSET.ZFAVORITE || ']'
    END AS IsFavorite,

    CASE ZASSET.ZHIDDEN
        WHEN 0 THEN 'Not Hidden'
        WHEN 1 THEN 'File Hidden'
        ELSE 'Type: [' || ZASSET.ZHIDDEN || ']'
    END AS IsHidden,

    CASE ZASSET.ZTRASHEDSTATE
        WHEN 0 THEN 'Not In Trash'
        WHEN 1 THEN 'In Trash'
        ELSE 'Type: [' || ZASSET.ZTRASHEDSTATE || ']'
    END AS TrashedState,

    strftime ( '%F_%H:%M:%f', ZASSET.ZTRASHEDDATE + 978307200, 'unixepoch' ) AS TrashedDateUtc,

    ZADDITIONALASSETATTRIBUTES.ZVIEWCOUNT AS ViewCount,
    ZADDITIONALASSETATTRIBUTES.ZPLAYCOUNT AS PlayCount,
    ZADDITIONALASSETATTRIBUTES.ZSHARECOUNT AS ShareCount,

    strftime ( '%F_%H:%M:%f', ZASSET.ZLASTSHAREDDATE + 978307200, 'unixepoch' ) AS LastSharedDateUtc,
    strftime ( '%F_%H:%M:%f', ZASSET.ZMODIFICATIONDATE + 978307200, 'unixepoch' ) AS ModificationDateUtc,

    CASE ZASSET.ZHASADJUSTMENTS
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || ZASSET.ZHASADJUSTMENTS || ']'
    END AS HasAdjustments,

    strftime ( '%F_%H:%M:%f', ZASSET.ZADJUSTMENTTIMESTAMP + 978307200, 'unixepoch' ) AS AdjustmentTimeStampUtc,

    ZADDITIONALASSETATTRIBUTES.ZORIGINALFILESIZE AS OriginalFileSize,
    ZASSET.ZHEIGHT AS Height,
    ZADDITIONALASSETATTRIBUTES.ZORIGINALHEIGHT AS OriginalHeight,
    ZASSET.ZWIDTH AS Width,
    ZADDITIONALASSETATTRIBUTES.ZORIGINALWIDTH AS OriginalWidth,
    ZADDITIONALASSETATTRIBUTES.ZCAMERACAPTUREDEVICE AS CameraCaptureDevice,

    CASE ZASSET.ZORIENTATION
        WHEN 1 THEN 'Horizontal (Left)'
        WHEN 3 THEN 'Horizontal (Right)'
        WHEN 6 THEN 'Vertical (Up)'
        WHEN 8 THEN 'Vertical (Down)'
        ELSE 'Type: [' || ZASSET.ZORIENTATION || ']'
    END AS Orientation,

    CASE ZADDITIONALASSETATTRIBUTES.ZORIGINALORIENTATION
        WHEN 1 THEN 'Horizontal (Left)'
        WHEN 3 THEN 'Horizontal (Right)'
        WHEN 6 THEN 'Vertical (Up)'
        WHEN 8 THEN 'Vertical (Down)'
        ELSE 'Type: [' || ZADDITIONALASSETATTRIBUTES.ZORIGINALORIENTATION || ']'
    END AS OriginalOrientation,

    ZADDITIONALASSETATTRIBUTES.ZTIMEZONENAME AS TimeZoneName,
    ZADDITIONALASSETATTRIBUTES.ZTIMEZONEOFFSET AS TimeZoneOffset,
    ZADDITIONALASSETATTRIBUTES.ZINFERREDTIMEZONEOFFSET AS InferredTimeZoneOffset,
    ZASSET.ZLOCATIONDATA AS LocationData,

    CASE ZASSET.ZLATITUDE
        WHEN -180.0 THEN '[-180.0]'
        ELSE ZASSET.ZLATITUDE
    END AssetLatitude,

    CASE ZASSET.ZLONGITUDE
        WHEN -180.0 THEN '[-180.0]'
        ELSE ZASSET.ZLONGITUDE
    END AssetLongitude,

    CASE ZADDITIONALASSETATTRIBUTES.ZSHIFTEDLOCATIONISVALID
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || ZADDITIONALASSETATTRIBUTES.ZSHIFTEDLOCATIONISVALID || ']'
    END AS ShiftedLocationIsValid,

    CASE ZADDITIONALASSETATTRIBUTES.ZREVERSELOCATIONDATAISVALID
        WHEN 0 THEN 'No - Check Scene Analysis'
        WHEN 1 THEN 'Yes - Check Scene Analysis'
        ELSE 'Type: [' || ADDITIONALASSETATTRIBUTES.ZREVERSELOCATIONDATAISVALID || ']'
    END AS ReverseLocationDataIsValid,

    ZADDITIONALASSETATTRIBUTES.ZREVERSELOCATIONDATA AS ReverseLocationData,
    ZASSET.ZTHUMBNAILINDEX AS ThumbnailIndex,
    ZADDITIONALASSETATTRIBUTES.ZEMBEDDEDTHUMBNAILWIDTH AS EmbeddedThumbnailWidth,
    ZADDITIONALASSETATTRIBUTES.ZEMBEDDEDTHUMBNAILHEIGHT AS EmbeddedThumbnailHeight,
    ZADDITIONALASSETATTRIBUTES.ZEMBEDDEDTHUMBNAILOFFSET AS EmbeddedThumbnailOffset,
    ZADDITIONALASSETATTRIBUTES.ZEMBEDDEDTHUMBNAILLENGTH AS EmbeddedThumbnailLength,
    ZASSET.ZMOMENT AS AssetMoment,
    ZMOMENT.ZTITLE AS MomentTitle,

    strftime ( '%F_%H:%M:%f', ZMOMENT.ZSTARTDATE + 978307200, 'unixepoch' ) AS MomentStartDateUtc,
    strftime ( '%F_%H:%M:%f', ZMOMENT.ZREPRESENTATIVEDATE + 978307200, 'unixepoch' ) AS MomentRepresentativeDateUtc,
    strftime ( '%F_%H:%M:%f', ZMOMENT.ZMODIFICATIONDATE + 978307200, 'unixepoch' ) AS MomentModificationDateUtc,
    strftime ( '%F_%H:%M:%f', ZMOMENT.ZENDDATE + 978307200, 'unixepoch' ) AS MomentEndDateUtc,

    CASE ZMOMENT.ZTRASHEDSTATE
        WHEN 0 THEN 'Not In Trash'
        WHEN 1 THEN 'In Trash'
        ELSE 'Type: [' || ZMOMENT.ZTRASHEDSTATE || ']'
    END AS TrashedState,

    CASE ZMOMENT.ZAPPROXIMATELATITUDE
        WHEN -180.0 THEN NULL
        ELSE ZMOMENT.ZAPPROXIMATELATITUDE
    END AS ApproximateLatitude,

    CASE ZMOMENT.ZAPPROXIMATELONGITUDE
        WHEN -180.0 THEN NULL
        ELSE ZMOMENT.ZAPPROXIMATELONGITUDE
    END AS ApproximateLongitude,

    ZASSET.ZUUID AS Uuid,
    ZASSET.ZMEDIAGROUPUUID AS MediaGroupUuid,
    ZASSET.ZCLOUDASSETGUID AS CloudAssetGuid,
    ZADDITIONALASSETATTRIBUTES.ZPUBLICGLOBALUUID AS PublicGlobalUuid,
    -- ZADDITIONALASSETATTRIBUTES.ZMASTERFINGERPRINT AS MasterFingerPrint,
    -- ZADDITIONALASSETATTRIBUTES.ZADJUSTEDFINGERPRINT AS AdjustedFinderPrint,

    /* Source for each line of data */
    'Photos.sqlite; Table: ZASSET(Z_PK:' || ZASSET.Z_PK || ')' AS DataSource


FROM ZASSET
    LEFT JOIN ZMOMENT ON ZMOMENT.Z_PK = ZASSET.ZMOMENT
    JOIN ZADDITIONALASSETATTRIBUTES ON ZASSET.ZADDITIONALATTRIBUTES = ZADDITIONALASSETATTRIBUTES.Z_PK
    LEFT JOIN ZDETECTEDFACE ON ZDETECTEDFACE.ZASSETFORFACE = ZASSET.Z_PK
    LEFT JOIN ZPERSON ON ZPERSON.Z_PK = ZDETECTEDFACE.ZPERSONFORFACE
    LEFT JOIN Z_30ASSETS ON ZASSET.Z_PK = Z_30ASSETS.Z_3ASSETS
    LEFT JOIN ZGENERICALBUM ON ZGENERICALBUM.Z_PK = Z_30ASSETS.Z_30ALBUMS


WHERE ZASSET.ZFACEAREAPOINTS > 0


ORDER BY ZASSET.Z_PK ASC
