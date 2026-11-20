/*
[DLU]
    20-Nov-2026
[DATABASE]

[NOTES]
    Modified from original query copied from:
    https://github.com/ScottKjr3347/iOS_Local_PL_Photos.sqlite_Queries
*/

SELECT

    ROW_NUMBER() OVER ( ORDER BY ZASSET.ZADDEDDATE ) AS 001_RowNumber,

    ZASSET.ZDIRECTORY AS 002_ZAssetDirectory,
    ZASSET.ZFILENAME AS 003_ZAssetFileName,
    ZADDASSETATTRS.ZORIGINALFILENAME AS 004_ZAddAssetAttrsOriginalFileName,
    ZCLDMAST.ZORIGINALFILENAME AS 005_ZCldMastOriginalFileName,
    ZADDASSETATTRS.ZSYNDICATIONIDENTIFIER AS 006_ZAddAssetAttrsSyndicationIdentifier,

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZADDEDDATE + 978307200,
        'unixepoch'
    ) AS 007_ZAssetAddedDateUtc,

    ZASSET.ZSORTTOKEN AS 008_ZAssetSortToken,
    ZASSET.ZPROMOTIONSCORE AS 009_ZAssetPromotionScore,

    CASE ZASSET.ZCOMPLETE
        WHEN 1 THEN 'Yes'
        ELSE ZASSET.ZCOMPLETE
    END AS 010_ZAssetComplete,

    ZASSET.Z_PK AS 011_ZAssetZPk,
    ZADDASSETATTRS.Z_PK AS 012_ZAddAssetAttrsZPk,

    -- [ZCLDMAST.Z_PK = ZASSET.Z_MASTER]
    ZCLDMAST.Z_PK AS 013_ZCldMastZPk,

    -- [ZASSET.ZMASTER = ZCLDMAST.Z_PK]
    ZASSET.ZMASTER AS 014_ZAssetMaster,

    -- [ZASSET.EXTDATTR = ZEXTATTR.Z_PK]
    ZASSET.ZEXTENDEDATTRIBUTES AS 015_ZAssetExtendedAttributes,
    ZEXTATTR.Z_PK AS 016_ZExtAttrZPk,

    -- [CMZCLDMASTMEDDATA.ZCLOUDMASTER = ZCLDMAST.Z_PK]
    CMZCLDMASTMedData.ZCLOUDMASTER AS 017_CmZCldMastMedDataCloudMaster,

    -- [ZCLDMAST.ZMEDIAMETADATA = ZCLDMASTMEDDATA.Z_PK]
    ZCLDMAST.ZMEDIAMETADATA AS 018_ZCldMastMediaMetadata,

    -- [CMZCLDMASTMEDDATA.Z_PK = ZADDASSETATTRS&ZCLDMAST.ZMEDIAMETADATA]
    CMZCLDMASTMedData.Z_PK AS 019_CmZCldMastMedDataZPk,

    CMZCLDMASTMedData.Z_ENT AS 020_CmZCldMastMedDataEnt,
    ZASSET.ZUUID AS 021_ZAssetUuid,

    -- This value will be the same on two different devices if the asset was synced via iCloud
    ZASSET.ZCLOUDASSETGUID AS 022_ZAssetCloudAssetGuid,
    ZASSET.ZCLOUDCOLLECTIONGUID AS 023_ZAssetCloudCollectGuid,

    -- This value will be the same on two different devices if the asset was synced via iCloud
    ZCLDMAST.ZCLOUDMASTERGUID AS 024_ZCldMastCloudMasterGuid,
    ZGENALBUM.ZCLOUDGUID AS 025_ZGenAlbumCloudGuid,
    ZShare.ZSCOPEIDENTIFIER AS 026_ZShareScopeIdentifier,
    ZADDASSETATTRS.ZORIGINALASSETSUUID AS 027_ZAddAssetAttrsOriginalAssetsUuid,
    ZADDASSETATTRS.ZPUBLICGLOBALUUID AS 028_ZAddAssetAttrsPublicGlobalUuid,
    ZADDASSETATTRS.ZORIGINATINGASSETIDENTIFIER AS 029_ZAddAssetAttrsOriginatingAssetIdentifier,
    ZCLDMAST.ZORIGINATINGASSETIDENTIFIER AS 030_ZCldMastOriginatingAssetIdentifier,

    CASE ZADDASSETATTRS.ZDATECREATEDSOURCE
        WHEN 0 THEN 'Cloud Asset'
        WHEN 1 THEN 'Local Asset w/ EXIF'
        WHEN 3 THEN 'Local Asset No EXIF'
        ELSE 'UnknownValue: [' || ZADDASSETATTRS.ZDATECREATEDSOURCE || ']'
    END AS 031_ZAddAssetAttrsDateCreatedSource,

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZDATECREATED + 978307200,
        'unixepoch'
    ) AS 032_ZAssetDateCreatedUtc,

    strftime (
        '%F_%H:%M:%f',
        ZCLDMAST.ZCREATIONDATE + 978307200,
        'unixepoch'
    ) AS 033_ZCldMastCreationDateUtc,

    strftime (
        '%F_%H:%M:%f',
        ZINTRESOU.ZCLOUDMASTERDATECREATED + 978307200,
        'unixepoch'
    ) AS 034_ZIntreSouCloudMasterDateCreatedUtc,

    ZADDASSETATTRS.ZTIMEZONENAME AS 035_ZAddAssetAttrsTimeZoneName,
    ZADDASSETATTRS.ZTIMEZONEOFFSET AS 036_ZAddAssetAttrsTimeZoneOffset,
    ZADDASSETATTRS.ZINFERREDTIMEZONEOFFSET AS 037_ZAddAssetAttrsInferredTimeZoneOffset,
    ZADDASSETATTRS.ZEXIFTIMESTAMPSTRING AS 038_ZAddAssetAttrsExifTimeStampString,

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZMODIFICATIONDATE + 978307200,
        'unixepoch'
    ) AS 039_ZAssetModificationDateUtc,

    strftime (
        '%F_%H:%M:%f',
        ZADDASSETATTRS.ZLASTVIEWEDDATE + 978307200,
        'unixepoch'
    ) AS 040_ZAddAssetArrtsLastViewedDateUtc,

    ZINTRESOU.ZFINGERPRINT AS 041_ZInterSouFingerprint,

    CASE ParentZGENALBUM.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'iCloud Photos ON = Asset In Shared/Other Album | iCloud Photos OFF = Generic Album'
        WHEN 1 THEN 'iCloud Photos ON = Asset In Generic Album'
        ELSE 'UnknownValue: [' || ParentZGENALBUM.ZCLOUDLOCALSTATE || ']'
    END AS 042_ParentGenAlbumCloudLocalState,

    ParentZGENALBUM.ZTITLE AS 043_ParentGenAlbumTitle,

    strftime (
        '%F_%H:%M:%f',
        ParentZGENALBUM.ZCREATIONDATE + 978307200,
        'unixepoch'
    ) AS 044_ParentGenAlbumCreationDateUtc,

    strftime (
        '%F_%H:%M:%f',
        ZGENALBUM.ZCREATIONDATE + 978307200,
        'unixepoch'
    ) AS 045_ZGenAlbumCreationDateUtc,

    CASE ZGENALBUM.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'iCloud Photos ON = Asset In Shared/Other Album | iCloud Photos OFF = Generic Album'
        WHEN 1 THEN 'iCloud Photos ON = Asset In Generic Album'
        ELSE 'UnknownValue: [' || ZGENALBUM.ZCLOUDLOCALSTATE || ']'
    END AS 046_ZGenAlbumCloudLocalState,

    ZGENALBUM.ZTITLE AS 047_ZGenAlbumTitle,

    CASE ZASSET.ZBUNDLESCOPE
        WHEN 0 THEN 'iCloud Photos ON (Not In Shared Album) | iCloud Photos OFF (On Local Device)'
        WHEN 1 THEN 'SWY Syndication CMMAsset'
        WHEN 2 THEN 'iCloud Photos ON (Asset In Cloud Shared Album)'
        WHEN 3 THEN 'iCloud Photos ON (SWY Syndication-Asset)'
        ELSE 'UnknownValue: [' || ZASSET.ZBUNDLESCOPE || ']'
    END AS 048_ZAssetBundleScope,

    CASE ZASSET.ZCLOUDISMYASSET
        WHEN 0 THEN 'Not My Asset in Shared Album'
        WHEN 1 THEN 'My Asset in Shared Album'
        ELSE 'UnknownValue: [' || ZASSET.ZCLOUDISMYASSET || ']'
    END AS 049_ZAssetCloudIsMyAsset,

    CASE ZASSET.ZCLOUDISDELETABLE
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'UnknownValue: [' || ZASSET.ZCLOUDISDELETABLE || ']'
    END AS 050_ZAssetCloudIsDeletable,

    CASE ZASSET.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'iCloud Photos ON = Asset In Shared or Other Album) | iCloud Photos OFF = Not Synced'
        WHEN 1 THEN 'iCloud Photos ON = Asset Can Be or Has Been Synced with iCloud'
        ELSE 'UnknownValue: [' || ZASSET.ZCLOUDLOCALSTATE || ']'
    END AS 051_ZAssetCloudLocalState,

    -- Indicates whether assets are visible within the Local Photo Library
    CASE ZASSET.ZVISIBILITYSTATE
        WHEN 0 THEN 'Visible Photo Library'
        WHEN 2 THEN 'Not Visible Photo Library'
        ELSE 'UnknownValue: [' || ZASSET.ZVISIBILITYSTATE || ']'
    END AS 052_ZAssetVisibilityState,

    ZEXTATTR.ZCAMERAMAKE AS 053_ZExtAttrCameraMake,
    ZEXTATTR.ZCAMERAMODEL AS 054_ZExtAttrCameraModel,
    ZEXTATTR.ZLENSMODEL AS 055_ZExtAttrLensModel,

    CASE ZEXTATTR.ZFLASHFIRED
        WHEN 0 THEN 'No Flash'
        WHEN 1 THEN 'Flash Fired'
        ELSE 'UnknownValue: [' || ZEXTATTR.ZFLASHFIRED || ']'
    END AS 056_ZExtAttrFlashFired,

    ZEXTATTR.ZFOCALLENGTH AS 057_ZExtAttrFocalLength,
    ZEXTATTR.ZFOCALLENGTHIN35MM AS 058_ZExtAttrFocalLengthIn35Mm,
    ZEXTATTR.ZDIGITALZOOMRATIO AS 059_ZExtAttrDigitalZoomRatio,

    CASE ZASSET.ZDERIVEDCAMERACAPTUREDEVICE
        WHEN 0 THEN 'Back Camera/Other'
        WHEN 1 THEN 'Front Camera'
        ELSE 'UnknownValue: [' || ZASSET.ZDERIVEDCAMERACAPTUREDEVICE || ']'
    END AS 060_ZAssetDerivedCameraCaptureDevice,

    CASE ZADDASSETATTRS.ZCAMERACAPTUREDEVICE
        WHEN 0 THEN 'Back Camera/Other'
        WHEN 1 THEN 'Front Camera'
        ELSE 'UnknownValue: [' || ZADDASSETATTRS.ZCAMERACAPTUREDEVICE || ']'
    END AS 061_ZAddAssetAttrsCameraCaptureDevice,

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
        ELSE 'UnknownValue: [' || ZADDASSETATTRS.ZIMPORTEDBY || ']'
    END AS 062_ZAddAssetAttrsImportedBy,

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
        ELSE 'UnknownValue: [' || ZCLDMAST.ZIMPORTEDBY || ']'
    END AS 063_ZCldMastImportedBy,

    ZADDASSETATTRS.ZIMPORTEDBYBUNDLEIDENTIFIER AS 064_ZAddAssetAttrsImportedByBundleIdentifier,
    ZADDASSETATTRS.ZIMPORTEDBYDISPLAYNAME AS 065_ZAddAssetAttrsImportedByDisplayName,
    ZCLDMAST.ZIMPORTEDBYBUNDLEIDENTIFIER AS 066_ZCldMastImportedByBundleIdentifier,
    ZCLDMAST.ZIMPORTEDBYDISPLAYNAME AS 067_ZCldMastImportedByDisplayName,
    -- hex ( ZASSET.ZIMAGEREQUESTHINTS ) AS 068_ZAssetImageRequestHintsHex,

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
        ELSE 'UnknownValue: [' || ZASSET.ZSAVEDASSETTYPE || ']'
    END AS 069_ZAssetSavedAssetTypeLpl,

    CASE ZINTRESOU.ZDATASTORECLASSID
        WHEN 0 THEN 'LPL Asset CPL Asset'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Photo Cloud Sharing Asset'
        WHEN 3 THEN 'SWY Syndication Asset'
        ELSE 'UnknownValue: [' || ZINTRESOU.ZDATASTORECLASSID || ']'
    END AS 070_ZIntreSouDataStoreClassId,

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
        ELSE 'UnknownValue: [' || ZASSET.ZCLOUDPLACEHOLDERKIND || ']'
    END AS 071_ZAssetCloudPlaceHolderKind,

    CASE ZINTRESOU.ZLOCALAVAILABILITY
        WHEN -1 THEN 'IR Asset Not Avail Locally'
        WHEN 1 THEN 'IR Asset Avail Locally'
        WHEN -32768 THEN 'IR Asset SWY Linked Asset'
        ELSE 'UnknownValue: [' || ZINTRESOU.ZLOCALAVAILABILITY || ']'
    END AS 072_ZIntreSouLocalAvailability,

    CASE ZINTRESOU.ZLOCALAVAILABILITYTARGET
        WHEN 0 THEN 'Still Testing'
        ELSE 'UnknownValue: [' || ZINTRESOU.ZLOCALAVAILABILITYTARGET || ']'
    END AS 073_ZIntreSouLocalAvailabilityTarget,

    CASE ZINTRESOU.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'IR Asset Not Synced No IR CloudMastDateCreated'
        WHEN 1 THEN 'IR Asset Pending Upload'
        WHEN 2 THEN 'IR Asset Photo Cloud Share Asset On Local Device'
        WHEN 3 THEN 'IR Asset Synced iCloud'
        ELSE 'UnknownValue: [' || ZINTRESOU.ZCLOUDLOCALSTATE || ']'
    END AS 074_ZIntreSouCloudLocalState,

    CASE ZINTRESOU.ZREMOTEAVAILABILITY
        WHEN 0 THEN 'IR Asset Not Avail Remotely'
        WHEN 1 THEN 'IR Asset Avail Remotely'
        ELSE 'UnknownValue: [' || ZINTRESOU.ZREMOTEAVAILABILITY || ']'
    END AS 075_ZIntreSouRemoteAvailability,

    CASE ZINTRESOU.ZREMOTEAVAILABILITYTARGET
        WHEN 0 THEN 'Still Testing'
        WHEN 1 THEN 'Still Testing'
        ELSE 'UnknownValue: [' || ZINTRESOU.ZREMOTEAVAILABILITYTARGET || ']'
    END AS 076_ZIntreSouRemoteAvailabilityTarget,

    ZINTRESOU.ZTRANSIENTCLOUDMASTER AS 077_ZIntreSouTransientCloudMaster,
    ZINTRESOU.ZSIDECARINDEX AS 078_ZIntreSouSideCarIndex,
    ZINTRESOU.ZFILEID AS 079_ZIntreSouFileId,

    CASE ZINTRESOU.ZVERSION
        WHEN 0 THEN 'IR Asset Standard'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'IR Asset Adjustments Mutation'
        WHEN 3 THEN 'IR Asset No IR Cloud Master Date Created'
        ELSE 'UnknownValue: [' || ZINTRESOU.ZVERSION || ']'
    END AS 080_ZIntreSouVersion,

    printf ( '%,d', ZADDASSETATTRS.ZORIGINALFILESIZE ) AS 081_ZAddAssetAttrsOriginalFileSizeBytes,

    CASE ZINTRESOU.ZRESOURCETYPE
        WHEN 0 THEN 'Photo'
        WHEN 1 THEN 'Video'
        WHEN 3 THEN 'Live Photo'
        WHEN 5 THEN 'HEIC with Adjustment Made Prior to Capture'
        WHEN 6 THEN 'Screenshot'
        WHEN 9 THEN 'Alternate Photo 3rd Party App (Still Testing)'
        WHEN 13 THEN 'Movie'
        WHEN 14 THEN 'Wallpaper'
        ELSE 'UnknownValue: [' || ZINTRESOU.ZRESOURCETYPE || ']'
    END AS 082_ZIntreSouResourceType,

    -- hex ( ZINTRESOU.ZDATASTOREKEYDATA ) AS 083_ZIntreSouDataStoreKeyDataHex,

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
        ELSE 'UnknownValue: [' || ZINTRESOU.ZDATASTORESUBTYPE || ']'
    END AS 084_ZIntreSouDataStoreSubType,

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
        ELSE 'UnknownValue: [' || ZINTRESOU.ZCLOUDSOURCETYPE || ']'
    END AS 085_ZIntreSouCloudSourceType,

    ZINTRESOU.ZDATALENGTH AS 086_ZIntreSouDataLength,

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
        ELSE 'UnknownValue: [' || ZINTRESOU.ZRECIPEID || ']'
    END AS 087_ZIntreSouRecipeId,

    strftime (
        '%F_%H:%M:%f',
        ZINTRESOU.ZCLOUDLASTPREFETCHDATE + 978307200,
        'unixepoch'
    ) AS 088_ZIntreSouCloudLastPrefetchDateUtc,

    ZINTRESOU.ZCLOUDPREFETCHCOUNT AS 089_ZIntreSouCloudPrefetchCount,

    strftime (
        '%F_%H:%M:%f',
        ZINTRESOU.ZCLOUDLASTONDEMANDDOWNLOADDATE + 978307200,
        'unixepoch'
    ) AS 090_ZIntreSouCloudLastOnDemandDownloadDateUtc,

    CASE ZINTRESOU.ZUTICONFORMANCEHINT
        WHEN 0 THEN 'N/A, Does Not Conform'
        WHEN 1 THEN 'UT Type Image'
        WHEN 2 THEN 'UT Type Pro Raw Photo'
        WHEN 3 THEN 'UT Type Movie'
        ELSE 'UnknownValue: [' || ZINTRESOU.ZUTICONFORMANCEHINT || ']'
    END AS 091_ZIntreSouUtiConformanceHint,

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
        ELSE 'UnknownValue: [' || ZINTRESOU.ZCOMPACTUTI || ']'
    END AS 092_ZIntreSouCompactUti,

    ZASSET.ZUNIFORMTYPEIDENTIFIER AS 093_ZAssetUniformTypeIdentifier,
    ZASSET.ZORIGINALCOLORSPACE AS 094_ZAssetOriginalColorSpace,
    ZCLDMAST.ZUNIFORMTYPEIDENTIFIER AS 095_ZCldMastUniformTypeIdentifier,

    CASE ZCLDMAST.ZFULLSIZEJPEGSOURCE
        WHEN 0 THEN 'Cloud Master .JPEG Source Video (Still Testing)'
        WHEN 1 THEN 'Cloud Master .JPEG Source Other (Still Testing)'
        ELSE 'UnknownValue: [' || ZCLDMAST.ZFULLSIZEJPEGSOURCE || ']'
    END AS 096_ZCldMastFullSizeJpegSource,

    CASE ZCLDMAST.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'Not Synced with Cloud'
        WHEN 1 THEN 'Pending Upload'
        WHEN 2 THEN 'Still Testing'
        WHEN 3 THEN 'Synced with Cloud'
        ELSE 'UnknownValue: [' || ZCLDMAST.ZCLOUDLOCALSTATE || ']'
    END AS 097_ZCldMastCloudLocalState,

    strftime (
        '%F_%H:%M:%f',
        ZCLDMAST.ZIMPORTDATE + 978307200,
        'unixepoch'
    ) AS 098_ZCldMastImportDateUtc,

    ZASSET.ZIMPORTSESSION AS 099_ZAssetImportSession,
    ZADDASSETATTRS.ZIMPORTSESSIONID AS 100_ZAddAssetAttrsImportSessionId,

    strftime (
        '%F_%H:%M:%f',
        ZADDASSETATTRS.ZALTERNATEIMPORTIMAGEDATE + 978307200,
        'unixepoch'
    ) AS 101_ZAddAssetAttrsAlternateImportImageDateUtc,

    ZCLDMAST.ZIMPORTSESSIONID AS 102_ZCldMastImportSessionId,

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZCLOUDBATCHPUBLISHDATE + 978307200,
        'unixepoch'
    ) AS 103_ZAssetCloudBatchPublishDateUtc,

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZCLOUDSERVERPUBLISHDATE + 978307200,
        'unixepoch'
    ) AS 104_ZAssetCloudServerPublishDateUtc,

    ZASSET.ZCLOUDDOWNLOADREQUESTS AS 105_ZAsset.zclouddownloadrequests,
    ZASSET.ZCLOUDBATCHID AS 106_ZAssetCloudBatchId,

    strftime (
        '%F_%H:%M:%f',
        ZADDASSETATTRS.ZLASTUPLOADATTEMPTDATE + 978307200,
        'unixepoch'
    ) AS 107_ZAddAssetAttrsLastUploadAttemptDateSwyUtc,

    ZADDASSETATTRS.ZUPLOADATTEMPTS AS 108_ZAddAssetAttrsUploadAttempts,

    CASE ZASSET.ZLATITUDE
        WHEN -180.0 THEN '[-180.0]'
        ELSE ZASSET.ZLATITUDE
    END AS 109_ZAssetLatitude,

    ZEXTATTR.ZLATITUDE AS 110_ZExtAttrLatitude,

    CASE ZASSET.ZLONGITUDE
        WHEN -180.0 THEN '[-180.0]'
        ELSE ZASSET.ZLONGITUDE
    END AS 111_ZAssetLongitude,

    ZEXTATTR.ZLONGITUDE AS 112_ZExtAttrLongitude,

    CASE ZADDASSETATTRS.ZGPSHORIZONTALACCURACY
        WHEN -1.0 THEN '[-1.0]'
        WHEN NULL THEN NULL
        ELSE ZADDASSETATTRS.ZGPSHORIZONTALACCURACY
    END AS 113_ZAddAssetAttrsGpsHorizontalAccuracy,

    -- hex ( ZASSET.ZLOCATIONDATA ) AS 114_ZAssetLocationDataHex,
    -- ZADDASSETATTRS.ZREVERSELOCATIONDATA AS 115_ZAddAssetAttrsReverseLocationDataHexNSKeyedPlist,

    CASE ZADDASSETATTRS.ZSHIFTEDLOCATIONISVALID
        WHEN 0 THEN 'Not Valid'
        WHEN 1 THEN 'Valid'
        ELSE 'UnknownValue: [' || ZADDASSETATTRS.ZSHIFTEDLOCATIONISVALID || ']'
    END AS 116_ZAddAssetAttrsShiftedLocationIsValid,

    ZADDASSETATTRS.ZSHIFTEDLOCATIONDATA AS 117_ZAddAssetAttrsShiftedLocationData,
    ZADDASSETATTRS.ZLOCATIONHASH AS 118_ZAddAssetAttrsLocationHash,

    CASE AAAZCLDMASTMedData.Z_OPT
        WHEN 1 THEN 'Cloud (Still Testing)'
        WHEN 2 THEN 'This Device (Still Testing)'
        WHEN 3 THEN 'Muted (Still Testing)'
        WHEN 4 THEN 'Unknown (Still Testing)'
        WHEN 5 THEN 'Unknown (Still Testing)'
        ELSE 'UnknownValue: [' || AAAZCLDMASTMedData.Z_OPT || ']'
    END AS 119_AAAZCLDMASTMedDataOpt,

    ZADDASSETATTRS.ZMEDIAMETADATATYPE AS 120_ZAddAssetAttrsMediaMetaDataType,
    -- hex ( AAAZCLDMASTMedData.ZDATA ) AS 121_AAAZCLDMASTMedDataDataHex,

    CASE CMZCLDMASTMedData.Z_OPT
        WHEN 1 THEN 'Has Cloud Master Asset (Still Testing)'
        WHEN 2 THEN 'Local Asset (Still Testing)'
        WHEN 3 THEN 'Muted (Still Testing)'
        WHEN 4 THEN 'Unknown (Still Testing)'
        WHEN 5 THEN 'Unknown (Still Testing)'
        ELSE 'UnknownValue: [' || CMZCLDMASTMedData.Z_OPT || ']'
    END AS 122_CldMasterZCLDMASTMedDataOpt,

    ZCLDMAST.ZMEDIAMETADATATYPE AS 123_ZCldMastMediaMetaDataType,
    -- hex ( CMZCLDMASTMedData.ZDATA ) AS 124_CMZCLDMASTMedDataDataHex,

    CASE ZASSET.ZSEARCHINDEXREBUILDSTATE
        WHEN 0 THEN 'Still Testing'
        ELSE 'UnknownValue: [' || ZASSET.ZSEARCHINDEXREBUILDSTATE || ']'
    END AS 125_ZAssetSearchIndexRebuildState,

        CASE ZASSET.ZORIENTATION
        WHEN 1 THEN 'Horizontal (Left)'
        WHEN 3 THEN 'Horizontal (Right)'
        WHEN 6 THEN 'Vertical (Up)'
        WHEN 8 THEN 'Vertical (Down)'
        ELSE 'UnknownValue: [' || ZASSET.ZORIENTATION || ']'
    END AS 126_ZAssetOrientation,

    CASE ZADDASSETATTRS.ZORIGINALORIENTATION
        WHEN 1 THEN 'Horizontal (Left)'
        WHEN 3 THEN 'Horizontal (Right)'
        WHEN 6 THEN 'Vertical (Up)'
        WHEN 8 THEN 'Vertical (Down)'
        ELSE 'UnknownValue: [' || ZADDASSETATTRS.ZORIGINALORIENTATION || ']'
    END AS 127_ZAddAssetAttrsOriginalOrientation,

    CASE ZASSET.ZKIND
        WHEN 0 THEN 'Photo'
        WHEN 1 THEN 'Video'
        ELSE 'UnknownValue: [' || ZASSET.ZKIND || ']'
    END AS 128_ZAssetKind,

    CASE ZASSET.ZKINDSUBTYPE
        WHEN 0 THEN 'Still Photo'
        WHEN 2 THEN 'Live Photo'
        WHEN 10 THEN 'SpringBoard Screenshot'
        WHEN 100 THEN 'Video'
        WHEN 101 THEN 'Slow-Mo Video'
        WHEN 102 THEN 'Time-lapse Video'
        WHEN 103 THEN 'Replay Screen Recording'
        ELSE 'UnknownValue: [' || ZASSET.ZKINDSUBTYPE || ']'
    END AS 129_ZAssetKindSubType,

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
        ELSE 'UnknownValue: [' || ZADDASSETATTRS.ZCLOUDKINDSUBTYPE || ']'
    END AS 130_ZAddAssetAttrsCloudKindSubType,

    CASE ZASSET.ZPLAYBACKSTYLE
        WHEN 1 THEN 'Image'
        WHEN 2 THEN 'Image Animated'
        WHEN 3 THEN 'Live Photo'
        WHEN 4 THEN 'Video'
        WHEN 5 THEN 'Video Looping'
        ELSE 'UnknownValue: [' || ZASSET.ZPLAYBACKSTYLE || ']'
    END AS 131_ZAssetPlayBackStyle,

    ZASSET.ZPLAYBACKVARIATION AS 132_ZAssetPlayBackVariation,
    ZASSET.ZDURATION AS 133_ZAssetDuration,
    ZEXTATTR.ZDURATION AS 134_ZExtAttrDuration,
    -- Duration of the Live Photo in seconds
    ZASSET.ZVIDEOCPDURATIONVALUE AS 135_ZAssetVideoCpDurationValue,
    ZADDASSETATTRS.ZVIDEOCPDURATIONTIMESCALE AS 136_ZAddAssetAttrsVideoCpDurationTimeScale,
    ZASSET.ZVIDEOCPVISIBILITYSTATE AS 137_ZAssetVideoCpVisibilityState,
    ZADDASSETATTRS.ZVIDEOCPDISPLAYVALUE AS 138_ZAddAssetAttrsVideoCpDisplayValue,
    ZADDASSETATTRS.ZVIDEOCPDISPLAYTIMESCALE AS 139_ZAddAssetAttrsVideoCpDisplayTimeScale,

    -- [ZINTRESOU.ZASSET = ZASSET.Z_PK]
    ZINTRESOU.ZASSET AS 140_ZIntreSouAsset,
    ZINTRESOU.Z_PK AS 141_ZIntreSouZPk,
    ZINTRESOU.Z_ENT AS 142_ZIntreSouEnt,
    ZINTRESOU.Z_OPT AS 143_ZIntreSouOpt,
    ZASSET.ZHDRGAIN AS 144_ZAsset.HdrGain,

    CASE ZASSET.ZHDRTYPE
        WHEN 0 THEN 'No HDR'
        WHEN 3 THEN 'HDR Photo'
        WHEN 4 THEN 'Non HDR Version'
        WHEN 5 THEN 'HEVC Movie'
        WHEN 6 THEN 'Panorama'
        WHEN 10 THEN 'HDR Gain'
        ELSE 'UnknownValue: [' || ZASSET.ZHDRTYPE || ']'
    END AS 145_ZAssetHdrType,

    ZEXTATTR.ZCODEC AS 146_ZExtAttrCodec,
    ZINTRESOU.ZCODECFOURCHARCODENAME AS 147_ZIntreSouCodecFourCharCodeName,
    ZCLDMAST.ZCODECNAME AS 148_ZCldMastCodecName,
    ZCLDMAST.ZVIDEOFRAMERATE AS 149_ZCldMastVideoFrameRate,
    ZCLDMAST.ZPLACEHOLDERSTATE AS 150_ZCldMastPlaceHolderState,

    CASE ZASSET.ZDEPTHTYPE
        WHEN 0 THEN 'Not Portrait'
        ELSE 'Portrait'
    END AS 151_ZAssetDepthType,

    ZASSET.ZAVALANCHEUUID AS 152_ZAssetAvalancheUuid,

    CASE ZASSET.ZAVALANCHEPICKTYPE
        WHEN 0 THEN 'N/A / Single Asset Burst UUID'
        WHEN 2 THEN 'Burst Asset Not Selected'
        WHEN 4 THEN 'Burst Asset PhotosApp Picked Key Image'
        WHEN 8 THEN 'Burst Asset Selected for LPL'
        WHEN 16 THEN 'Top Burst Asset inStack Key Image'
        WHEN 32 THEN 'Still Testing'
        WHEN 52 THEN 'Burst Asset Visible LPL'
        ELSE 'UnknownValue: [' || ZASSET.ZAVALANCHEPICKTYPE || ']'
    END AS 153_ZAssetAvalanchePickType,

    CASE ZADDASSETATTRS.ZCLOUDAVALANCHEPICKTYPE
        WHEN 0 THEN 'N/A / Single Asset Burst UUID'
        WHEN 2 THEN 'Burst Asset Not Selected'
        WHEN 4 THEN 'Burst Asset PhotosApp Picked Key Image'
        WHEN 8 THEN 'Burst Asset Selected for LPL'
        WHEN 16 THEN 'Top Burst Asset inStack Key Image'
        WHEN 32 THEN 'Still Testing'
        WHEN 52 THEN 'Burst Asset Visible LPL'
        ELSE 'UnknownValue: [' || ZADDASSETATTRS.ZCLOUDAVALANCHEPICKTYPE || ']'
    END AS 154_ZAddAssetAttrsCloudAvalanchePickType,

    CASE ZADDASSETATTRS.ZCLOUDRECOVERYSTATE
        WHEN 0 THEN 'Still Testing'
        WHEN 1 THEN 'Still Testing'
        ELSE 'UnknownValue: [' || ZADDASSETATTRS.ZCLOUDRECOVERYSTATE || ']'
    END AS 155_ZAddAssetAttrsCloudTecoveryState,

    ZADDASSETATTRS.ZCLOUDSTATERECOVERYATTEMPTSCOUNT AS 156_ZAddAssetAttrsCloudStateRecoveryAttemptsCount,
    ZASSET.ZDEFERREDPROCESSINGNEEDED AS 157_ZAssetDeferredProcessingNeeded,
    ZASSET.ZVIDEODEFERREDPROCESSINGNEEDED AS 158_ZAssetVideoDeferredProcessingNeeded,
    ZADDASSETATTRS.ZDEFERREDPHOTOIDENTIFIER AS 159_ZAddAssetAttrsDeferredPhotoIdentifier,
    ZADDASSETATTRS.ZDEFERREDPROCESSINGCANDIDATEOPTIONS AS 160_ZAddAssetAttrsDeferredProcessingCandidateOptions,

    /*
    PERSON IDENTIFICATION SECTION
    */

    ZDETECTEDFACE.Z_PK AS 161_ZDetectedFaceZPk,
    ZDETECTEDFACEPRINT.ZFACE AS 162_ZDetectedFacePrintFace,
    ZFACECROP.ZFACE AS 163_ZFaceCropFace,
    hex ( ZFACECROP.ZRESOURCEDATA ) AS 164_ZFaceCropResourceDataHex,
    ZPERSON.Z_PK AS 165_ZPersonZPk,
    ZPERSON.ZDISPLAYNAME AS 166_ZPersonDisplayName,
    ZPERSON.ZFULLNAME AS 167_ZPersonFullName,

    CASE ZDETECTEDFACE.ZAGETYPE
        WHEN 1 THEN 'Baby/Toddler'
        WHEN 2 THEN 'Baby/Toddler'
        WHEN 3 THEN 'Child/Young Adult'
        WHEN 4 THEN 'Young Adult/Adult'
        WHEN 5 THEN 'Adult'
        ELSE 'UnknownValue: [' || ZDETECTEDFACE.ZAGETYPE || ']'
    END AS 168_ZDetectedFaceAgeType,

    CASE ZDETECTEDFACE.ZGENDERTYPE
        WHEN 1 THEN 'Male'
        WHEN 2 THEN 'Female'
        ELSE 'UnknownValue: [' || ZDETECTEDFACE.ZGENDERTYPE || ']'
    END AS 169_ZDetectedFaceGenderType,

    CASE ZDETECTEDFACE.ZETHNICITYTYPE
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Still Testing'
        WHEN 3 THEN 'Still Testing'
        WHEN 4 THEN 'Still Testing'
        WHEN 5 THEN 'Still Testing'
        ELSE 'UnknownValue: [' || ZDETECTEDFACE.ZETHNICITYTYPE || ']'
    END AS 170_ZDetectedFaceEthnicityType,

    CASE ZDETECTEDFACE.ZGLASSESTYPE
        WHEN 1 THEN 'Eye'
        WHEN 2 THEN 'Sun'
        WHEN 3 THEN 'None'
        ELSE 'UnknownValue: [' || ZDETECTEDFACE.ZGLASSESTYPE || ']'
    END AS 171_ZDetectedFaceGlassesType,

    CASE ZDETECTEDFACE.ZFACIALHAIRTYPE
        WHEN 1 THEN 'None'
        WHEN 2 THEN 'Beard/Mustache'
        WHEN 3 THEN 'Goatee'
        WHEN 5 THEN 'Stubble'
        ELSE 'UnknownValue: [' || ZDETECTEDFACE.ZFACIALHAIRTYPE || ']'
    END AS 172_ZDetectedFaceFacialHairType,

    CASE ZDETECTEDFACE.ZHAIRTYPE
        WHEN 2 THEN 'Bald'
        WHEN 3 THEN 'Not Bald'
        ELSE 'UnknownValue: [' || ZDETECTEDFACE.ZHAIRTYPE || ']'
    END AS 173_ZDetectedFaceHairType,


    -- [ZUNMANAGEDADJUSTMENT.ZASSETATTRIBUTES = ZADDASSETATTRS.Z_PK]
    ZUNMANAGEDADJUSTMENT.ZASSETATTRIBUTES AS 174_ZUnManagedAdjustmentAssetAttributes,
    -- [ZADDASSETATTRS.ZUNMANAGEDADJUSTMENT = ZUNMANAGEDADJUSTMENT.Z_PK]
    ZADDASSETATTRS.ZUNMANAGEDADJUSTMENT AS 175_ZAddAssetAttrsUnmanagedAdjustment,
    -- [ZUNMANAGEDADJUSTMENT.Z_PK = ZADDASSETATTRS.ZUNMANAGEDADJUSTMENT]
    ZUNMANAGEDADJUSTMENT.Z_PK AS 176_ZUnManagedAdjustmentZPk,
    ZUNMANAGEDADJUSTMENT.ZUUID AS 177_ZUnManagedAdjustmentUuid,

    CASE ZASSET.ZADJUSTMENTSSTATE
        WHEN 0 THEN 'No Adjustments'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Still Testing'
        WHEN 3 THEN 'Still Testing'
        ELSE 'UnknownValue: [' || ZASSET.ZADJUSTMENTSSTATE || ']'
    END AS 178_ZAssetAdjustmentsState,

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZADJUSTMENTTIMESTAMP + 978307200,
        'unixepoch'
    ) AS 179_ZAssetAdjustmentTimeStampUtc,

    strftime (
        '%F_%H:%M:%f',
        ZUNMANAGEDADJUSTMENT.ZADJUSTMENTTIMESTAMP + 978307200,
        'unixepoch'
    ) AS 180_ZUnManagedAdjustmentAdjustmentTimeStampUtc,

    ZADDASSETATTRS.ZEDITORBUNDLEID AS 181_ZAddAssetAttrsEditorBundleId,
    ZUNMANAGEDADJUSTMENT.ZEDITORLOCALIZEDNAME AS 182_ZUnManagedAdjustmentEditorLocalizedName,
    ZUNMANAGEDADJUSTMENT.ZADJUSTMENTFORMATIDENTIFIER AS 183_ZUnManagedAdjustmentAdjustmentFormatIdentifier,
    ZADDASSETATTRS.ZMONTAGE AS 184_ZAddAssetAttrsMontage,

    CASE ZUNMANAGEDADJUSTMENT.ZADJUSTMENTRENDERTYPES
        WHEN 0 THEN 'Standard or Portrait with errors'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Portrait'
        WHEN 3 THEN 'Still Testing'
        WHEN 4 THEN 'Still Testing'
        ELSE 'UnknownValue: [' || ZUNMANAGEDADJUSTMENT.ZADJUSTMENTRENDERTYPES || ']'
    END AS 185_ZUnManagedAdjustmentAdjustmentRenderTypes,

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
        ELSE 'UnknownValue: [' || ZUNMANAGEDADJUSTMENT.ZADJUSTMENTFORMATVERSION || ']'
    END AS 186_ZUnManagedAdjustmentAdjustmentFormatVersion,

    ZUNMANAGEDADJUSTMENT.ZADJUSTMENTBASEIMAGEFORMAT AS 187_ZUnManagedAdjustmentAdjustmentBaseImageFormat,
    ZUNMANAGEDADJUSTMENT.ZOTHERADJUSTMENTSFINGERPRINT AS 188_ZUnManagedAdjustmentOtherAdjustmentsFingerprint,
    ZUNMANAGEDADJUSTMENT.ZSIMILARTOORIGINALADJUSTMENTSFINGERPRINT AS 189_ZUnManagedAdjustmentSimilarToOrigAdjFingerprint,

    CASE ZASSET.ZFAVORITE
        WHEN 0 THEN 'Not Favorite'
        WHEN 1 THEN 'Favorite'
        ELSE 'UnknownValue: [' || ZASSET.ZFAVORITE || ']'
    END AS 190_ZAssetFavorite,

    CASE ZASSET.ZHIDDEN
        WHEN 0 THEN 'Not Hidden'
        WHEN 1 THEN 'Hidden'
        ELSE 'UnknownValue: [' || ZASSET.ZHIDDEN || ']'
    END AS 191_ZAssetHidden,

    -- (local asset recently deleted)
    CASE ZASSET.ZTRASHEDSTATE
        WHEN 0 THEN 'Not In Trash/Recently Deleted'
        WHEN 1 THEN 'In Trash/Recently Deleted'
        ELSE 'UnknownValue: [' || ZASSET.ZTRASHEDSTATE || ']'
    END AS 192_ZAssetTrashedState,

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZTRASHEDDATE + 978307200,
        'unixepoch'
    ) AS 193_ZAssetTrashedDateUtc,

    CASE ZASSET.ZDELETEREASON
        WHEN 1 THEN 'Delete Reason (Still Testing)'
        WHEN 2 THEN 'Delete Reason (Still Testing)'
        WHEN 3 THEN 'Delete Reason (Still Testing)'
        ELSE 'UnknownValue: [' || ZASSET.ZDELETEREASON || ']'
    END AS 194_ZAssetDeleteReason,

    CASE ZASSET.ZTRASHEDBYPARTICIPANT
        WHEN 1 THEN 'Trashed/Recently Deleted by Participant'
        ELSE 'UnknownValue: [' || ZASSET.ZTRASHEDBYPARTICIPANT || ']'
    END AS 195_ZAssetTrashedByParticipant,

    CASE ZINTRESOU.ZTRASHEDSTATE
        WHEN 0 THEN 'INTRESOU Not In Trash/Recently Deleted'
        WHEN 1 THEN 'INTRESOU In Trash/Recently Deleted'
        ELSE 'UnknownValue: [' || ZINTRESOU.ZTRASHEDSTATE || ']'
    END AS 196_ZIntreSouTrashedState,

    strftime (
        '%F_%H:%M:%f',
        ZINTRESOU.ZTRASHEDDATE + 978307200,
        'unixepoch'
    ) AS 197_ZIntreSouTrashedDateUtc,

    CASE ZASSET.ZCLOUDDELETESTATE
        WHEN 0 THEN 'CLOUD Asset Not Deleted'
        WHEN 1 THEN 'CLOUD Asset Deleted'
        ELSE 'UnknownValue: [' || ZASSET.ZCLOUDDELETESTATE || ']'
    END AS 198_ZAssetCloudDeleteState,

    CASE ZINTRESOU.ZCLOUDDELETESTATE
        WHEN 0 THEN 'CLOUD IntResou Not Deleted'
        WHEN 1 THEN 'CLOUD IntResou Deleted'
        ELSE 'UnknownValue: [' || ZINTRESOU.ZCLOUDDELETESTATE || ']'
    END AS 199_ZIntreSouCloudDeleteState,

    CASE ZADDASSETATTRS.ZPTPTRASHEDSTATE
        WHEN 0 THEN 'PTP Not in Trash'
        WHEN 1 THEN 'PTP In Trash'
        ELSE 'UnknownValue: [' || ZADDASSETATTRS.ZPTPTRASHEDSTATE || ']'
    END AS 200_ZAddAssetAttrsPtpTrashedState,

    CASE ZINTRESOU.ZPTPTRASHEDSTATE
        WHEN 0 THEN 'PTP IntResou Not in Trash'
        WHEN 1 THEN 'PTP IntResou In Trash'
        ELSE 'UnknownValue: [' || ZINTRESOU.ZPTPTRASHEDSTATE || ']'
    END AS 201_ZIntreSouPtpTrashedState,

    ZINTRESOU.ZCLOUDDELETEASSETUUIDWITHRESOURCETYPE AS 202_ZIntreSouCloudDeleteAssetUuidWithResourceType,

    strftime (
        '%F_%H:%M:%f',
        ZMEDANLYASTATTR.ZMEDIAANALYSISTIMESTAMP + 978307200,
        'unixepoch'
    ) AS 203_ZMediaAnlyastAttrMediaAnalysisTimeStampUtc,

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZANALYSISSTATEMODIFICATIONDATE + 978307200,
        'unixepoch'
    ) AS 204_ZAssetAnalysisStateModificationDateUtc,

    ZADDASSETATTRS.ZVIEWCOUNT AS 205_ZAddAssetAttrsViewCount,
    ZADDASSETATTRS.ZPENDINGVIEWCOUNT AS 206_ZAddAssetAttrsPendingViewCount,
    ZADDASSETATTRS.ZSHARECOUNT AS 207_ZAddAssetAttrsShareCount,
    ZADDASSETATTRS.ZPENDINGSHARECOUNT AS 208_ZAddAssetAttrsPendingShareCount,
    ZADDASSETATTRS.ZPLAYCOUNT AS 209_ZAddAssetAttrsPlayCount,
    ZADDASSETATTRS.ZPENDINGPLAYCOUNT AS 210_ZAddAssetAttrsPendingPlayCount,

    strftime (
        '%F_%H:%M:%f',
        ZASSET.ZLASTSHAREDDATE + 978307200,
        'unixepoch'
    ) AS 211_ZAssetLastSharedDateUtc,

    ZADDASSETATTRS.ZSHAREORIGINATOR AS 212_ZAddAssetAttrsShareOriginator,

    CASE ZASSET.ZSYNDICATIONSTATE
        WHEN 0 THEN 'Local PL Asset Syndication State N/A'
        ELSE 'UnknownValue: [' || ZASSET.ZSYNDICATIONSTATE || ']'
    END AS 213_ZAssetSyndicationStateLpl,

    ZADDASSETATTRS.ZSYNDICATIONHISTORY AS 214_ZAddAssetAttrsSyndicationHistory,
    ZMEDANLYASTATTR.ZSYNDICATIONPROCESSINGVERSION AS 215_ZMediaAnlyastAttrSyndicationProcessingVersion,

    CASE ZMEDANLYASTATTR.ZSYNDICATIONPROCESSINGVALUE
        WHEN 0 THEN 'N/A'
        WHEN 1 THEN 'Wide Camera JPG (Still Testing)'
        WHEN 2 THEN 'Telephoto Camera Lens (Still Testing)'
        WHEN 4 THEN 'SWY Asset Orig Asset Import System Package App (Still Testing)'
        WHEN 16 THEN 'Still Testing'
        WHEN 1024 THEN 'SWY Asset OrigAssetImport Native Camera (Still Testing)'
        WHEN 2048 THEN 'Still Testing'
        WHEN 4096 THEN 'SWY Asset Manually Saved (Still Testing)'
        ELSE 'UnknownValue: [' || ZMEDANLYASTATTR.ZSYNDICATIONPROCESSINGVALUE || ']'
    END AS 216_ZMediaAnlyastAttrSyndicationProcessingValue,

    strftime (
        '%F_%H:%M:%f',
        ZMEDANLYASTATTR.ZVAANALYSISTIMESTAMP + 978307200,
        'unixepoch'
    ) AS 217_ZMediaAnlyastAttrVaAnalysisTimeStampUtc,

    ZMEDANLYASTATTR.ZVAANALYSISVERSION AS 218_ZMediaAnlyastAttrVaAnalysisVersion,

    CASE ZADDASSETATTRS.ZALLOWEDFORANALYSIS
        WHEN 0 THEN 'Asset Not Allowed For Analysis'
        WHEN 1 THEN 'Asset Allowed for Analysis'
        ELSE 'UnknownValue: [' || ZADDASSETATTRS.ZALLOWEDFORANALYSIS || ']'
    END AS 219_ZAddAssetAttrsAllowedForAnalysis,

    ZADDASSETATTRS.ZSCENEANALYSISVERSION AS 220_ZAddAssetAttrsSceneAnalysisVersion,

    CASE ZADDASSETATTRS.ZSCENEANALYSISISFROMPREVIEW
        WHEN 0 THEN 'No'
        ELSE 'UnknownValue: [' || ZADDASSETATTRS.ZSCENEANALYSISISFROMPREVIEW || ']'
    END AS 221_ZAddAssetAttrsSceneAnalysisIsFromPreview,

    strftime (
        '%F_%H:%M:%f',
        ZADDASSETATTRS.ZSCENEANALYSISTIMESTAMP + 978307200,
        'unixepoch'
    ) AS 222_ZAddAssetAttrsSceneanAlysisTimeStampUtc,

    CASE ZASSET.ZDUPLICATEASSETVISIBILITYSTATE
        WHEN 0 THEN 'No Duplicates'
        WHEN 1 THEN 'Has Duplicate'
        WHEN 2 THEN 'Is a Duplicate'
        ELSE 'UnknownValue: [' || ZASSET.ZDUPLICATEASSETVISIBILITYSTATE || ']'
    END AS 223_ZAssetDuplicateAssetVisibilityState,

    CASE ZADDASSETATTRS.ZDESTINATIONASSETCOPYSTATE
        WHEN 0 THEN 'No Copy'
        WHEN 1 THEN 'Has A Copy'
        WHEN 2 THEN 'Has A Copy'
        ELSE 'UnknownValue: [' || ZADDASSETATTRS.ZDESTINATIONASSETCOPYSTATE || ']'
    END AS 224_ZAddAssetAttrsDestinationAssetCopyState,

    -- hex ( ZSCENEP.ZDATA ) AS 225_ZScenePDataHexNSKeyedPlist,
    -- hex ( ZSCENEP.ZDUPLICATEMATCHINGDATA ) AS 226_ZScenePDuplicateMatchingDataHexNSKeyedPlist,
    -- hex ( ZSCENEP.ZDUPLICATEMATCHINGALTERNATEDATA ) AS 227_ZScenePDuplicateMatchingAlternateDataHexNSKeyedPlist,
    ZADDASSETATTRS.ZSOURCEASSETFORDUPLICATIONSCOPEIDENTIFIER AS 228_ZAddAssetAttrsSourceAssetForDuplicationScopeIdentifier,
    ZCLDMAST.ZSOURCEMASTERFORDUPLICATIONSCOPEIDENTIFIER AS 229_ZCldMastSourceMasterForDuplicationScopeIdentifier,
    ZADDASSETATTRS.ZSOURCEASSETFORDUPLICATIONIDENTIFIER AS 230_ZAddAssetAttrsSourceAssetForDuplicationIdentifier,
    ZCLDMAST.ZSOURCEMASTERFORDUPLICATIONIDENTIFIER AS 231_ZCldMastSourceMasterForDuplicationIdentifier,
    ZEXTATTR.Z_ENT AS 232_ZExtAttrEnt,
    ZEXTATTR.Z_OPT AS 233_ZExtAttrOpt,
    ZADDASSETATTRS.ZVARIATIONSUGGESTIONSTATES AS 234_ZAddAssetAttrsVariationSuggestionStates,
    ZASSET.ZHIGHFRAMERATESTATE AS 235_ZAssetHighFrameRateState,
    ZASSET.ZVIDEOKEYFRAMETIMESCALE AS 236_ZAssetVideoKeyFrameTimeScale,
    ZASSET.ZVIDEOKEYFRAMEVALUE AS 237_ZAssetVideoKeyFrameValue,
    ZEXTATTR.ZISO AS 238_ZExtAttrIso,
    ZEXTATTR.ZMETERINGMODE AS 239_ZExtAttrMeteringMode,
    ZEXTATTR.ZSAMPLERATE AS 240_ZExtAttrSampleRate,
    ZEXTATTR.ZTRACKFORMAT AS 241_ZExtAttrTrackFormat,
    ZEXTATTR.ZWHITEBALANCE AS 242_ZExtAttrWhiteBalance,
    ZEXTATTR.ZASSET AS 243_ZExtAttrAasset,
    ZEXTATTR.ZAPERTURE AS 244_ZExtAttrAperture,
    ZEXTATTR.ZBITRATE AS 245_ZExtAttrBitRate,
    ZEXTATTR.ZEXPOSUREBIAS AS 246_ZExtAttrExposureBias,
    ZEXTATTR.ZFPS AS 247_ZExtAttrFps,
    ZEXTATTR.ZSHUTTERSPEED AS 248_ZExtAttrShutterSpeed,
    ZEXTATTR.ZSLUSHSCENEBIAS AS 249_ZExtAttrSlushSceneBias,
    ZEXTATTR.ZSLUSHVERSION AS 250_ZExtAttrSlushVersion,
    ZEXTATTR.ZSLUSHPRESET AS 251_ZExtAttrSlushPreset,
    ZEXTATTR.ZSLUSHWARMTHBIAS AS 252_ZExtAttrSlushWarmthBias,
    ZASSET.ZHEIGHT AS 253_ZAssetHeight,
    ZADDASSETATTRS.ZORIGINALHEIGHT AS 254_ZAddAssetAttrsOriginalHeight,
    ZINTRESOU.ZUNORIENTEDHEIGHT AS 255_ZIntreSouUnorienteHheight,
    ZASSET.ZWIDTH AS 256_ZAssetWidth,
    ZADDASSETATTRS.ZORIGINALWIDTH AS 257_AddAssetAttrOriginalWidth,
    ZINTRESOU.ZUNORIENTEDWIDTH AS 258_ZIntreSouUnorientedWidth,
    ZShare.ZTHUMBNAILIMAGEDATA AS 259_ZShareThumbnailImageData,
    ZASSET.ZTHUMBNAILINDEX AS 260_ZAssetThumbnailIndex,
    ZADDASSETATTRS.ZEMBEDDEDTHUMBNAILHEIGHT AS 261_ZAddAssetAttrsEmbeddedThumbnailHeight,
    ZADDASSETATTRS.ZEMBEDDEDTHUMBNAILLENGTH AS 262_ZAddAssetAttrsEmbeddedThumbnailLength,
    ZADDASSETATTRS.ZEMBEDDEDTHUMBNAILOFFSET AS 263_ZAddAssetAttrsEmbeddedThumbnailOffset,
    ZADDASSETATTRS.ZEMBEDDEDTHUMBNAILWIDTH AS 264_ZAddAssetAttrsEmbeddedThumbnailWidth,
    ZASSET.ZPACKEDACCEPTABLECROPRECT AS 265_ZAssetPackedAcceptableCropRect,
    ZASSET.ZPACKEDBADGEATTRIBUTES AS 266_ZAssetPackedBadgeAttributes,
    ZASSET.ZPACKEDPREFERREDCROPRECT AS 267_ZAssetPackedPreferredCropRect,
    ZASSET.ZCURATIONSCORE AS 268_ZAssetCurationScore,
    ZASSET.ZCAMERAPROCESSINGADJUSTMENTSTATE AS 269_ZAssetCameraProcessingAdjustmentState,
    ZASSET.ZDEPTHTYPE AS 270_ZAssetDepthType,
    ZASSET.ZISMAGICCARPET AS 271_ZAssetIsMagicCarpet,
    ZASSET.ZLIBRARYSCOPE AS 272_ZAssetLibraryScope,

    CASE ZASSET.ZLIBRARYSCOPESHARESTATE
        WHEN 0 THEN 'Not Shared (Still Testing)'
        ELSE 'UnknownValue: [' || ZASSET.ZLIBRARYSCOPESHARESTATE || ']'
    END AS 273_ZAssetLibraryScopeShareState,

    ZADDASSETATTRS.ZORIGINALRESOURCECHOICE AS 274_ZAddAssetAttrsOriginalResourceChoice,
    ZADDASSETATTRS.ZSPATIALOVERCAPTUREGROUPIDENTIFIER AS 275_ZAddAssetAttrsSpatialOverCaptureGroupIdentifier,
    -- hex ( ZADDASSETATTRS.ZOBJECTSALIENCYRECTSDATA ) AS 276_ZAddAssetAttrsObjectsAlienCyrectsDataHexNSKeyedPlist,
    -- hex ( ZADDASSETATTRS.ZORIGINALHASH ) AS 277_ZAddAssetAttrsOriginalHashHex,
    ZADDASSETATTRS.ZPLACEANNOTATIONDATA AS 278_ZAddAssetAttrsPlaceAnnotationData,
    ZADDASSETATTRS.ZDISTANCEIDENTITY AS 279_ZAddAssetAttrsDistanceIdentity


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
    ZASSET.ZFILENAME IS '6EB3A423_E433_40E8-A03A-5C807423D008.mp4'


ORDER BY ZASSET.ZADDEDDATE
