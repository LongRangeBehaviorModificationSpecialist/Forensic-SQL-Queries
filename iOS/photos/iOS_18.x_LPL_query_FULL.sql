/*
[DLU]
    19-Nov-2026

[NOTES]
    Modified from original query copied from:
    https://github.com/ScottKjr3347/iOS_Local_PL_Photos.sqlite_Queries
*/

SELECT

    ROW_NUMBER() OVER ( ORDER BY ZASSET.ZADDEDDATE ) AS "001-RowNumber",

    ZASSET.ZDIRECTORY AS "002-ZAssetDirectory",
    ZASSET.ZFILENAME AS "003-ZAssetFileName",
    ZADDASSETATTRS.ZORIGINALFILENAME AS "004-ZAddAssetAttrsOriginalFileName",
    ZCLDMAST.ZORIGINALFILENAME AS "005-ZCldMastOriginalFileName",
    ZADDASSETATTRS.ZSYNDICATIONIDENTIFIER AS "006-ZAddAssetAttrsSyndicationIdentifier",

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZADDEDDATE + 978307200,
        'unixepoch'
    ) AS "007-ZAssetAddedDateUtc",

    ZASSET.ZSORTTOKEN AS "008-ZAssetSortToken",
    ZASSET.ZPROMOTIONSCORE AS "009-ZAssetPromotionScore",

    CASE ZASSET.ZCOMPLETE
        WHEN 1 THEN 'Yes'
        ELSE ZASSET.ZCOMPLETE
    END AS "010-ZAssetComplete",

    ZASSET.Z_PK AS "011-ZAssetZPk",
    ZADDASSETATTRS.Z_PK AS "012-ZAddAssetAttrsZPk",

    -- [ZCLDMAST.Z_PK = ZASSET.Z_MASTER]
    ZCLDMAST.Z_PK AS "013-ZCldMastZPk",

    -- [ZASSET.ZMASTER = ZCLDMAST.Z_PK]
    ZASSET.ZMASTER AS "014-ZAssetMaster",

    -- [ZASSET.EXTDATTR = ZEXTATTR.Z_PK]
    ZASSET.ZEXTENDEDATTRIBUTES AS "015-ZAssetExtendedAttributes",
    ZEXTATTR.Z_PK AS "016-ZExtAttrZPk",

    -- [CMZCLDMASTMEDDATA.ZCLOUDMASTER = ZCLDMAST.Z_PK]
    CMZCLDMASTMedData.ZCLOUDMASTER AS "017-CmZCldMastMedDataCloudMaster",

    -- [ZCLDMAST.ZMEDIAMETADATA = ZCLDMASTMEDDATA.Z_PK]
    ZCLDMAST.ZMEDIAMETADATA AS "018-ZCldMastMediaMetadata",

    -- [CMZCLDMASTMEDDATA.Z_PK = ZADDASSETATTRS&ZCLDMAST.ZMEDIAMETADATA]
    CMZCLDMASTMedData.Z_PK AS "019-CmZCldMastMedDataZPk",

    CMZCLDMASTMedData.Z_ENT AS "020-CmZCldMastMedDataEnt",
    ZASSET.ZUUID AS "021-ZAssetUuid",

    -- This value will be the same on two different devices if the asset was synced via iCloud
    ZASSET.ZCLOUDASSETGUID AS "022-ZAssetCloudAssetGuid",
    ZASSET.ZCLOUDCOLLECTIONGUID AS "023-ZAssetCloudCollectGuid",

    -- This value will be the same on two different devices if the asset was synced via iCloud
    ZCLDMAST.ZCLOUDMASTERGUID AS "024-ZCldMastCloudMasterGuid",
    ZGENALBUM.ZCLOUDGUID AS "025-ZGenAlbumCloudGuid",
    ZShare.ZSCOPEIDENTIFIER AS "026-ZShareScopeIdentifier",
    ZADDASSETATTRS.ZORIGINALASSETSUUID AS "027-ZAddAssetAttrsOriginalAssetsUuid",
    ZADDASSETATTRS.ZPUBLICGLOBALUUID AS "028-ZAddAssetAttrsPublicGlobalUuid",
    ZADDASSETATTRS.ZORIGINATINGASSETIDENTIFIER AS "029-ZAddAssetAttrsOriginatingAssetIdentifier",
    ZCLDMAST.ZORIGINATINGASSETIDENTIFIER AS "030-ZCldMastOriginatingAssetIdentifier",

    CASE ZADDASSETATTRS.ZDATECREATEDSOURCE
        WHEN 0 THEN 'Cloud Asset'
        WHEN 1 THEN 'Local Asset w/ EXIF'
        WHEN 3 THEN 'Local Asset No EXIF'
        ELSE 'Unknown Value: ' || ZADDASSETATTRS.ZDATECREATEDSOURCE || ''
    END AS "031-ZAddAssetAttrsDateCreatedSource",

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZDATECREATED + 978307200,
        'unixepoch'
    ) AS "032-ZAssetDateCreatedUtc",

    strftime (
        '%F_%H:%M:%f',
        ZCLDMAST.ZCREATIONDATE + 978307200,
        'unixepoch'
    ) AS "033-ZCldMastCreationDateUtc",

    strftime (
        '%F_%H:%M:%f',
        ZINTRESOU.ZCLOUDMASTERDATECREATED + 978307200,
        'unixepoch'
    ) AS "034-ZIntreSouCloudMasterDateCreatedUtc",

    ZADDASSETATTRS.ZTIMEZONENAME AS "035-ZAddAssetAttrsTimeZoneName",
    ZADDASSETATTRS.ZTIMEZONEOFFSET AS "036-ZAddAssetAttrsTimeZoneOffset",
    ZADDASSETATTRS.ZINFERREDTIMEZONEOFFSET AS "037-ZAddAssetAttrsInferredTimeZoneOffset",
    ZADDASSETATTRS.ZEXIFTIMESTAMPSTRING AS "038-ZAddAssetAttrsExifTimeStampString",

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZMODIFICATIONDATE + 978307200,
        'unixepoch'
    ) AS "039-ZAssetModificationDateUtc",

    strftime (
        '%F_%H:%M:%f',
        ZADDASSETATTRS.ZLASTVIEWEDDATE + 978307200,
        'unixepoch'
    ) AS "040-ZAddAssetArrtsLastViewedDateUtc",

    ZINTRESOU.ZFINGERPRINT AS "041-ZInterSouFingerprint",

    CASE ParentZGENALBUM.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'iCloud Photos ON = Asset In Shared/Other Album | iCloud Photos OFF = Generic Album'
        WHEN 1 THEN 'iCloud Photos ON = Asset In Generic Album'
        ELSE 'Unknown Value: ' || ParentZGENALBUM.ZCLOUDLOCALSTATE || ''
    END AS "042-ParentGenAlbumCloudLocalState",

    ParentZGENALBUM.ZTITLE AS "043-ParentGenAlbumTitle",

    strftime (
        '%F_%H:%M:%f',
        ParentZGENALBUM.ZCREATIONDATE + 978307200,
        'unixepoch'
    ) AS "044-ParentGenAlbumCreationDateUtc",

    strftime (
        '%F_%H:%M:%f',
        ZGENALBUM.ZCREATIONDATE + 978307200,
        'unixepoch'
    ) AS "045-ZGenAlbumCreationDateUtc",

    CASE ZGENALBUM.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'iCloud Photos ON = Asset In Shared/Other Album | iCloud Photos OFF = Generic Album'
        WHEN 1 THEN 'iCloud Photos ON = Asset In Generic Album'
        ELSE 'Unknown Value: ' || ZGENALBUM.ZCLOUDLOCALSTATE || ''
    END AS "046-ZGenAlbumCloudLocalState",

    ZGENALBUM.ZTITLE AS "047-ZGenAlbumTitle",

    CASE ZASSET.ZBUNDLESCOPE
        WHEN 0 THEN 'iCloud Photos ON (Not In Shared Album) | iCloud Photos OFF (On Local Device)'
        WHEN 1 THEN 'SWY Syndication CMMAsset'
        WHEN 2 THEN 'iCloud Photos ON (Asset In Cloud Shared Album)'
        WHEN 3 THEN 'iCloud Photos ON (SWY Syndication-Asset)'
        ELSE 'Unknown Value: ' || ZASSET.ZBUNDLESCOPE || ''
    END AS "048-ZAssetBundleScope",

    CASE ZASSET.ZCLOUDISMYASSET
        WHEN 0 THEN 'Not My Asset in Shared Album'
        WHEN 1 THEN 'My Asset in Shared Album'
        ELSE 'Unknown Value: ' || ZASSET.ZCLOUDISMYASSET || ''
    END AS "049-ZAssetCloudIsMyAsset",

    CASE ZASSET.ZCLOUDISDELETABLE
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Unknown Value: ' || ZASSET.ZCLOUDISDELETABLE || ''
    END AS "050-ZAssetCloudIsDeletable",

    CASE ZASSET.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'iCloud Photos ON = Asset In Shared or Other Album) | iCloud Photos OFF = Not Synced'
        WHEN 1 THEN 'iCloud Photos ON = Asset Can Be or Has Been Synced with iCloud'
        ELSE 'Unknown Value: ' || ZASSET.ZCLOUDLOCALSTATE || ''
    END AS "051-ZAssetCloudLocalState",

    -- Indicates whether assets are visible within the Local Photo Library
    CASE ZASSET.ZVISIBILITYSTATE
        WHEN 0 THEN 'Visible Photo Library'
        WHEN 2 THEN 'Not Visible Photo Library'
        ELSE 'Unknown Value: ' || ZASSET.ZVISIBILITYSTATE || ''
    END AS "052-ZAssetVisibilityState",

    ZEXTATTR.ZCAMERAMAKE AS "053-ZExtAttrCameraMake",
    ZEXTATTR.ZCAMERAMODEL AS "054-ZExtAttrCameraModel",
    ZEXTATTR.ZLENSMODEL AS "055-ZExtAttrLensModel",

    CASE ZEXTATTR.ZFLASHFIRED
        WHEN 0 THEN 'No Flash'
        WHEN 1 THEN 'Flash Fired'
        ELSE 'Unknown Value: ' || ZEXTATTR.ZFLASHFIRED || ''
    END AS "056-ZExtAttrFlashFired",

    ZEXTATTR.ZFOCALLENGTH AS "057-ZExtAttrFocalLength",
    ZEXTATTR.ZFOCALLENGTHIN35MM AS "058-ZExtAttrFocalLengthIn35Mm",
    ZEXTATTR.ZDIGITALZOOMRATIO AS "059-ZExtAttrDigitalZoomRatio",

    CASE ZASSET.ZDERIVEDCAMERACAPTUREDEVICE
        WHEN 0 THEN 'Back Camera/Other'
        WHEN 1 THEN 'Front Camera'
        ELSE 'Unknown Value: ' || ZASSET.ZDERIVEDCAMERACAPTUREDEVICE || ''
    END AS "060-ZAssetDerivedCameraCaptureDevice",

    CASE ZADDASSETATTRS.ZCAMERACAPTUREDEVICE
        WHEN 0 THEN 'Back Camera/Other'
        WHEN 1 THEN 'Front Camera'
        ELSE 'Unknown Value: ' || ZADDASSETATTRS.ZCAMERACAPTUREDEVICE || ''
    END AS "061-ZAddAssetAttrsCameraCaptureDevice",

    CASE ZADDASSETATTRS.ZIMPORTEDBY
        WHEN 0 THEN 'Cloud Other'
        WHEN 1 THEN 'Native Back Camera'
        WHEN 2 THEN 'Native Front Camera'
        WHEN 3 THEN 'Third Party App'
        WHEN 4 THEN 'Still Testing'
        WHEN 5 THEN 'PhotoBooth PL Asset'
        WHEN 6 THEN 'Third Party App'
        WHEN 7 THEN 'iCloud Share Link CMM Asset'
        WHEN 8 THEN 'System Package App'
        WHEN 9 THEN 'Native App'
        WHEN 10 THEN 'Still Testing'
        WHEN 11 THEN 'Still Testing'
        WHEN 12 THEN 'SWY Syndication PL'
        ELSE 'Unknown Value: ' || ZADDASSETATTRS.ZIMPORTEDBY || ''
    END AS "062-ZAddAssetAttrsImportedBy",

    CASE ZCLDMAST.ZIMPORTEDBY
        WHEN 0 THEN 'Cloud Other'
        WHEN 1 THEN 'Native Back Camera'
        WHEN 2 THEN 'Native Front Camera'
        WHEN 3 THEN 'Third Party App'
        WHEN 4 THEN 'Still Testing'
        WHEN 5 THEN 'PhotoBooth PL Asset'
        WHEN 6 THEN 'Third Party App'
        WHEN 7 THEN 'iCloud Share Link CMM Asset'
        WHEN 8 THEN 'System Package App'
        WHEN 9 THEN 'Native App'
        WHEN 10 THEN 'Still Testing'
        WHEN 11 THEN 'Still Testing'
        WHEN 12 THEN 'SWY Syndication PL'
        ELSE 'Unknown Value: ' || ZCLDMAST.ZIMPORTEDBY || ''
    END AS "063-ZCldMastImportedBy",

    ZADDASSETATTRS.ZIMPORTEDBYBUNDLEIDENTIFIER AS "064-ZAddAssetAttrsImportedByBundleIdentifier",
    ZADDASSETATTRS.ZIMPORTEDBYDISPLAYNAME AS "065-ZAddAssetAttrsImportedByDisplayName",
    ZCLDMAST.ZIMPORTEDBYBUNDLEIDENTIFIER AS "066-ZCldMastImportedByBundleIdentifier",
    ZCLDMAST.ZIMPORTEDBYDISPLAYNAME AS "067-ZCldMastImportedByDisplayName",
    -- hex ( ZASSET.ZIMAGEREQUESTHINTS ) AS "068-ZAssetImageRequestHintsHex",

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
        WHEN 12 THEN 'SWY Syndication PL Asset / Auto Displayed in LPL'
        ELSE 'Unknown Value: ' || ZASSET.ZSAVEDASSETTYPE || ''
    END AS "069-ZAssetSavedAssetTypeLpl",

    CASE ZINTRESOU.ZDATASTORECLASSID
        WHEN 0 THEN 'LPL Asset CPL Asset'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Photo Cloud Sharing Asset'
        WHEN 3 THEN 'SWY Syndication Asset'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZDATASTORECLASSID || ''
    END AS "070-ZIntreSouDataStoreClassId",

    CASE ZASSET.ZCLOUDPLACEHOLDERKIND
        WHEN 0 THEN 'Local & Cloud Master Asset'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Still Testing'
        WHEN 3 THEN '.JPG Asset Only PhDa/Thumb/V2'
        WHEN 4 THEN 'LPL .JPG Asset CPL Asset Other Type'
        WHEN 5 THEN 'Asset synced CPL to Device'
        WHEN 6 THEN 'Still Testing'
        WHEN 7 THEN 'LPL poster JPG Asset CPL Asset .MP4'
        WHEN 8 THEN 'LPL .JPG Asset CPL Asset Live Photo .MOV'
        WHEN 9 THEN 'CPL .MP4 Asset Saved to LPL'
        ELSE 'Unknown Value: ' || ZASSET.ZCLOUDPLACEHOLDERKIND || ''
    END AS "071-ZAssetCloudPlaceHolderKind",

    CASE ZINTRESOU.ZLOCALAVAILABILITY
        WHEN -1 THEN 'IR Asset Not Avail Locally'
        WHEN 1 THEN 'IR Asset Avail Locally'
        WHEN -32768 THEN 'IR Asset SWY Linked Asset'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZLOCALAVAILABILITY || ''
    END AS "072-ZIntreSouLocalAvailability",

    CASE ZINTRESOU.ZLOCALAVAILABILITYTARGET
        WHEN 0 THEN 'Still Testing'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZLOCALAVAILABILITYTARGET || ''
    END AS "073-ZIntreSouLocalAvailabilityTarget",

    CASE ZINTRESOU.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'IR Asset Not Synced No IR CloudMastDateCreated'
        WHEN 1 THEN 'IR Asset Pending Upload'
        WHEN 2 THEN 'IR Asset Photo Cloud Share Asset On Local Device'
        WHEN 3 THEN 'IR Asset Synced iCloud'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZCLOUDLOCALSTATE || ''
    END AS "074-ZIntreSouCloudLocalState",

    CASE ZINTRESOU.ZREMOTEAVAILABILITY
        WHEN 0 THEN 'IR Asset Not Avail Remotely'
        WHEN 1 THEN 'IR Asset Avail Remotely'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZREMOTEAVAILABILITY || ''
    END AS "075-ZIntreSouRemoteAvailability",

    CASE ZINTRESOU.ZREMOTEAVAILABILITYTARGET
        WHEN 0 THEN 'Still Testing'
        WHEN 1 THEN 'Still Testing'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZREMOTEAVAILABILITYTARGET || ''
    END AS "076-ZIntreSouRemoteAvailabilityTarget",

    ZINTRESOU.ZTRANSIENTCLOUDMASTER AS "077-ZIntreSouTransientCloudMaster",
    ZINTRESOU.ZSIDECARINDEX AS "078-ZIntreSouSideCarIndex",
    ZINTRESOU.ZFILEID AS "079-ZIntreSouFileId",

    CASE ZINTRESOU.ZVERSION
        WHEN 0 THEN 'IR Asset Standard'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'IR Asset Adjustments Mutation'
        WHEN 3 THEN 'IR Asset No IR Cloud Master Date Created'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZVERSION || ''
    END AS "080-ZIntreSouVersion",

    printf ( '%,d', ZADDASSETATTRS.ZORIGINALFILESIZE ) AS "081-ZAddAssetAttrsOriginalFileSizeBytes",

    CASE ZINTRESOU.ZRESOURCETYPE
        WHEN 0 THEN 'Photo'
        WHEN 1 THEN 'Video'
        WHEN 3 THEN 'Live Photo'
        WHEN 5 THEN 'HEIC with Adjustment Made Prior to Capture'
        WHEN 6 THEN 'Screenshot'
        WHEN 9 THEN 'Alternate Photo 3rd Party App (Still Testing)'
        WHEN 13 THEN 'Movie'
        WHEN 14 THEN 'Wallpaper'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZRESOURCETYPE || ''
    END AS "082-ZIntreSouResourceType",

    -- hex ( ZINTRESOU.ZDATASTOREKEYDATA ) AS "083-ZIntreSouDataStoreKeyDataHex",

    CASE ZINTRESOU.ZDATASTORESUBTYPE
        WHEN 0 THEN 'No Cloud Inter Resource'
        WHEN 1 THEN 'Main Asset Orig Size'
        WHEN 2 THEN 'Photo with Adjustments'
        WHEN 3 THEN '.JPG Large Thumb'
        WHEN 4 THEN '.JPG Med Thumb'
        WHEN 5 THEN '.JPG Small Thumb'
        WHEN 6 THEN 'Video Med Data'
        WHEN 7 THEN 'Video Small Data'
        WHEN 8 THEN '.MP4 Cloud Share'
        WHEN 9 THEN 'Still Testing'
        WHEN 10 THEN '3rd Party App thumb (Still Testing)'
        WHEN 11 THEN 'Still Testing'
        WHEN 12 THEN 'Still Testing'
        WHEN 13 THEN '.PNG Optimized CPL Asset'
        WHEN 14 THEN 'Wallpaper'
        WHEN 15 THEN 'Has Markup and Adjustments'
        WHEN 16 THEN 'Video with Adjustments'
        WHEN 17 THEN 'RAW Photo'
        WHEN 18 THEN 'Live Photo Video Optimized CPL Asset'
        WHEN 19 THEN 'Live Photo with Adjustments'
        WHEN 20 THEN 'Still Testing'
        WHEN 21 THEN '.MOV Optimized HEVC 4K video'
        WHEN 22 THEN 'Adjust Mutation AAE Asset'
        WHEN 23 THEN 'Still Testing'
        WHEN 24 THEN 'Still Testing'
        WHEN 25 THEN 'Still Testing'
        WHEN 26 THEN '.MOV Optimized CPLAsset'
        WHEN 27 THEN 'Still Testing'
        WHEN 28 THEN '.MOV Med HDR Data'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZDATASTORESUBTYPE || ''
    END AS "084-ZIntreSouDataStoreSubType",

    CASE ZINTRESOU.ZCLOUDSOURCETYPE
        WHEN 0 THEN 'N/A'
        WHEN 1 THEN 'Main Asset Orig Size'
        WHEN 2 THEN 'Photo with Adjustments'
        WHEN 3 THEN '.JPG Large Thumb'
        WHEN 4 THEN '.JPG Med Thumb'
        WHEN 5 THEN '.JPG Small Thumb'
        WHEN 6 THEN 'Video Med Data'
        WHEN 7 THEN 'Video Small Data'
        WHEN 8 THEN '.MP4 Cloud Share'
        WHEN 9 THEN 'Still Testing'
        WHEN 10 THEN '3rd Party App thumb (Still Testing)'
        WHEN 11 THEN 'Still Testing'
        WHEN 12 THEN 'Still Testing'
        WHEN 13 THEN '.PNG Optimized CPL Asset'
        WHEN 14 THEN 'Wallpaper'
        WHEN 15 THEN 'Has Markup and Adjustments'
        WHEN 16 THEN 'Video with Adjustments'
        WHEN 17 THEN 'RAW Photo'
        WHEN 18 THEN 'Live Photo Video Optimized CPL Asset'
        WHEN 19 THEN 'Live Photo with Adjustments'
        WHEN 20 THEN 'Still Testing'
        WHEN 21 THEN '.MOV Optimized HEVC 4K video'
        WHEN 22 THEN 'Adjust Mutation AAE Asset'
        WHEN 23 THEN 'Still Testing'
        WHEN 24 THEN 'Still Testing'
        WHEN 25 THEN 'Still Testing'
        WHEN 26 THEN '.MOV Optimized CPLAsset'
        WHEN 27 THEN 'Still Testing'
        WHEN 28 THEN '.MOV Med HDR Data'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZCLOUDSOURCETYPE || ''
    END AS "085-ZIntreSouCloudSourceType",

    ZINTRESOU.ZDATALENGTH AS "086-ZIntreSouDataLength",

    CASE ZINTRESOU.ZRECIPEID
        WHEN 0 THEN 'Orig File Size match Data Length or Optimized'
        WHEN 65737 THEN 'Full .JPG Orig ProRAW DNG'
        WHEN 65739 THEN '.JPG Large Thumb'
        WHEN 65741 THEN 'Various Asset Types or Thumbs'
        WHEN 65743 THEN 'ResouType Photo 5003 or 5005 .JPG Thumb'
        WHEN 65749 THEN 'LocalVideoKeyFrame .JPG Thumb'
        WHEN 65938 THEN 'FullSizeRender Photo or .plist'
        WHEN 131072 THEN 'FullSizeRender Video or .plist'
        WHEN 131077 THEN 'Medium .MOV HEVC 4K'
        WHEN 131079 THEN 'Medium .MP4 Adj Mutation Asset'
        WHEN 131081 THEN 'ResouType Video 5003 or 5005 .JPG Thumb'
        WHEN 131272 THEN 'FullSizeRender Video Live Photo Adj Mutation'
        WHEN 131275 THEN 'Medium .MOV LivePhoto'
        WHEN 131277 THEN 'No IR Asset LivePhoto iCloud Sync Asset'
        WHEN 131475 THEN 'Medium HDR .MOV'
        WHEN 327683 THEN '.JPG Thumb for 3rd Party (Still Testing)'
        WHEN 327687 THEN 'Wallpaper Compute Resource'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZRECIPEID || ''
    END AS "087-ZIntreSouRecipeId",

    CASE ZINTRESOU.ZCLOUDLASTPREFETCHDATE
        WHEN 0 THEN 'N/A'
        ELSE strftime (
            '%F_%H:%M:%f',
            ZINTRESOU.ZCLOUDLASTPREFETCHDATE + 978307200,
            'unixepoch'
        )
    END AS "088-ZIntreSouCloudLastPrefetchDateUtc",

    ZINTRESOU.ZCLOUDPREFETCHCOUNT AS "089-ZIntreSouCloudPrefetchCount",

    strftime (
        '%F_%H:%M:%f',
        ZINTRESOU.ZCLOUDLASTONDEMANDDOWNLOADDATE + 978307200,
        'unixepoch'
    ) AS "090-ZIntreSouCloudLastOnDemandDownloadDateUtc",

    CASE ZINTRESOU.ZUTICONFORMANCEHINT
        WHEN 0 THEN 'N/A, Does Not Conform'
        WHEN 1 THEN 'UT Type Image'
        WHEN 2 THEN 'UT Type Pro Raw Photo'
        WHEN 3 THEN 'UT Type Movie'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZUTICONFORMANCEHINT || ''
    END AS "091-ZIntreSouUtiConformanceHint",

    CASE ZINTRESOU.ZCOMPACTUTI
        WHEN 1 THEN '.JPEG/.THM'
        WHEN 3 THEN '.HEIC'
        WHEN 6 THEN '.PNG'
        WHEN 7 THEN 'Still Testing'
        WHEN 9 THEN '.DNG'
        WHEN 23 THEN '.JPEG/.HEIC/.mov'
        WHEN 24 THEN '.MPEG4'
        WHEN 36 THEN 'Wallpaper'
        WHEN 37 THEN 'Adj/Mutation Data'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZCOMPACTUTI || ''
    END AS "092-ZIntreSouCompactUti",

    ZASSET.ZUNIFORMTYPEIDENTIFIER AS "093-ZAssetUniformTypeIdentifier",
    ZASSET.ZORIGINALCOLORSPACE AS "094-ZAssetOriginalColorSpace",
    ZCLDMAST.ZUNIFORMTYPEIDENTIFIER AS "095-ZCldMastUniformTypeIdentifier",

    CASE ZCLDMAST.ZFULLSIZEJPEGSOURCE
        WHEN 0 THEN 'Cloud Master .JPEG Source Video (Still Testing)'
        WHEN 1 THEN 'Cloud Master .JPEG Source Other (Still Testing)'
        ELSE 'Unknown Value: ' || ZCLDMAST.ZFULLSIZEJPEGSOURCE || ''
    END AS "096-ZCldMastFullSizeJpegSource",

    CASE ZCLDMAST.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'Not Synced with Cloud'
        WHEN 1 THEN 'Pending Upload'
        WHEN 2 THEN 'Still Testing'
        WHEN 3 THEN 'Synced with Cloud'
        ELSE 'Unknown Value: ' || ZCLDMAST.ZCLOUDLOCALSTATE || ''
    END AS "097-ZCldMastCloudLocalState",

    strftime (
        '%F_%H:%M:%f',
        ZCLDMAST.ZIMPORTDATE + 978307200,
        'unixepoch'
    ) AS "098-ZCldMastImportDateUtc",

    ZASSET.ZIMPORTSESSION AS "099-ZAssetImportSession",
    ZADDASSETATTRS.ZIMPORTSESSIONID AS "100-ZAddAssetAttrsImportSessionId",

    strftime (
        '%F_%H:%M:%f',
        ZADDASSETATTRS.ZALTERNATEIMPORTIMAGEDATE + 978307200,
        'unixepoch'
    ) AS "101-ZAddAssetAttrsAlternateImportImageDateUtc",

    ZCLDMAST.ZIMPORTSESSIONID AS "102-ZCldMastImportSessionId",

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZCLOUDBATCHPUBLISHDATE + 978307200,
        'unixepoch'
    ) AS "103-ZAssetCloudBatchPublishDateUtc",

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZCLOUDSERVERPUBLISHDATE + 978307200,
        'unixepoch'
    ) AS "104-ZAssetCloudServerPublishDateUtc",

    ZASSET.ZCLOUDDOWNLOADREQUESTS AS "105-ZAsset.zclouddownloadrequests",
    ZASSET.ZCLOUDBATCHID AS "106-ZAssetCloudBatchId",

    strftime (
        '%F_%H:%M:%f',
        ZADDASSETATTRS.ZLASTUPLOADATTEMPTDATE + 978307200,
        'unixepoch'
    ) AS "107-ZAddAssetAttrsLastUploadAttemptDateSwyUtc",

    ZADDASSETATTRS.ZUPLOADATTEMPTS AS "108-ZAddAssetAttrsUploadAttempts",

    CASE ZASSET.ZLATITUDE
        WHEN -180.0 THEN '[-180.0]'
        ELSE ZASSET.ZLATITUDE
    END AS "109-ZAssetLatitude",

    ZEXTATTR.ZLATITUDE AS "110-ZExtAttrLatitude",

    CASE ZASSET.ZLONGITUDE
        WHEN -180.0 THEN '[-180.0]'
        ELSE ZASSET.ZLONGITUDE
    END AS "111-ZAssetLongitude",

    ZEXTATTR.ZLONGITUDE AS "112-ZExtAttrLongitude",

    CASE ZADDASSETATTRS.ZGPSHORIZONTALACCURACY
        WHEN -1.0 THEN '[-1.0]'
        WHEN NULL THEN NULL
        ELSE ZADDASSETATTRS.ZGPSHORIZONTALACCURACY
    END AS "113-ZAddAssetAttrsGpsHorizontalAccuracy",

    -- hex ( ZASSET.ZLOCATIONDATA ) AS "114-ZAssetLocationDataHex",
    -- ZADDASSETATTRS.ZREVERSELOCATIONDATA AS "115-ZAddAssetAttrsReverseLocationDataHexNSKeyedPlist",

    CASE ZADDASSETATTRS.ZSHIFTEDLOCATIONISVALID
        WHEN 0 THEN 'Not Valid'
        WHEN 1 THEN 'Valid'
    END AS "116-ZAddAssetAttrsShiftedLocationIsValid",

    ZADDASSETATTRS.ZSHIFTEDLOCATIONDATA AS "117-ZAddAssetAttrsShiftedLocationData",
    ZADDASSETATTRS.ZLOCATIONHASH AS "118-ZAddAssetAttrsLocationHash",

    CASE AAAZCLDMASTMedData.Z_OPT
        WHEN 1 THEN 'Cloud (Still Testing)'
        WHEN 2 THEN 'This Device (Still Testing)'
        WHEN 3 THEN 'Muted (Still Testing)'
        WHEN 4 THEN 'Unknown (Still Testing)'
        WHEN 5 THEN 'Unknown (Still Testing)'
        ELSE 'Unknown Value: ' || AAAZCLDMASTMedData.Z_OPT || ''
    END AS "119-AAAZCLDMASTMedDataOpt",

    ZADDASSETATTRS.ZMEDIAMETADATATYPE AS "120-ZAddAssetAttrsMediaMetaDataType",
    -- hex ( AAAZCLDMASTMedData.ZDATA ) AS "121-AAAZCLDMASTMedDataDataHex",

    CASE CMZCLDMASTMedData.Z_OPT
        WHEN 1 THEN 'Has Cloud Master Asset (Still Testing)'
        WHEN 2 THEN 'Local Asset (Still Testing)'
        WHEN 3 THEN 'Muted (Still Testing)'
        WHEN 4 THEN 'Unknown (Still Testing)'
        WHEN 5 THEN 'Unknown (Still Testing)'
        ELSE 'Unknown Value: ' || CMZCLDMASTMedData.Z_OPT || ''
    END AS "122-CldMasterZCLDMASTMedDataOpt",

    ZCLDMAST.ZMEDIAMETADATATYPE AS "123-ZCldMastMediaMetaDataType",
    -- hex ( CMZCLDMASTMedData.ZDATA ) AS "124-CMZCLDMASTMedDataDataHex",

    CASE ZASSET.ZSEARCHINDEXREBUILDSTATE
        WHEN 0 THEN 'Still Testing'
        ELSE 'Unknown Value: ' || ZASSET.ZSEARCHINDEXREBUILDSTATE || ''
    END AS "125-ZAssetSearchIndexRebuildState",

        CASE ZASSET.ZORIENTATION
        WHEN 1 THEN 'Horizontal (Left)'
        WHEN 3 THEN 'Horizontal (Right)'
        WHEN 6 THEN 'Vertical (Up)'
        WHEN 8 THEN 'Vertical (Down)'
        ELSE 'Unknown Value: ' || ZASSET.ZORIENTATION
    END AS "126-ZAssetOrientation",

    CASE ZADDASSETATTRS.ZORIGINALORIENTATION
        WHEN 1 THEN 'Horizontal (Left)'
        WHEN 3 THEN 'Horizontal (Right)'
        WHEN 6 THEN 'Vertical (Up)'
        WHEN 8 THEN 'Vertical (Down)'
        ELSE 'Unknown Value: ' || ZADDASSETATTRS.ZORIGINALORIENTATION
    END AS "127-ZAddAssetAttrsOriginalOrientation",

    CASE ZASSET.ZKIND
        WHEN 0 THEN 'Photo'
        WHEN 1 THEN 'Video'
    END AS "128-ZAssetKind",

    CASE ZASSET.ZKINDSUBTYPE
        WHEN 0 THEN 'Still Photo'
        WHEN 2 THEN 'Live Photo'
        WHEN 10 THEN 'SpringBoard Screenshot'
        WHEN 100 THEN 'Video'
        WHEN 101 THEN 'Slow-Mo Video'
        WHEN 102 THEN 'Time-lapse Video'
        WHEN 103 THEN 'Replay Screen Recording'
        ELSE 'Unknown Value: ' || ZASSET.ZKINDSUBTYPE || ''
    END AS "129-ZAssetKindSubType",

    CASE ZADDASSETATTRS.ZCLOUDKINDSUBTYPE
        WHEN 0 THEN 'Still Photo'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Live Photo'
        WHEN 3 THEN 'Screenshot'
        WHEN 10 THEN 'SpringBoard Screenshot'
        WHEN 100 THEN 'Video'
        WHEN 101 THEN 'Slow-Mo Video'
        WHEN 102 THEN 'Time-lapse Video'
        WHEN 103 THEN 'Replay Screen Recording'
        ELSE 'Unknown Value: ' || ZADDASSETATTRS.ZCLOUDKINDSUBTYPE || ''
    END AS "130-ZAddAssetAttrsCloudKindSubType",

    CASE ZASSET.ZPLAYBACKSTYLE
        WHEN 1 THEN 'Image'
        WHEN 2 THEN 'Image Animated'
        WHEN 3 THEN 'Live Photo'
        WHEN 4 THEN 'Video'
        WHEN 5 THEN 'Video Looping'
        ELSE 'Unknown Value: ' || ZASSET.ZPLAYBACKSTYLE || ''
    END AS "131-ZAssetPlayBackStyle",

    ZASSET.ZPLAYBACKVARIATION AS "132-ZAssetPlayBackVariation",
    ZASSET.ZDURATION AS "133-ZAssetDuration",
    ZEXTATTR.ZDURATION AS "134-ZExtAttrDuration",
    -- Duration of the Live Photo in seconds
    ZASSET.ZVIDEOCPDURATIONVALUE AS "135-ZAssetVideoCpDurationValue",
    ZADDASSETATTRS.ZVIDEOCPDURATIONTIMESCALE AS "136-ZAddAssetAttrsVideoCpDurationTimeScale",
    ZASSET.ZVIDEOCPVISIBILITYSTATE AS "137-ZAssetVideoCpVisibilityState",
    ZADDASSETATTRS.ZVIDEOCPDISPLAYVALUE AS "138-ZAddAssetAttrsVideoCpDisplayValue",
    ZADDASSETATTRS.ZVIDEOCPDISPLAYTIMESCALE AS "139-ZAddAssetAttrsVideoCpDisplayTimeScale",

    -- [ZINTRESOU.ZASSET = ZASSET.Z_PK]
    ZINTRESOU.ZASSET AS "140-ZIntreSouAsset",
    ZINTRESOU.Z_PK AS "141-ZIntreSouZPk",
    ZINTRESOU.Z_ENT AS "142-ZIntreSouEnt",
    ZINTRESOU.Z_OPT AS "143-ZIntreSouOpt",
    ZASSET.ZHDRGAIN AS "144-ZAsset.HdrGain",

    CASE ZASSET.ZHDRTYPE
        WHEN 0 THEN 'No HDR'
        WHEN 3 THEN 'HDR Photo'
        WHEN 4 THEN 'Non HDR Version'
        WHEN 5 THEN 'HEVC Movie'
        WHEN 6 THEN 'Panorama'
        WHEN 10 THEN 'HDR Gain'
        ELSE 'Unknown Value: ' || ZASSET.ZHDRTYPE || ''
    END AS "145-ZAssetHdrType",

    ZEXTATTR.ZCODEC AS "146-ZExtAttrCodec",
    ZINTRESOU.ZCODECFOURCHARCODENAME AS "147-ZIntreSouCodecFourCharCodeName",
    ZCLDMAST.ZCODECNAME AS "148-ZCldMastCodecName",
    ZCLDMAST.ZVIDEOFRAMERATE AS "149-ZCldMastVideoFrameRate",
    ZCLDMAST.ZPLACEHOLDERSTATE AS "150-ZCldMastPlaceHolderState",

    CASE ZASSET.ZDEPTHTYPE
        WHEN 0 THEN 'Not Portrait'
        ELSE 'Portrait: ' || ZASSET.ZDEPTHTYPE || ''
    END AS "151-ZAssetDepthType",

    ZASSET.ZAVALANCHEUUID AS "152-ZAssetAvalancheUuid",

    CASE ZASSET.ZAVALANCHEPICKTYPE
        WHEN 0 THEN 'N/A / Single Asset Burst UUID'
        WHEN 2 THEN 'Burst Asset Not Selected'
        WHEN 4 THEN 'Burst Asset PhotosApp Picked Key Image'
        WHEN 8 THEN 'Burst Asset Selected for LPL'
        WHEN 16 THEN 'Top Burst Asset inStack Key Image'
        WHEN 32 THEN 'Still Testing'
        WHEN 52 THEN 'Burst Asset Visible LPL'
        ELSE 'Unknown Value: ' || ZASSET.ZAVALANCHEPICKTYPE || ''
    END AS "153-ZAssetAvalanchePickType",

    CASE ZADDASSETATTRS.ZCLOUDAVALANCHEPICKTYPE
        WHEN 0 THEN 'N/A / Single Asset Burst UUID'
        WHEN 2 THEN 'Burst Asset Not Selected'
        WHEN 4 THEN 'Burst Asset PhotosApp Picked Key Image'
        WHEN 8 THEN 'Burst Asset Selected for LPL'
        WHEN 16 THEN 'Top Burst Asset inStack Key Image'
        WHEN 32 THEN 'Still Testing'
        WHEN 52 THEN 'Burst Asset Visible LPL'
        ELSE 'Unknown Value: ' || ZADDASSETATTRS.ZCLOUDAVALANCHEPICKTYPE || ''
    END AS "154-ZAddAssetAttrsCloudAvalanchePickType",

    CASE ZADDASSETATTRS.ZCLOUDRECOVERYSTATE
        WHEN 0 THEN 'Still Testing'
        WHEN 1 THEN 'Still Testing'
        ELSE 'Unknown Value: ' || ZADDASSETATTRS.ZCLOUDRECOVERYSTATE || ''
    END AS "155-ZAddAssetAttrsCloudTecoveryState",

    ZADDASSETATTRS.ZCLOUDSTATERECOVERYATTEMPTSCOUNT AS "156-ZAddAssetAttrsCloudStateRecoveryAttemptsCount",
    ZASSET.ZDEFERREDPROCESSINGNEEDED AS "157-ZAssetDeferredProcessingNeeded",
    ZASSET.ZVIDEODEFERREDPROCESSINGNEEDED AS "158-ZAssetVideoDeferredProcessingNeeded",
    ZADDASSETATTRS.ZDEFERREDPHOTOIDENTIFIER AS "159-ZAddAssetAttrsDeferredPhotoIdentifier",
    ZADDASSETATTRS.ZDEFERREDPROCESSINGCANDIDATEOPTIONS AS "160-ZAddAssetAttrsDeferredProcessingCandidateOptions",

    /*
    PERSON IDENTIFICATION SECTION
    */

    ZDETECTEDFACE.Z_PK AS "161-ZDetectedFaceZPk",
    ZDETECTEDFACEPRINT.ZFACE AS "162-ZDetectedFacePrintFace",
    ZFACECROP.ZFACE AS "163-ZFaceCropFace",
    hex ( ZFACECROP.ZRESOURCEDATA ) AS "164-ZFaceCropResourceDataBinary",
    ZPERSON.Z_PK AS "165-ZPersonZPk",
    ZPERSON.ZDISPLAYNAME AS "166-ZPersonDisplayName",
    ZPERSON.ZFULLNAME AS "167-ZPersonFullName",

    CASE ZDETECTEDFACE.ZAGETYPE
        WHEN 1 THEN 'Baby/Toddler'
        WHEN 2 THEN 'Baby/Toddler'
        WHEN 3 THEN 'Child/Young Adult'
        WHEN 4 THEN 'Young Adult/Adult'
        WHEN 5 THEN 'Adult'
        ELSE 'Unknown Value: ' || ZDETECTEDFACE.ZAGETYPE
    END AS "168-ZDetectedFaceAgeType",

    CASE ZDETECTEDFACE.ZGENDERTYPE
        WHEN 1 THEN 'Male'
        WHEN 2 THEN 'Female'
        ELSE 'Unknown Value: ' || ZDETECTEDFACE.ZGENDERTYPE
    END AS "169-ZDetectedFaceGenderType",

    CASE ZDETECTEDFACE.ZETHNICITYTYPE
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Still Testing'
        WHEN 3 THEN 'Still Testing'
        WHEN 4 THEN 'Still Testing'
        WHEN 5 THEN 'Still Testing'
        ELSE 'Unknown Value: ' || ZDETECTEDFACE.ZETHNICITYTYPE
    END AS "170-ZDetectedFaceEthnicityType",

    CASE ZDETECTEDFACE.ZGLASSESTYPE
        WHEN 1 THEN 'Eye'
        WHEN 2 THEN 'Sun'
        WHEN 3 THEN 'None'
        ELSE 'Unknown Value: ' || ZDETECTEDFACE.ZGLASSESTYPE
    END AS "171-ZDetectedFaceGlassesType",

    CASE ZDETECTEDFACE.ZFACIALHAIRTYPE
        WHEN 1 THEN 'None'
        WHEN 2 THEN 'Beard/Mustache'
        WHEN 3 THEN 'Goatee'
        WHEN 5 THEN 'Stubble'
        ELSE 'Unknown Value: ' || ZDETECTEDFACE.ZFACIALHAIRTYPE
    END AS "172-ZDetectedFaceFacialHairType",

    CASE ZDETECTEDFACE.ZHAIRTYPE
        WHEN 2 THEN 'Bald'
        WHEN 3 THEN 'Not Bald'
        ELSE 'Unknown Value: ' || ZDETECTEDFACE.ZHAIRTYPE
    END AS "173-ZDetectedFaceHairType",


    -- [ZUNMANAGEDADJUSTMENT.ZASSETATTRIBUTES = ZADDASSETATTRS.Z_PK]
    ZUNMANAGEDADJUSTMENT.ZASSETATTRIBUTES AS "174-ZUnManagedAdjustmentAssetAttributes",
    -- [ZADDASSETATTRS.ZUNMANAGEDADJUSTMENT = ZUNMANAGEDADJUSTMENT.Z_PK]
    ZADDASSETATTRS.ZUNMANAGEDADJUSTMENT AS "175-ZAddAssetAttrsUnmanagedAdjustment",
    -- [ZUNMANAGEDADJUSTMENT.Z_PK = ZADDASSETATTRS.ZUNMANAGEDADJUSTMENT]
    ZUNMANAGEDADJUSTMENT.Z_PK AS "176-ZUnManagedAdjustmentZPk",
    ZUNMANAGEDADJUSTMENT.ZUUID AS "177-ZUnManagedAdjustmentUuid",

    CASE ZASSET.ZADJUSTMENTSSTATE
        WHEN 0 THEN 'No Adjustments'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Still Testing'
        WHEN 3 THEN 'Still Testing'
        ELSE 'Unknown Value: ' || ZASSET.ZADJUSTMENTSSTATE || ''
    END AS "178-ZAssetAdjustmentsState",

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZADJUSTMENTTIMESTAMP + 978307200,
        'unixepoch'
    ) AS "179-ZAssetAdjustmentTimeStampUtc",

    strftime (
        '%F_%H:%M:%f',
        ZUNMANAGEDADJUSTMENT.ZADJUSTMENTTIMESTAMP + 978307200,
        'unixepoch'
    ) AS "180-ZUnManagedAdjustmentAdjustmentTimeStampUtc",

    ZADDASSETATTRS.ZEDITORBUNDLEID AS "181-ZAddAssetAttrsEditorBundleId",
    ZUNMANAGEDADJUSTMENT.ZEDITORLOCALIZEDNAME AS "182-ZUnManagedAdjustmentEditorLocalizedName",
    ZUNMANAGEDADJUSTMENT.ZADJUSTMENTFORMATIDENTIFIER AS "183-ZUnManagedAdjustmentAdjustmentFormatIdentifier",
    ZADDASSETATTRS.ZMONTAGE AS "184-ZAddAssetAttrsMontage",

    CASE ZUNMANAGEDADJUSTMENT.ZADJUSTMENTRENDERTYPES
        WHEN 0 THEN 'Standard or Portrait with errors'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Portrait'
        WHEN 3 THEN 'Still Testing'
        WHEN 4 THEN 'Still Testing'
        ELSE 'Unknown Value: ' || ZUNMANAGEDADJUSTMENT.ZADJUSTMENTRENDERTYPES || ''
    END AS "185-ZUnManagedAdjustmentAdjustmentRenderTypes",

    CASE ZUNMANAGEDADJUSTMENT.ZADJUSTMENTFORMATVERSION
        WHEN 1.0 THEN 'Markup'
        WHEN 1.1 THEN 'Slow-Mo'
        WHEN 1.2 THEN 'Still Testing'
        WHEN 1.3 THEN 'Still Testing'
        WHEN 1.4 THEN 'Filter'
        WHEN 1.5 THEN 'Adjust'
        WHEN 1.6 THEN 'Video Trim'
        WHEN 1.7 THEN 'Still Testing'
        WHEN 1.8 THEN 'Still Testing'
        WHEN 1.9 THEN 'Still Testing'
        WHEN 2.0 THEN 'Screenshot Services'
        ELSE 'Unknown Value: ' || ZUNMANAGEDADJUSTMENT.ZADJUSTMENTFORMATVERSION || ''
    END AS "186-ZUnManagedAdjustmentAdjustmentFormatVersion",

    ZUNMANAGEDADJUSTMENT.ZADJUSTMENTBASEIMAGEFORMAT AS "187-ZUnManagedAdjustmentAdjustmentBaseImageFormat",
    ZUNMANAGEDADJUSTMENT.ZOTHERADJUSTMENTSFINGERPRINT AS "188-ZUnManagedAdjustmentOtherAdjustmentsFingerprint",
    ZUNMANAGEDADJUSTMENT.ZSIMILARTOORIGINALADJUSTMENTSFINGERPRINT AS "189-ZUnManagedAdjustmentSimilarToOrigAdjFingerprint",

    CASE ZASSET.ZFAVORITE
        WHEN 0 THEN 'Not Favorite'
        WHEN 1 THEN 'Favorite'
    END AS "190-ZAssetFavorite",

    CASE ZASSET.ZHIDDEN
        WHEN 0 THEN 'Not Hidden'
        WHEN 1 THEN 'Hidden'
        ELSE 'Unknown Value: ' || ZASSET.ZHIDDEN || ''
    END AS "191-ZAssetHidden",

    -- (local asset recently deleted)
    CASE ZASSET.ZTRASHEDSTATE
        WHEN 0 THEN 'Not In Trash/Recently Deleted'
        WHEN 1 THEN 'In Trash/Recently Deleted'
        ELSE 'Unknown Value: ' || ZASSET.ZTRASHEDSTATE || ''
    END AS "192-ZAssetTrashedState",

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZTRASHEDDATE + 978307200,
        'unixepoch'
    ) AS "193-ZAssetTrashedDateUtc",

    CASE ZASSET.ZDELETEREASON
        WHEN 1 THEN 'Delete Reason (Still Testing)'
        WHEN 2 THEN 'Delete Reason (Still Testing)'
        WHEN 3 THEN 'Delete Reason (Still Testing)'
        ELSE 'Unknown Value: ' || ZASSET.ZDELETEREASON || ''
    END AS "194-ZAssetDeleteReason",

    CASE ZASSET.ZTRASHEDBYPARTICIPANT
        WHEN 1 THEN 'Trashed/Recently Deleted by Participant'
        ELSE 'Unknown Value: ' || ZASSET.ZTRASHEDBYPARTICIPANT || ''
    END AS "195-ZAssetTrashedByParticipant",

    CASE ZINTRESOU.ZTRASHEDSTATE
        WHEN 0 THEN 'INTRESOU Not In Trash/Recently Deleted'
        WHEN 1 THEN 'INTRESOU In Trash/Recently Deleted'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZTRASHEDSTATE || ''
    END AS "196-ZIntreSouTrashedState",

    strftime (
        '%F_%H:%M:%f',
        ZINTRESOU.ZTRASHEDDATE + 978307200,
        'unixepoch'
    ) AS "197-ZIntreSouTrashedDateUtc",

    CASE ZASSET.ZCLOUDDELETESTATE
        WHEN 0 THEN 'CLOUD Asset Not Deleted'
        WHEN 1 THEN 'CLOUD Asset Deleted'
        ELSE 'Unknown Value: ' || ZASSET.ZCLOUDDELETESTATE || ''
    END AS "198-ZAssetCloudDeleteState",

    CASE ZINTRESOU.ZCLOUDDELETESTATE
        WHEN 0 THEN 'CLOUD IntResou Not Deleted'
        WHEN 1 THEN 'CLOUD IntResou Deleted'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZCLOUDDELETESTATE || ''
    END AS "199-ZIntreSouCloudDeleteState",

    CASE ZADDASSETATTRS.ZPTPTRASHEDSTATE
        WHEN 0 THEN 'PTP Not in Trash'
        WHEN 1 THEN 'PTP In Trash'
        ELSE 'Unknown Value: ' || ZADDASSETATTRS.ZPTPTRASHEDSTATE || ''
    END AS "200-ZAddAssetAttrsPtpTrashedState",

    CASE ZINTRESOU.ZPTPTRASHEDSTATE
        WHEN 0 THEN 'PTP IntResou Not in Trash'
        WHEN 1 THEN 'PTP IntResou In Trash'
        ELSE 'Unknown Value: ' || ZINTRESOU.ZPTPTRASHEDSTATE || ''
    END AS "201-ZIntreSouPtpTrashedState",

    ZINTRESOU.ZCLOUDDELETEASSETUUIDWITHRESOURCETYPE AS "202-ZIntreSouCloudDeleteAssetUuidWithResourceType",

    strftime (
        '%F_%H:%M:%f',
        ZMEDANLYASTATTR.ZMEDIAANALYSISTIMESTAMP + 978307200,
        'unixepoch'
    ) AS "203-ZMediaAnlyastAttrMediaAnalysisTimeStampUtc",

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZANALYSISSTATEMODIFICATIONDATE + 978307200,
        'unixepoch'
    ) AS "204-ZAssetAnalysisStateModificationDateUtc",

    ZADDASSETATTRS.ZVIEWCOUNT AS "205-ZAddAssetAttrsViewCount",
    ZADDASSETATTRS.ZPENDINGVIEWCOUNT AS "206-ZAddAssetAttrsPendingViewCount",
    ZADDASSETATTRS.ZSHARECOUNT AS "207-ZAddAssetAttrsShareCount",
    ZADDASSETATTRS.ZPENDINGSHARECOUNT AS "208-ZAddAssetAttrsPendingShareCount",
    ZADDASSETATTRS.ZPLAYCOUNT AS "209-ZAddAssetAttrsPlayCount",
    ZADDASSETATTRS.ZPENDINGPLAYCOUNT AS "210-ZAddAssetAttrsPendingPlayCount",

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZLASTSHAREDDATE + 978307200,
        'unixepoch'
    ) AS "211-ZAssetLastSharedDateUtc",

    ZADDASSETATTRS.ZSHAREORIGINATOR AS "212-ZAddAssetAttrsShareOriginator",

    CASE ZASSET.ZSYNDICATIONSTATE
        WHEN 0 THEN 'Local PL Asset Syndication State N/A'
        ELSE 'Unknown Value: ' || ZASSET.ZSYNDICATIONSTATE || ''
    END AS "213-ZAssetSyndicationStateLpl",

    ZADDASSETATTRS.ZSYNDICATIONHISTORY AS "214-ZAddAssetAttrsSyndicationHistory",
    ZMEDANLYASTATTR.ZSYNDICATIONPROCESSINGVERSION AS "215-ZMediaAnlyastAttrSyndicationProcessingVersion",

    CASE ZMEDANLYASTATTR.ZSYNDICATIONPROCESSINGVALUE
        WHEN 0 THEN 'N/A'
        WHEN 1 THEN 'Wide Camera JPG (Still Testing)'
        WHEN 2 THEN 'Telephoto Camera Lens (Still Testing)'
        WHEN 4 THEN 'SWY Asset Orig Asset Import System Package App (Still Testing)'
        WHEN 16 THEN 'Still Testing'
        WHEN 1024 THEN 'SWY Asset OrigAssetImport Native Camera (Still Testing)'
        WHEN 2048 THEN 'Still Testing'
        WHEN 4096 THEN 'SWY Asset Manually Saved (Still Testing)'
        ELSE 'Unknown Value: ' || ZMEDANLYASTATTR.ZSYNDICATIONPROCESSINGVALUE || ''
    END AS "216-ZMediaAnlyastAttrSyndicationProcessingValue",

    strftime (
        '%F_%H:%M:%f',
        ZMEDANLYASTATTR.ZVAANALYSISTIMESTAMP + 978307200,
        'unixepoch'
    ) AS "217-ZMediaAnlyastAttrVaAnalysisTimeStampUtc",

    ZMEDANLYASTATTR.ZVAANALYSISVERSION AS "218-ZMediaAnlyastAttrVaAnalysisVersion",

    CASE ZADDASSETATTRS.ZALLOWEDFORANALYSIS
        WHEN 0 THEN 'Asset Not Allowed For Analysis'
        WHEN 1 THEN 'Asset Allowed for Analysis'
        ELSE 'Unknown Value: ' || ZADDASSETATTRS.ZALLOWEDFORANALYSIS || ''
    END AS "219-ZAddAssetAttrsAllowedForAnalysis",

    ZADDASSETATTRS.ZSCENEANALYSISVERSION AS "220-ZAddAssetAttrsSceneAnalysisVersion",

    CASE ZADDASSETATTRS.ZSCENEANALYSISISFROMPREVIEW
        WHEN 0 THEN 'No'
        ELSE 'Unknown Value: ' || ZADDASSETATTRS.ZSCENEANALYSISISFROMPREVIEW || ''
    END AS "221-ZAddAssetAttrsSceneAnalysisIsFromPreview",

    strftime (
        '%F_%H:%M:%f',
        ZADDASSETATTRS.ZSCENEANALYSISTIMESTAMP + 978307200,
        'unixepoch'
    ) AS "222-ZAddAssetAttrsSceneanAlysisTimeStampUtc",

    CASE ZASSET.ZDUPLICATEASSETVISIBILITYSTATE
        WHEN 0 THEN 'No Duplicates'
        WHEN 1 THEN 'Has Duplicate'
        WHEN 2 THEN 'Is a Duplicate'
        ELSE 'Unknown Value: ' || ZASSET.ZDUPLICATEASSETVISIBILITYSTATE || ''
    END AS "223-ZAssetDuplicateAssetVisibilityState",

    CASE ZADDASSETATTRS.ZDESTINATIONASSETCOPYSTATE
        WHEN 0 THEN 'No Copy'
        WHEN 1 THEN 'Has A Copy'
        WHEN 2 THEN 'Has A Copy'
        ELSE 'Unknown Value: ' || ZADDASSETATTRS.ZDESTINATIONASSETCOPYSTATE || ''
    END AS "224-ZAddAssetAttrsDestinationAssetCopyState",

    -- hex ( ZSCENEP.ZDATA ) AS "225-ZScenePDataHexNSKeyedPlist",
    -- hex ( ZSCENEP.ZDUPLICATEMATCHINGDATA ) AS "226-ZScenePDuplicateMatchingDataHexNSKeyedPlist",
    -- hex ( ZSCENEP.ZDUPLICATEMATCHINGALTERNATEDATA ) AS "227-ZScenePDuplicateMatchingAlternateDataHexNSKeyedPlist",
    ZADDASSETATTRS.ZSOURCEASSETFORDUPLICATIONSCOPEIDENTIFIER AS "228-ZAddAssetAttrsSourceAssetForDuplicationScopeIdentifier",
    ZCLDMAST.ZSOURCEMASTERFORDUPLICATIONSCOPEIDENTIFIER AS "229-ZCldMastSourceMasterForDuplicationScopeIdentifier",
    ZADDASSETATTRS.ZSOURCEASSETFORDUPLICATIONIDENTIFIER AS "230-ZAddAssetAttrsSourceAssetForDuplicationIdentifier",
    ZCLDMAST.ZSOURCEMASTERFORDUPLICATIONIDENTIFIER AS "231-ZCldMastSourceMasterForDuplicationIdentifier",
    ZEXTATTR.Z_ENT AS "232-ZExtAttrEnt",
    ZEXTATTR.Z_OPT AS "233-ZExtAttrOpt",
    ZADDASSETATTRS.ZVARIATIONSUGGESTIONSTATES AS "234-ZAddAssetAttrsVariationSuggestionStates",
    ZASSET.ZHIGHFRAMERATESTATE AS "235-ZAssetHighFrameRateState",
    ZASSET.ZVIDEOKEYFRAMETIMESCALE AS "236-ZAssetVideoKeyFrameTimeScale",
    ZASSET.ZVIDEOKEYFRAMEVALUE AS "237-ZAssetVideoKeyFrameValue",
    ZEXTATTR.ZISO AS "238-ZExtAttrIso",
    ZEXTATTR.ZMETERINGMODE AS "239-ZExtAttrMeteringMode",
    ZEXTATTR.ZSAMPLERATE AS "240-ZExtAttrSampleRate",
    ZEXTATTR.ZTRACKFORMAT AS "241-ZExtAttrTrackFormat",
    ZEXTATTR.ZWHITEBALANCE AS "242-ZExtAttrWhiteBalance",
    ZEXTATTR.ZASSET AS "243-ZExtAttrAasset",
    ZEXTATTR.ZAPERTURE AS "244-ZExtAttrAperture",
    ZEXTATTR.ZBITRATE AS "245-ZExtAttrBitRate",
    ZEXTATTR.ZEXPOSUREBIAS AS "246-ZExtAttrExposureBias",
    ZEXTATTR.ZFPS AS "247-ZExtAttrFps",
    ZEXTATTR.ZSHUTTERSPEED AS "248-ZExtAttrShutterSpeed",
    ZEXTATTR.ZSLUSHSCENEBIAS AS "249-ZExtAttrSlushSceneBias",
    ZEXTATTR.ZSLUSHVERSION AS "250-ZExtAttrSlushVersion",
    ZEXTATTR.ZSLUSHPRESET AS "251-ZExtAttrSlushPreset",
    ZEXTATTR.ZSLUSHWARMTHBIAS AS "252-ZExtAttrSlushWarmthBias",
    ZASSET.ZHEIGHT AS "253-ZAssetHeight",
    ZADDASSETATTRS.ZORIGINALHEIGHT AS "254-ZAddAssetAttrsOriginalHeight",
    ZINTRESOU.ZUNORIENTEDHEIGHT AS "255-ZIntreSouUnorienteHheight",
    ZASSET.ZWIDTH AS "256-ZAssetWidth",
    ZADDASSETATTRS.ZORIGINALWIDTH AS "257-AddAssetAttrOriginalWidth",
    ZINTRESOU.ZUNORIENTEDWIDTH AS "258-ZIntreSouUnorientedWidth",
    ZShare.ZTHUMBNAILIMAGEDATA AS "259-ZShareThumbnailImageData",
    ZASSET.ZTHUMBNAILINDEX AS "260-ZAssetThumbnailIndex",
    ZADDASSETATTRS.ZEMBEDDEDTHUMBNAILHEIGHT AS "261-ZAddAssetAttrsEmbeddedThumbnailHeight",
    ZADDASSETATTRS.ZEMBEDDEDTHUMBNAILLENGTH AS "262-ZAddAssetAttrsEmbeddedThumbnailLength",
    ZADDASSETATTRS.ZEMBEDDEDTHUMBNAILOFFSET AS "263-ZAddAssetAttrsEmbeddedThumbnailOffset",
    ZADDASSETATTRS.ZEMBEDDEDTHUMBNAILWIDTH AS "264-ZAddAssetAttrsEmbeddedThumbnailWidth",
    ZASSET.ZPACKEDACCEPTABLECROPRECT AS "265-ZAssetPackedAcceptableCropRect",
    ZASSET.ZPACKEDBADGEATTRIBUTES AS "266-ZAssetPackedBadgeAttributes",
    ZASSET.ZPACKEDPREFERREDCROPRECT AS "267-ZAssetPackedPreferredCropRect",
    ZASSET.ZCURATIONSCORE AS "268-ZAssetCurationScore",
    ZASSET.ZCAMERAPROCESSINGADJUSTMENTSTATE AS "269-ZAssetCameraProcessingAdjustmentState",
    ZASSET.ZDEPTHTYPE AS "270-ZAssetDepthType",
    ZASSET.ZISMAGICCARPET AS "271-ZAssetIsMagicCarpet",
    ZASSET.ZLIBRARYSCOPE AS "272-ZAssetLibraryScope",

    CASE ZASSET.ZLIBRARYSCOPESHARESTATE
        WHEN 0 THEN 'Not Shared (Still Testing)'
        ELSE 'Unknown Value: ' || ZASSET.ZLIBRARYSCOPESHARESTATE || ''
    END AS "273-ZAssetLibraryScopeShareState",

    ZADDASSETATTRS.ZORIGINALRESOURCECHOICE AS "274-ZAddAssetAttrsOriginalResourceChoice",
    ZADDASSETATTRS.ZSPATIALOVERCAPTUREGROUPIDENTIFIER AS "275-ZAddAssetAttrsSpatialOverCaptureGroupIdentifier",
    -- hex ( ZADDASSETATTRS.ZOBJECTSALIENCYRECTSDATA ) AS "276-ZAddAssetAttrsObjectsAlienCyrectsDataHexNSKeyedPlist",
    -- hex ( ZADDASSETATTRS.ZORIGINALHASH ) AS "277-ZAddAssetAttrsOriginalHashHex",
    ZADDASSETATTRS.ZPLACEANNOTATIONDATA AS "278-ZAddAssetAttrsPlaceAnnotationData",
    ZADDASSETATTRS.ZDISTANCEIDENTITY AS "279-ZAddAssetAttrsDistanceIdentity"


FROM ZASSET

    LEFT JOIN ZADDITIONALASSETATTRIBUTES ZADDASSETATTRS ON ZADDASSETATTRS.Z_PK = ZASSET.ZADDITIONALATTRIBUTES
    LEFT JOIN ZEXTENDEDATTRIBUTES ZEXTATTR ON ZEXTATTR.Z_PK = ZASSET.ZEXTENDEDATTRIBUTES
    LEFT JOIN ZINTERNALRESOURCE ZINTRESOU ON ZINTRESOU.ZASSET = ZASSET.Z_PK
    LEFT JOIN ZSCENEPRINT ZSCENEP ON ZSCENEP.Z_PK = ZADDASSETATTRS.ZSCENEPRINT
    LEFT JOIN Z_30ASSETS ON Z_30ASSETS.Z_3ASSETS = ZASSET.Z_PK
    LEFT JOIN ZGENERICALBUM ZGENALBUM ON ZGENALBUM.Z_PK = Z_30ASSETS.Z_30ALBUMS
    LEFT JOIN ZUNMANAGEDADJUSTMENT ON ZADDASSETATTRS.ZUNMANAGEDADJUSTMENT = ZUNMANAGEDADJUSTMENT.Z_PK
    LEFT JOIN Z_29ALBUMLISTS ON Z_29ALBUMLISTS.Z_29ALBUMS = ZGENALBUM.Z_PK
    LEFT JOIN ZALBUMLIST ON ZALBUMLIST.Z_PK = Z_29ALBUMLISTS.Z_2ALBUMLISTS
    LEFT JOIN ZGENERICALBUM ParentZGENALBUM ON ParentZGENALBUM.Z_PK = ZGENALBUM.ZPARENTFOLDER
    LEFT JOIN ZCLOUDMASTER ZCLDMAST ON ZASSET.ZMASTER = ZCLDMAST.Z_PK
    LEFT JOIN ZCLOUDMASTERMEDIAMETADATA AAAZCLDMASTMedData ON AAAZCLDMASTMedData.Z_PK = ZADDASSETATTRS.ZMEDIAMETADATA
    LEFT JOIN ZCLOUDMASTERMEDIAMETADATA CMZCLDMASTMedData ON CMZCLDMASTMedData.Z_PK = ZCLDMAST.ZMEDIAMETADATA
    LEFT JOIN ZMEDIAANALYSISASSETATTRIBUTES ZMEDANLYASTATTR ON ZASSET.ZMEDIAANALYSISATTRIBUTES = ZMEDANLYASTATTR.Z_PK
    LEFT JOIN ZSHARE ON ZShare.Z_PK = ZASSET.ZMOMENTSHARE
    LEFT JOIN ZDETECTEDFACE ON ZASSET.Z_PK = ZDETECTEDFACE.ZASSETFORFACE
    -- LEFT JOIN ZDETECTEDFACE ON ZASSET.Z_PK = ZDETECTEDFACE.ZASSET
    LEFT JOIN ZPERSON ON ZPERSON.Z_PK = ZDETECTEDFACE.ZPERSONFORFACE
	LEFT JOIN ZDETECTEDFACEPRINT ON ZDETECTEDFACEPRINT.ZFACE = ZDETECTEDFACE.Z_PK
	LEFT JOIN ZFACECROP ON ZPERSON.Z_PK = ZFACECROP.ZPERSON


WHERE
    ZASSET.ZFILENAME IS 'IMG_8224.MOV' OR
    ZASSET.ZFILENAME IS 'IMG_8225.MP4' OR
    ZASSET.ZFILENAME IS '3e2cb810d62ecf8e429185a184abe84c' OR
    ZASSET.ZFILENAME IS 'd9cadb7c7196c06cf0eda7b3d2f3c94a' OR
    ZASSET.ZFILENAME IS '6EB3A423-E433-40E8-A03A-5C807423D008.mp4'


ORDER BY ZASSET.ZADDEDDATE
