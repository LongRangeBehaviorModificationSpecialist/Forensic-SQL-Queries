/*
[DLU]
    20-Nov-2026
[URL]
    https://github.com/ScottKjr3347/iOS_SWY_PL_Photos.sqlite_Queries/blob/main/iOS16/iOS16_SWY-PL_Phsql_Basic.txt
[DATABASE]
    /private/var/mobile/Media/PhotoData/Photos.sqlite
    /private/var/mobile/Library/Photos/Libraries/Syndication.photoslibrary/database/Photos.sqlite
[NOTES]

*/

SELECT
    ROW_NUMBER() OVER ( ORDER BY ZASSET.ZADDEDDATE ) AS RowNumber,

    ZASSET.Z_PK AS AssetZPk,
    ZASSET.ZSORTTOKEN AS AssetSortToken,
    ZASSET.ZPROMOTIONSCORE AS AssetPromotionScore,

    CASE ZASSET.ZCOMPLETE
        WHEN 1 THEN 'Yes'
        ELSE ZASSET.ZCOMPLETE
    END AS AssetComplete,

    ZADDASSETATTR.Z_PK AS AddAssetAttrZPk,

    -- [ZCLOUDMASTER.Z_PK = ZASSET.ZMASTER]
    ZCLOUDMASTER.Z_PK AS CloudMasterZPk,

    -- [ZASSET.ZMASTER = ZCLOUDMASTER.Z_PK]
    ZASSET.ZMASTER AS AssetMaster,

    -- [ZASSET.ZEXTENDEDATTRIBUTES = ZEXTATTR.Z_PK]
    ZASSET.ZEXTENDEDATTRIBUTES AS AssetExtendedAttributes,

    -- [ZEXTATTR.Z_PK = ZASSET.ZEXTENDEDATTRIBUTES]
    ZEXTATTR.Z_PK AS ExtAttrZPk,

    -- [CMzCldMastMedData-CldMast = ZCLOUDMASTER.Z_PK]
    CMzCldMastMedData.ZCLOUDMASTER AS CMzCldMastMedDataCloudMaster,

    -- [ZCLOUDMASTER.ZMEDIAMETADATA = zCldMastMedData.Z_PK]
    ZCLOUDMASTER.ZMEDIAMETADATA AS CloudMasterMediaMetadata,

    -- [CMzCldMastMedData.Z_PK=ZADDASSETATTR&ZCLOUDMASTER.ZMEDIAMETADATA]
    CMzCldMastMedData.Z_PK AS CMzCldMastMedDataZPk,
    CMzCldMastMedData.Z_ENT AS CMzCldMastMedDataZEnt,

    -- [ZASSET.UUID = store.cloudphotodb]
    ZASSET.ZUUID AS AssetUuid,
    ZASSET.ZDIRECTORY AS AssetDirectory,
    ZASSET.ZFILENAME AS AssetFilename,
    CONCAT ( ZASSET.ZDIRECTORY, '/', ZASSET.ZFILENAME ) AS Filepath,
    ZADDASSETATTR.ZORIGINALFILENAME AS AddAssetAttrOriginalFileName,
    ZCLOUDMASTER.ZORIGINALFILENAME AS CloudMasterOriginalFileName,

    /* The GUID value in this column matches the GUID of the message from the sms.db file */
    ZADDASSETATTR.ZSYNDICATIONIDENTIFIER AS AddAssetAttrSyndicationIdentifier,

    -- [ZASSET.Cloud_Asset_GUID = store.cloudphotodb]
    ZASSET.ZCLOUDASSETGUID AS AssetCloudAssetGuid,
    ZASSET.ZCLOUDCOLLECTIONGUID AS CloudCollectionGuid,

    -- [ZCLOUDMASTER.ZCLOUDMASTERGUID = store.cloudphotodb]
    ZCLOUDMASTER.ZCLOUDMASTERGUID AS CloudMasterCloudMasterGuid,

    -- [zGenAlbum.ZCLOUDGUID = store.cloudphotodb]
    zGenAlbum.ZCLOUDGUID AS GenericAlbumCloudGuid,

    -- [ZSHARE.ZSCOPEIDENTIFIER = store.cloudphotodb]
    ZSHARE.ZSCOPEIDENTIFIER AS ZSHAREScopeIdentifier,
    ZADDASSETATTR.ZORIGINALASSETSUUID AS AddAssetAttrOriginalAssetsUuid,
    ZADDASSETATTR.ZPUBLICGLOBALUUID AS AddAssetAttrPublicGlobalUuid,
    ZADDASSETATTR.ZMASTERFINGERPRINT AS AddAssetAttrMasterFingerprint,
    ZADDASSETATTR.ZORIGINATINGASSETIDENTIFIER AS AddAssetAttrOriginatingAssetIdentifier,
    ZCLOUDMASTER.ZORIGINATINGASSETIDENTIFIER AS CloudMasterOriginatingAssetIdentifier,
    ZINTERNALRESOURCE.ZFINGERPRINT AS InternalResourceFingerprint,
    ZADDASSETATTR.ZADJUSTEDFINGERPRINT AS AddAssetAttrAdjustedFingerprint,
    ZUNMANAGEDADJUSTMENT.ZOTHERADJUSTMENTSFINGERPRINT AS UnManagedAdjustmentOtherAdjustmentsFingerprint,
    ZUNMANAGEDADJUSTMENT.ZSIMILARTOORIGINALADJUSTMENTSFINGERPRINT AS UnManagedAdjustmentSimilarToOriginalAdjustmentsFingerprint,

    CASE
        WHEN ZASSET.ZADDEDDATE < 0 THEN 'Invalid Date/Time Value: [' || ZASSET.ZADDEDDATE || ']'
        ELSE strftime ( '%F_%H:%M:%f', ZASSET.ZADDEDDATE + 978307200, 'unixepoch' )
    END AS AssetAddedDateUtc,

    CASE
        WHEN ZASSET.ZDATECREATED < 0 THEN 'Invalid Date/Time Value: [' || ZASSET.ZDATECREATED || ']'
        ELSE strftime ( '%F_%H:%M:%f', ZASSET.ZDATECREATED + 978307200, 'unixepoch' )
    END AS AssetDateCreatedUtc,

    strftime ( '%F_%H:%M:%f', ZASSET.ZMODIFICATIONDATE + 978307200, 'unixepoch' ) AS AssetModificationDateUtc,
    strftime ( '%F_%H:%M:%f', ZASSET.ZANALYSISSTATEMODIFICATIONDATE + 978307200, 'unixepoch' ) AS AssetAnalysisStateModificationDateUtc,
    strftime ( '%F_%H:%M:%f', ZCLOUDMASTER.ZCREATIONDATE + 978307200, 'unixepoch' ) AS CloudMasterCreationDateUtc,
    strftime ( '%F_%H:%M:%f', ZINTERNALRESOURCE.ZCLOUDMASTERDATECREATED + 978307200, 'unixepoch' ) AS InternalResourceCloudMasterDateCreatedUtc,

    ZADDASSETATTR.ZIMPORTEDBYBUNDLEIDENTIFIER AS AddAssetAttrImportedByBundleIdentifier,
    ZADDASSETATTR.ZIMPORTEDBYDISPLAYNAME AS AddAssetAttrImportedByDisplayName,
    ZADDASSETATTR.ZORIGINALHEIGHT AS AddAssetAttrOriginalHeight,
    ZADDASSETATTR.ZORIGINALWIDTH AS AddAssetAttrOriginalWidth,
    ZADDASSETATTR.ZORIGINALORIENTATION AS AddAssetAttrOriginalOrientation,
    printf ( '%,d', ZADDASSETATTR.ZORIGINALFILESIZE ) AS AddAssetAttrOriginalFileSize,
    ZCLOUDMASTER.ZIMPORTEDBYBUNDLEIDENTIFIER AS CloudMasterImportedByBundleIdentifier,
    ZCLOUDMASTER.ZIMPORTEDBYDISPLAYNAME AS CloudMasterImportedbyDisplayName,

    CASE ParentzGenAlbum.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'iCloudPhotos ON=Asset In Shared/Other Album / iCloudPhotos OFF=Generic Album'
        WHEN 1 THEN 'iCloudPhotos ON=Asset In Generic Album'
        ELSE 'Type: [' || ParentzGenAlbum.ZCLOUDLOCALSTATE || ']'
    END AS ParentzGenAlbumCloudLocalState,

    ParentzGenAlbum.ZTITLE AS ParentzGenAlbumTitle,

    strftime ( '%F_%H:%M:%f', ParentzGenAlbum.ZCREATIONDATE + 978307200, 'unixepoch' ) AS ParentzGenAlbumCreationDateUtc,
    strftime ( '%F_%H:%M:%f', zGenAlbum.ZCREATIONDATE + 978307200, 'unixepoch' ) AS zGenAlbumCreationDateUtc,

    CASE zGenAlbum.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'iCloudPhotos ON=Asset In Shared/Other Album / iCloudPhotos OFF=Generic Album'
        WHEN 1 THEN 'iCloudPhotos ON=Asset In Generic Album'
        ELSE 'Type: [' || zGenAlbum.ZCLOUDLOCALSTATE || ']'
    END AS zGenAlbumCloudLocalState,

    zGenAlbum.ZTITLE AS zGenAlbumTitle,

	CASE ZADDASSETATTR.ZIMPORTEDBY
        WHEN 0 THEN 'Cloud Other'
        WHEN 1 THEN 'Native Back Camera'
        WHEN 2 THEN 'Native Front Camera'
        WHEN 3 THEN 'Third Party App'
        WHEN 4 THEN 'Still Testing'
        WHEN 5 THEN 'PhotoBooth PL Asset'
        WHEN 6 THEN 'Third Party App'
        WHEN 7 THEN 'iCloud Share Link CMMAsset'
        WHEN 8 THEN 'System Package App'
        WHEN 9 THEN 'Native App'
        WHEN 10 THEN 'Still Testing'
        WHEN 11 THEN 'Still Testing'
        WHEN 12 THEN 'SWY Syndication PL'
        ELSE 'Type: [' || ZADDASSETATTR.ZIMPORTEDBY || ']'
    END AS AddAssetAttrImportedBy,

    strftime ( '%F_%H:%M:%f', ZCLOUDMASTER.ZIMPORTDATE + 978307200, 'unixepoch') AS CloudMasterImportDateUtc,

	CASE ZCLOUDMASTER.ZIMPORTEDBY
        WHEN 0 THEN 'Cloud Other'
        WHEN 1 THEN 'Native Back Camera'
        WHEN 2 THEN 'Native Front Camera'
        WHEN 3 THEN 'Third Party App'
        WHEN 4 THEN 'Still Testing'
        WHEN 5 THEN 'PhotoBooth PL Asset'
        WHEN 6 THEN 'Third Party App'
        WHEN 7 THEN 'iCloud Share Link CMMAsset'
        WHEN 8 THEN 'System Package App'
        WHEN 9 THEN 'Native App'
        WHEN 10 THEN 'Still Testing'
        WHEN 11 THEN 'Still Testing'
        WHEN 12 THEN 'SWY Syndication PL'
        ELSE 'Type: [' || ZCLOUDMASTER.ZIMPORTEDBY || ']'
    END AS CloudMasterImportedBy,

    -- hex ( ZASSET.ZIMAGEREQUESTHINTS ) AS AssetImageRequestHintsHex,

    CASE ZASSET.ZBUNDLESCOPE
        WHEN 0 THEN 'iCloudPhotos ON=Not In Shared Album iCloudPhotos OFF=On Local Device'
        WHEN 1 THEN 'SWY Syndication CMMAsset'
        WHEN 2 THEN 'iCloudPhotos ON=Asset In Cloud Shared Album'
        WHEN 3 THEN 'iCloudPhotos ON=SWY Syndication Asset'
        ELSE 'Type: [' || ZASSET.ZBUNDLESCOPE || ']'
    END AS AssetBundleScope,

    CASE ZASSET.ZCLOUDISMYASSET
        WHEN 0 THEN 'Not My Asset in Shared Album'
        WHEN 1 THEN 'My Asset in Shared Album'
        ELSE 'Type: [' || ZASSET.ZCLOUDISMYASSET || ']'
    END AS AssetCloudIsMyAsset,

    CASE ZASSET.ZCLOUDISDELETABLE
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || ZASSET.ZCLOUDISDELETABLE || ']'
    END AS AssetCloudIsDeletable,

    CASE ZASSET.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'iCloudPhotos ON=Asset In Shared Other Album/iCloudPhotos OFF=Not Synced'
        WHEN 1 THEN 'iCloudPhotos ON=Asset Synced with iCloud'
        ELSE 'Type: [' || ZASSET.ZCLOUDLOCALSTATE || ']'
    END AS AssetCloudLocalState,

    CASE ZASSET.ZVISIBILITYSTATE
        WHEN 0 THEN 'Visible Photo Library'
        WHEN 2 THEN 'Not Visible Photo Library'
        ELSE 'Type: [' || ZASSET.ZVISIBILITYSTATE || ']'
    END AS AssetvisibilityState,

    ZEXTATTR.ZCAMERAMAKE AS ExtAttrCameraMake,
    ZEXTATTR.ZCAMERAMODEL AS ExtAttrCameraModel,
    ZEXTATTR.ZLENSMODEL AS ExtAttrLensModel,

    CASE ZEXTATTR.ZFLASHFIRED
        WHEN 0 THEN 'No Flash'
        WHEN 1 THEN 'Flash Fired'
        ELSE 'Type: [' || ZEXTATTR.ZFLASHFIRED || ']'
    END AS ExtAttrFlashFired,

    ZEXTATTR.ZFOCALLENGTH AS ExtAttrFocalLength,
    ZEXTATTR.ZFOCALLENGTHIN35MM AS ExtAttrFocalLengthIn35mm,
    ZEXTATTR.ZDIGITALZOOMRATIO AS ExtAttrDigitalZoomRatio,

    CASE ZASSET.ZDERIVEDCAMERACAPTUREDEVICE
        WHEN 0 THEN 'Back Camera/Other'
        WHEN 1 THEN 'Front Camera'
        ELSE 'Type: [' || ZASSET.ZDERIVEDCAMERACAPTUREDEVICE || ']'
    END AS AssetDerivedCameraCaptureDevice,

    CASE ZADDASSETATTR.ZCAMERACAPTUREDEVICE
        WHEN 0 THEN 'Back Camera/Other'
        WHEN 1 THEN 'Front Camera'
        ELSE 'Type: [' || ZADDASSETATTR.ZCAMERACAPTUREDEVICE || ']'
    END AS AddAssetAttrCameraCaptureDevice,

    CASE ZASSET.ZSAVEDASSETTYPE
        WHEN 0 THEN 'Saved Via Other Source'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Still Testing'
        WHEN 3 THEN 'SWY Syndicaion PL Asset Not In Local PL'
        WHEN 4 THEN 'Photo Cloud Sharing Data Asset'
        WHEN 5 THEN 'Still Testing'
        WHEN 6 THEN 'Cloud Photo Library Asset'
        WHEN 7 THEN 'Still Testing'
        WHEN 8 THEN 'iCloud Link CloudMaster Moment Asset'
        WHEN 12 THEN 'SWY Syndicaion PL Asset In Local PL'
        ELSE 'Type: [' || ZASSET.ZSAVEDASSETTYPE || ']'
    END AS AssetSavedAssetType,

    CASE ZASSET.ZSAVEDASSETTYPE
        WHEN 0 THEN 'Saved Via Other Source'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Still Testing'
        WHEN 3 THEN 'Local Photo Library Asset'
        WHEN 4 THEN 'Photo Cloud Sharing Data Asset'
        WHEN 5 THEN 'PhotoBooth Photo Library Asset'
        WHEN 6 THEN 'Cloud Photo Library Asset'
        WHEN 7 THEN 'Still Testing'
        WHEN 8 THEN 'iCloud Link CloudMaster Moment Asset'
        WHEN 12 THEN 'SWY Syndication PL Asset/Auto Displayed in LPL'
        ELSE 'Type: [' || ZASSET.ZSAVEDASSETTYPE || ']'
    END AS AssetSavedAssetType,

    CASE ZASSET.ZSYNDICATIONSTATE
        WHEN 0 THEN 'Received SWY Synd Asset'
        WHEN 1 THEN 'Sent SWY Synd Asset'
        WHEN 2 THEN 'Manually Saved SWY Synd Asset'
        WHEN 8 THEN 'SWY Linked Asset was Visible On Device User Deleted Link'
        WHEN 10 THEN 'Manually Saved SWY Synd Asset User Deleted From LPL'
        ELSE 'Type: [' || ZASSET.ZSYNDICATIONSTATE || ']'
    END AS AssetSyndicationState,

    ZADDASSETATTR.ZSYNDICATIONHISTORY AS AddAssetAttrSyndicationHistory,
    zMedAnlyAstAttr.ZSYNDICATIONPROCESSINGVERSION AS zMedAnlyAstAttrSyndicationProcessingVersion,

    CASE zMedAnlyAstAttr.ZSYNDICATIONPROCESSINGVALUE
        WHEN 0 THEN 'N/A'
        WHEN 1 THEN 'Still Testing Wide Camera JPG'
        WHEN 2 THEN 'Still Testing Telephoto Camear Lens'
        WHEN 4 THEN 'Still Testing SWY Asset OrigAssetImport SystemPackageApp'
        WHEN 16 THEN 'Still Testing'
        WHEN 1024 THEN 'Still Testing SWY Asset OrigAssetImport Native Camera'
        WHEN 2048 THEN 'Still Testing'
        WHEN 4096 THEN 'Still Testing SWY Asset Manually Saved'
        ELSE 'Type: [' || zMedAnlyAstAttr.ZSYNDICATIONPROCESSINGVALUE || ']'
    END AS zMedAnlyAstAttrSyndicationProcessingValue,

    CASE ZADDASSETATTR.ZDATECREATEDSOURCE
        WHEN 0 THEN 'Cloud Asset'
        WHEN 1 THEN 'Local Asset EXIF'
        WHEN 3 THEN 'Local Asset No EXIF'
        ELSE 'Type: [' || ZADDASSETATTR.ZDATECREATEDSOURCE || ']'
    END AS AddAssetAttrDateCreatedSource,

    ZADDASSETATTR.ZTIMEZONENAME AS AddAssetAttrTimeZoneName,
    ZADDASSETATTR.ZTIMEZONEOFFSET AS AddAssetAttrTimeZoneOffset,
    ZADDASSETATTR.ZINFERREDTIMEZONEOFFSET AS AddAssetAttrInferredTimeZoneOffset,
    ZADDASSETATTR.ZEXIFTIMESTAMPSTRING AS AddAssetAttrExifTimeStampString,

    CASE ZCLOUDMASTER.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'Not Synced with Cloud'
        WHEN 1 THEN 'Pending Upload'
        WHEN 2 THEN 'Still Testing'
        WHEN 3 THEN 'Synced with Cloud'
        ELSE 'Type: [' || ZCLOUDMASTER.ZCLOUDLOCALSTATE || ']'
    END AS CloudMasterCloudLocalState,

    ZASSET.ZIMPORTSESSION AS AssetImportSession,
    ZADDASSETATTR.ZIMPORTSESSIONID AS AddAssetAttrImportSessionId,

    strftime ( '%F_%H:%M:%f', ZADDASSETATTR.ZALTERNATEIMPORTIMAGEDATE + 978307200, 'unixepoch' ) AS AddAssetAttrAlternateImportImageDateUtc,

    ZCLOUDMASTER.ZIMPORTSESSIONID AS CloudMasterImportSessionId,

    strftime ( '%F_%H:%M:%f', ZASSET.ZCLOUDBATCHPUBLISHDATE + 978307200, 'unixepoch' ) AS AssetCloudBatchPublishDateUtc,
    strftime ( '%F_%H:%M:%f', ZASSET.ZCLOUDSERVERPUBLISHDATE + 978307200, 'unixepoch' ) AS AssetCloudServerPublishDateUtc,

    ZASSET.ZCLOUDDOWNLOADREQUESTS AS AssetCloudDownloadRequests,
    ZASSET.ZCLOUDBATCHID AS AssetCloudBatchId,

    strftime ( '%F_%H:%M:%f', ZADDASSETATTR.ZLASTUPLOADATTEMPTDATE + 978307200, 'unixepoch' ) AS AddAssetAttrLastUploadAttemptDateUtc,

    ZADDASSETATTR.ZUPLOADATTEMPTS AS AddAssetAttrUploadAttempts,

    CASE ZASSET.ZLATITUDE
        WHEN -180.0 THEN '[-180.0]'
        ELSE ZASSET.ZLATITUDE
    END AS AssetLatitude,

    CASE ZASSET.ZLONGITUDE
        WHEN -180.0 THEN '[-180.0]'
        ELSE ZASSET.ZLONGITUDE
    END AS AssetLongitude,

    ZEXTATTR.ZLATITUDE AS ExtAttrLatitude,
    ZEXTATTR.ZLONGITUDE AS ExtAttrLongitude,

    CASE ZADDASSETATTR.ZGPSHORIZONTALACCURACY
        WHEN -1.0 THEN '[-1.0]'
        ELSE ZADDASSETATTR.ZGPSHORIZONTALACCURACY
    END AS AddAssetAttrGpsHorizontalAccuracy,

    -- hex ( ZASSET.ZLOCATIONDATA ) AS AssetLocationDataHex,
    -- hex ( ZADDASSETATTR.ZREVERSELOCATIONDATA ) AS AddAssetAttrReverseLocationDataHexNSKeyedPlist,

    CASE ZADDASSETATTR.ZSHIFTEDLOCATIONISVALID
        WHEN 0 THEN 'Shifted Location Not Valid'
        WHEN 1 THEN 'Shifted Location Valid'
        ELSE 'Type: [' || ZADDASSETATTR.ZSHIFTEDLOCATIONISVALID || ']'
    END AS AddAssetAttrShiftedLocationIsValid,

    ZADDASSETATTR.ZSHIFTEDLOCATIONDATA AS AddAssetAttrShiftedLocationData,
    ZADDASSETATTR.ZLOCATIONHASH AS AddAssetAttrLocationHash,

    CASE AAAzCldMastMedData.Z_OPT
        WHEN 1 THEN 'Still Testing Cloud'
        WHEN 2 THEN 'Still Testing This Device'
        WHEN 3 THEN 'Still Testing Muted'
        WHEN 4 THEN 'Still Testing Unknown'
        WHEN 5 THEN 'Still Testing Unknown'
        ELSE 'Type: [' || AAAzCldMastMedData.Z_OPT || ']'
    END AS AAAzCldMastMedDataOpt,

    ZADDASSETATTR.ZMEDIAMETADATATYPE AS AddAssetAttrMediaMetadataType,
    -- hex ( AAAzCldMastMedData.ZDATA ) AS AAAzCldMastMedDataDataHex,

    CASE CMzCldMastMedData.z_opt
        WHEN 1 THEN 'Still Testing Has CldMastAsset'
        WHEN 2 THEN 'Still Testing Local Asset'
        WHEN 3 THEN 'Still Testing Muted'
        WHEN 4 THEN 'Still Testing Unknown'
        WHEN 5 THEN 'Still Testing Unknown'
        ELSE 'Type: [' || CMzCldMastMedData.Z_OPT || ']'
    END AS CMzCldMastMedDataZOpt,

    ZCLOUDMASTER.ZMEDIAMETADATATYPE AS CloudMasterMediaMetadataType,
    -- hex ( CMzCldMastMedData.ZDATA ) AS CMzCldMastMedDataDataHex,

    CASE ZASSET.ZSEARCHINDEXREBUILDSTATE
        WHEN 0 THEN 'Still Testing'
        ELSE 'Type: [' || ZASSET.ZSEARCHINDEXREBUILDSTATE || ']'
    END AS AssetSearchIndexRebuildState,

    CASE ZASSET.ZORIENTATION
        WHEN 1 THEN 'Video Default/Adjustment/Horizontal Camera (left)'
        WHEN 2 THEN 'Horizontal Camera (right)'
        WHEN 3 THEN 'Horizontal Camera (right)'
        WHEN 4 THEN 'Horizontal Camera (left)'
        WHEN 5 THEN 'Vertical Camera (top)'
        WHEN 6 THEN 'Vertical Camera (top)'
        WHEN 7 THEN 'Vertical Camera (bottom)'
        WHEN 8 THEN 'Vertical Camera (bottom)'
        ELSE 'Type: [' || ZASSET.ZORIENTATION || ']'
    END AS AssetOrientation,

    CASE ZADDASSETATTR.ZORIGINALORIENTATION
        WHEN 1 THEN 'Video Default/Adjustment/Horizontal Camera (left)'
        WHEN 2 THEN 'Horizontal Camera (right)'
        WHEN 3 THEN 'Horizontal Camera (right)'
        WHEN 4 THEN 'Horizontal Camera (left)'
        WHEN 5 THEN 'Vertical Camera (top)'
        WHEN 6 THEN 'Vertical Camera (top)'
        WHEN 7 THEN 'Vertical Camera (bottom)'
        WHEN 8 THEN 'Vertical Camera (bottom)'
        ELSE 'Type: [' || ZASSET.ZORIENTATION || ']'
    END AS AddAssetAttrOriginalOrientation,

    CASE ZINTERNALRESOURCE.ZORIENTATION
        WHEN 0 THEN 'N/A'
        WHEN 1 THEN 'Video Default/Adjustment/Horizontal Camera (left)'
        WHEN 2 THEN 'Horizontal Camera (right)'
        WHEN 3 THEN 'Horizontal Camera (right)'
        WHEN 4 THEN 'Horizontal Camera (left)'
        WHEN 5 THEN 'Vertical Camera (top)'
        WHEN 6 THEN 'Vertical Camera (top)'
        WHEN 7 THEN 'Vertical Camera (bottom)'
        WHEN 8 THEN 'Vertical Camera (bottom)'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZORIENTATION || ']'
    END AS InternalResourceOrientation,

    CASE ZASSET.ZKIND
        WHEN 0 THEN 'Photo'
        WHEN 1 THEN 'Video'
        ELSE 'Type: [' || ZASSET.ZKIND || ']'
    END AS AssetKind,

    CASE ZASSET.ZKINDSUBTYPE
        WHEN 0 THEN 'Still Photo'
        WHEN 2 THEN 'Live Photo'
        WHEN 10 THEN 'SpringBoard Screenshot'
        WHEN 100 THEN 'Video'
        WHEN 101 THEN 'Slow Mo Video'
        WHEN 102 THEN 'Time lapse Video'
        WHEN 103 THEN 'Replay Screen Recording'
        ELSE 'Type: [' || ZASSET.ZKINDSUBTYPE || ']'
    END AS AssetKindSubType,

    CASE ZADDASSETATTR.ZCLOUDKINDSUBTYPE
        WHEN 0 THEN 'Still Photo'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Live Photo'
        WHEN 3 THEN 'Screenshot'
        WHEN 10 THEN 'SpringBoard Screenshot'
        WHEN 100 THEN 'Video'
        WHEN 101 THEN 'Slow Mo Video'
        WHEN 102 THEN 'Time lapse Video'
        WHEN 103 THEN 'Replay Screen Recording'
        ELSE 'Type: [' || ZADDASSETATTR.ZCLOUDKINDSUBTYPE || ']'
    END AS AddAssetAttrCloudKindSubType,

    CASE ZASSET.ZPLAYBACKSTYLE
        WHEN 1 THEN 'Image'
        WHEN 2 THEN 'Image Animated'
        WHEN 3 THEN 'Live Photo'
        WHEN 4 THEN 'Video'
        WHEN 5 THEN 'Video Looping'
        ELSE 'Type: [' || ZASSET.ZPLAYBACKSTYLE || ']'
    END AS AssetPlaybackStyle,

    ZASSET.ZPLAYBACKVARIATION AS AssetPlaybackVariation,
    ZASSET.ZDURATION AS AssetDuration,
    ZEXTATTR.ZDURATION AS ExtAttrDuration,
    ZASSET.ZVIDEOCPDURATIONVALUE AS AssetVideoCpDurationValue,
    ZADDASSETATTR.ZVIDEOCPDURATIONTIMESCALE AS AddAssetAttrVideoCpDurationTimeScale,
    ZASSET.ZVIDEOCPVISIBILITYSTATE AS AssetVideoCpVisibilityState,
    ZADDASSETATTR.ZVIDEOCPDISPLAYVALUE AS AddAssetAttrVideoCpDisplayValue,
    ZADDASSETATTR.ZVIDEOCPDISPLAYTIMESCALE AS AddAssetAttrVideoCpDisplayTimeScale,

    -- [ZINTERNALRESOURCE.ZASSET = ZASSET.zPK]
    ZINTERNALRESOURCE.ZASSET AS InternalResourceAsset,
    ZINTERNALRESOURCE.Z_PK AS InternalResourceZPk,
    ZINTERNALRESOURCE.Z_ENT AS InternalResourceEnt,
    ZINTERNALRESOURCE.Z_OPT AS InternalResourceOpt,
    ZINTERNALRESOURCE.ZQUALITYSORTVALUE AS InternalResourceQualitySortValue,

    CASE ZINTERNALRESOURCE.ZDATASTORECLASSID
        WHEN 0 THEN 'LPL Asset CPL Asset'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Photo Cloud Sharing Asset'
        WHEN 3 THEN 'SWY Syndication Asset'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZDATASTORECLASSID || ']'
    END AS InternalResourceDataStoreClassId,

    CASE ZASSET.ZCLOUDPLACEHOLDERKIND
        WHEN 0 THEN 'Local&CloudMaster Asset'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'Still Testing'
        WHEN 3 THEN 'JPG Asset Only PhotoData/Thumb/V2'
        WHEN 4 THEN 'LPL JPG Asset CPL Asset HEIC JPG JPEG MOV PNG'
        WHEN 5 THEN 'Asset synced via iCloud Photos 2 Device'
        WHEN 6 THEN 'Still Testing'
        WHEN 7 THEN 'LPL poster JPG Asset CPL Asset MP4'
        WHEN 8 THEN 'LPL JPG Asset CPL Asset LivePhoto MOV'
        WHEN 9 THEN 'CPL MP4 Asset Saved 2 LPL'
        ELSE 'Type: [' || ZASSET.ZCLOUDPLACEHOLDERKIND || ']'
    END AS AssetCloudPlaceHolderKind,

    CASE ZINTERNALRESOURCE.ZLOCALAVAILABILITY
        WHEN -1 THEN 'IR Asset Not Available Local Device'
        WHEN 1 THEN 'IR Asset Available Local Device'
        WHEN -32768 THEN 'IR Asset SWY Linked Asset'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZLOCALAVAILABILITY || ']'
    END AS InternalResourceLocalAvailability,

    CASE ZINTERNALRESOURCE.ZLOCALAVAILABILITYTARGET
        WHEN 0 THEN 'Still Testing'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZLOCALAVAILABILITYTARGET || ']'
    END AS InternalResourceLocalAvailabilityTarget,

    CASE ZINTERNALRESOURCE.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'IR Asset Not Synced No IR CldMast Date Created'
        WHEN 1 THEN 'IR Asset Pening Upload'
        WHEN 2 THEN 'IR Asset Photo Cloud Share Asset On Local Device'
        WHEN 3 THEN 'IR Asset Synced iCloud'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZCLOUDLOCALSTATE || ']'
    END AS InternalResourceCloudLocalState,

    CASE ZINTERNALRESOURCE.ZREMOTEAVAILABILITY
        WHEN 0 THEN 'IR Asset Not Available Remotely'
        WHEN 1 THEN 'IR Asset Available Remotely'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZREMOTEAVAILABILITY || ']'
    END AS InternalResourceRemoteAvailability,

    CASE ZINTERNALRESOURCE.ZREMOTEAVAILABILITYTARGET
        WHEN 0 THEN 'Still Testing'
        WHEN 1 THEN 'Still Testing'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZREMOTEAVAILABILITYTARGET || ']'
    END AS InternalResourceRemoteAvailabilityTarget,

    ZINTERNALRESOURCE.ZTRANSIENTCLOUDMASTER AS InternalResourceTransientCloudMaster,
    ZINTERNALRESOURCE.ZSIDECARINDEX AS InternalResourceSideCarIndex,
    ZINTERNALRESOURCE.ZFILEID AS InternalResourceFileId,

    CASE ZINTERNALRESOURCE.ZVERSION
        WHEN 0 THEN 'IR Asset Standard'
        WHEN 1 THEN 'Still Testing'
        WHEN 2 THEN 'IR Asset Adjustments Mutation'
        WHEN 3 THEN 'IR Asset No IR CldMastDateCreated'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZVERSION || ']'
    END AS InternalResourceVersion,

    ZADDASSETATTR.ZORIGINALFILESIZE AS AddAssetAttrOriginalFileSize,

    CASE ZINTERNALRESOURCE.ZRESOURCETYPE
        WHEN 0 THEN 'Photo'
        WHEN 1 THEN 'Video'
        WHEN 3 THEN 'Live Photo'
        WHEN 5 THEN 'Adjustement Data'
        WHEN 6 THEN 'Screenshot'
        WHEN 9 THEN 'Alternate Photo 3rd PartyApp - Still Testing'
        WHEN 13 THEN 'Movie'
        WHEN 14 THEN 'Wallpaper'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZRESOURCETYPE || ']'
    END AS InternalResourceResourceType,

    -- hex ( ZINTERNALRESOURCE.ZDATASTOREKEYDATA ) AS InternalResourceDataStoreKeyDataHex,

    CASE ZINTERNALRESOURCE.ZDATASTORESUBTYPE
        WHEN 0 THEN 'No Cloud Inter Resource'
        WHEN 1 THEN 'Main Asset Orig Size'
        WHEN 2 THEN 'Photo with Adjustments'
        WHEN 3 THEN 'JPG Large Thumb'
        WHEN 4 THEN 'JPG Med Thumb'
        WHEN 5 THEN 'JPG Small Thumb'
        WHEN 6 THEN 'Video Med Data'
        WHEN 7 THEN 'Video Small Data'
        WHEN 8 THEN 'MP4 Cloud Share'
        WHEN 9 THEN 'Still Testing'
        WHEN 10 THEN '3rd PartyApp thumb - Still Testing'
        WHEN 11 THEN 'Still Test'
        WHEN 12 THEN 'Still Test'
        WHEN 13 THEN 'PNG Optimized CPLAsset'
        WHEN 14 THEN 'Wallpaper'
        WHEN 15 THEN 'Has Markup and Adjustments'
        WHEN 16 THEN 'Video with Adjustments'
        WHEN 17 THEN 'RAW Photo'
        WHEN 18 THEN 'Live Photo Video Optimized CPLAsset'
        WHEN 19 THEN 'Live Photo with Adjustments'
        WHEN 20 THEN 'Still Test'
        WHEN 21 THEN 'Still Test'
        WHEN 22 THEN 'Adjust Mutation AAE Asset'
        WHEN 23 THEN 'Still Test'
        WHEN 24 THEN 'Still Test'
        WHEN 25 THEN 'Still Test'
        WHEN 26 THEN 'MOV Optimized CPLAsset'
        WHEN 27 THEN 'Still Test'
        WHEN 28 THEN 'MOV Med hdr Data'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZDATASTORESUBTYPE || ']'
    END AS InternalResourceDataStoreSubType,

    CASE ZINTERNALRESOURCE.ZCLOUDSOURCETYPE
        WHEN 0 THEN 'N/A'
        WHEN 1 THEN 'Main Asset Orig Size'
        WHEN 2 THEN 'Photo with Adjustments'
        WHEN 3 THEN 'JPG Large Thumb'
        WHEN 4 THEN 'JPG Med Thumb'
        WHEN 5 THEN 'JPG Small Thumb'
        WHEN 6 THEN 'Video Med Data'
        WHEN 7 THEN 'Video Small Data'
        WHEN 8 THEN 'MP4 Cloud Share'
        WHEN 9 THEN 'Still Testing'
        WHEN 10 THEN '3rd PartyApp thumb - Still Testing'
        WHEN 11 THEN 'Still Test'
        WHEN 12 THEN 'Still Test'
        WHEN 13 THEN 'PNG Optimized CPLAsset'
        WHEN 14 THEN 'Wallpaper'
        WHEN 15 THEN 'Has Markup and Adjustments'
        WHEN 16 THEN 'Video with Adjustments'
        WHEN 17 THEN 'RAW Photo'
        WHEN 18 THEN 'Live Photo Video Optimized CPLAsset'
        WHEN 19 THEN 'Live Photo with Adjustments'
        WHEN 20 THEN 'Still Testing'
        WHEN 21 THEN 'Still Testing'
        WHEN 22 THEN 'Adjust Mutation AAE Asset'
        WHEN 23 THEN 'Still Testing'
        WHEN 24 THEN 'Still Testing'
        WHEN 25 THEN 'Still Testing'
        WHEN 26 THEN 'MOV Optimized CPLAsset'
        WHEN 27 THEN 'Still Testing'
        WHEN 28 THEN 'MOV Med hdr Data'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZCLOUDSOURCETYPE || ']'
    END AS InternalResourceCloudSourceType,

    ZINTERNALRESOURCE.ZDATALENGTH AS InternalResourceDataLength,

    CASE ZINTERNALRESOURCE.ZRECIPEID
        WHEN 0 THEN 'Orig File Size Match Data Length or Optimized'
        WHEN 65739 THEN 'JPG Large Thumb'
        WHEN 65741 THEN 'Various Asset Types or Thumbs'
        WHEN 65743 THEN 'ResouType Photo 5003 or 5005 JPG Thumb'
        WHEN 65749 THEN 'LocalVideoKeyFrame JPG Thumb'
        WHEN 65938 THEN 'FullSizeRender Photo or plist'
        WHEN 131072 THEN 'FullSizeRender Video or plist'
        WHEN 131079 THEN 'Medium MP4 Adj Mutation Asset'
        WHEN 131081 THEN 'ResouType Video 5003 or 5005 JPG Thumb'
        WHEN 131272 THEN 'FullSizeRender Video LivePhoto Adj Mutation'
        WHEN 131275 THEN 'Medium MOV LivePhoto'
        WHEN 131277 THEN 'No IR Asset LivePhoto iCloud Sync Asset'
        WHEN 131475 THEN 'Medium hdr MOV'
        WHEN 327683 THEN 'JPG Thumb for 3rdParty Still Testing'
        WHEN 327687 THEN 'Wallpaper Compute Resource'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZRECIPEID || ']'
    END AS InternalResourceRecipeId,

    CASE ZINTERNALRESOURCE.ZCLOUDLASTPREFETCHDATE
        WHEN 0 THEN 'N/A'
        ELSE strftime ( '%F_%H:%M:%f', ZINTERNALRESOURCE.ZCLOUDLASTPREFETCHDATE + 978307200, 'unixepoch' )
    END AS InternalResourceCloudLastPrefetchDateUtc,

    ZINTERNALRESOURCE.ZCLOUDPREFETCHCOUNT AS InternalResourceCloudPrefetchCount,

    strftime ( '%F_%H:%M:%f', ZINTERNALRESOURCE.ZCLOUDLASTONDEMANDDOWNLOADDATE + 978307200, 'unixepoch' ) AS InternalResourceCloudLastOnDemandDownLoadDateUtc,

    CASE ZINTERNALRESOURCE.ZUTICONFORMANCEHINT
        WHEN 0 THEN 'N/A / Does not Conform'
        WHEN 1 THEN 'UT Type Image'
        WHEN 2 THEN 'Still Testing'
        WHEN 3 THEN 'UT Type Movie'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZUTICONFORMANCEHINT || ']'
    END AS InternalResourceUtiConformanceHint,

    CASE ZINTERNALRESOURCE.ZCOMPACTUTI
        WHEN 1 THEN 'jpeg/thm'
        WHEN 3 THEN 'heic'
        WHEN 6 THEN 'png'
        WHEN 7 THEN 'Still Testing'
        WHEN 23 THEN 'jpeg/heic/quicktime mov'
        WHEN 24 THEN 'mpeg4'
        WHEN 36 THEN 'Wallpaper'
        WHEN 37 THEN 'Adj/Mutation Data'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZCOMPACTUTI || ']'
    END AS InternalResourceCompactUti,

    ZASSET.ZUNIFORMTYPEIDENTIFIER AS AssetUniformTypeIdentifier,
    ZASSET.ZORIGINALCOLORSPACE AS AssetOriginalColorSpace,
    ZCLOUDMASTER.ZUNIFORMTYPEIDENTIFIER AS CloudMasterUniformTypeIdentifier,

    CASE ZCLOUDMASTER.ZFULLSIZEJPEGSOURCE
        WHEN 0 THEN 'CldMast JPEG Source Video'
        WHEN 1 THEN 'CldMast JPEG Source Other'
        ELSE 'Type: [' || ZCLOUDMASTER.ZFULLSIZEJPEGSOURCE || ']'
    END AS CloudMasterFullSizeJpegSource,

    ZASSET.ZHDRGAIN AS AssetHdrGain,

    CASE ZASSET.ZHDRTYPE
        WHEN 0 THEN 'No HDR'
        WHEN 3 THEN 'HDR Photo'
        WHEN 4 THEN 'Non-HDR Version'
        WHEN 5 THEN 'HEVC Movie'
        WHEN 6 THEN 'Panorama'
        WHEN 10 THEN 'HDR Gain'
        ELSE 'Type: [' || ZASSET.ZHDRTYPE || ']'
    END AS AssetHdrType,

    ZEXTATTR.ZCODEC AS ExtAttrCodec,
    ZINTERNALRESOURCE.ZCODECFOURCHARCODENAME AS InternalResourceCodecFourCharCodeName,
    ZCLOUDMASTER.ZCODECNAME AS CloudMasterCodecName,
    ZCLOUDMASTER.ZVIDEOFRAMERATE AS CloudMasterVideoFrameRate,
    ZCLOUDMASTER.ZPLACEHOLDERSTATE AS CloudMasterPlaceHolderState,

    CASE ZASSET.ZDEPTHTYPE
        WHEN 0 THEN 'NoPortrait'
        ELSE 'Portrait: ' || ZASSET.ZDEPTHTYPE || ']'
    END AS AssetDepthType,

    ZASSET.ZAVALANCHEUUID AS AssetAvalancheUuid,

    CASE ZASSET.ZMONOSKITYPE
        WHEN 0 THEN 'StillTestingNoMonoski'
        ELSE 'Type: [' || ZASSET.ZMONOSKITYPE || ']'
    END AS AssetMonoSkiType,

    CASE ZASSET.ZAVALANCHEPICKTYPE
        WHEN 0 THEN 'N/A-SingleAssetBurstUUID'
        WHEN 2 THEN 'BurstAssetNotSelected'
        WHEN 4 THEN 'BurstAssetPhotosAppPickedKeyImage'
        WHEN 8 THEN 'BurstAssetSelectedForLPL'
        WHEN 16 THEN 'TopBurstAssetInStackKeyImage'
        WHEN 32 THEN 'StillTesting'
        WHEN 52 THEN 'BurstAssetVisibleLPL'
        ELSE 'Type: [' || ZASSET.ZAVALANCHEPICKTYPE || ']'
    END AS AssetAvalanchePickType,

    CASE ZADDASSETATTR.ZCLOUDAVALANCHEPICKTYPE
        WHEN 0 THEN 'N/A-SingleAssetBurstUUID'
        WHEN 2 THEN 'BurstAssetNotSelected'
        WHEN 4 THEN 'BurstAssetPhotosAppPickedKeyImage'
        WHEN 8 THEN 'BurstAssetSelectedforLPL'
        WHEN 16 THEN 'TopBurstAssetInStackKeyImage'
        WHEN 32 THEN 'StillTesting'
        WHEN 52 THEN 'BurstAssetVisibleLPL'
        ELSE 'Type: [' || ZADDASSETATTR.ZCLOUDAVALANCHEPICKTYPE || ']'
    END AS AddAssetAttrCloudAvalanchePickType,

    CASE ZADDASSETATTR.ZCLOUDRECOVERYSTATE
        WHEN 0 THEN 'StillTesting'
        WHEN 1 THEN 'StillTesting'
        ELSE 'Type: [' || ZADDASSETATTR.ZCLOUDRECOVERYSTATE || ']'
    END AS AddAssetAttrCloudRecoveryState,

    ZADDASSETATTR.ZCLOUDSTATERECOVERYATTEMPTSCOUNT AS AddAssetAttrCloudStateRecoveryAttemptsCount,
    ZASSET.ZDEFERREDPROCESSINGNEEDED AS AssetDeferredProcessingNeeded,
    ZASSET.ZVIDEODEFERREDPROCESSINGNEEDED AS AssetVideoDeferredProcessingNeeded,
    ZADDASSETATTR.ZDEFERREDPHOTOIDENTIFIER AS AddAssetAttrDeferredPhotoIdentifier,
    ZADDASSETATTR.ZDEFERREDPROCESSINGCANDIDATEOPTIONS AS AddAssetAttrDeferredProcessingCandidateOptions,

    CASE ZASSET.ZHASADJUSTMENTS
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE 'Type: [' || ZASSET.ZHASADJUSTMENTS || ']'
    END AS AssetHasAdjustments,

    --[ZUNMANAGEDADJUSTMENT.ZASSETATTRIBUTES = ZADDASSETATTR.Z_PK]
    ZUNMANAGEDADJUSTMENT.ZASSETATTRIBUTES AS UnManagedAdjustmentAssetAttributes,

    --[ZADDASSETATTR.ZUNMANAGEDADJUSTMENT = ZUNMANAGEDADJUSTMENT.Z_PK]
    ZADDASSETATTR.ZUNMANAGEDADJUSTMENT AS AddAssetAttrUnmanagedAdjustment,

    --[ZUNMANAGEDADJUSTMENT.Z_PK = ZADDASSETATTR.ZUnmanAdj]
    ZUNMANAGEDADJUSTMENT.Z_PK AS UnManagedAdjustmentZPk,

    ZUNMANAGEDADJUSTMENT.ZUUID AS UnManagedAdjustmentUuid,

    strftime ( '%F_%H:%M:%f', ZASSET.ZADJUSTMENTTIMESTAMP + 978307200, 'unixepoch' ) AS AssetAdjustmentTimestampUtc,
    strftime ( '%F_%H:%M:%f', ZUNMANAGEDADJUSTMENT.ZADJUSTMENTTIMESTAMP + 978307200, 'unixepoch' ) AS UnManagedAdjustmentAdjustmentTimestampUtc,

    ZADDASSETATTR.ZEDITORBUNDLEID AS AddAssetAttrEditorBundleId,
    ZUNMANAGEDADJUSTMENT.ZEDITORLOCALIZEDNAME AS UnManagedAdjustmentEditorLocalizedName,
    ZUNMANAGEDADJUSTMENT.ZADJUSTMENTFORMATIDENTIFIER AS UnManagedAdjustmentAdjustmentFormatIdentifier,
    ZADDASSETATTR.ZMONTAGE AS AddAssetAttrMontage,

    CASE ZUNMANAGEDADJUSTMENT.ZADJUSTMENTRENDERTYPES
        WHEN 0 THEN 'StandardOrPortraitWithErros'
        WHEN 1 THEN 'StillTesting'
        WHEN 2 THEN 'Portrait'
        WHEN 3 THEN 'StillTesting'
        WHEN 4 THEN 'StillTesting'
        ELSE 'Type: [' || ZUNMANAGEDADJUSTMENT.ZADJUSTMENTRENDERTYPES || ']'
    END AS UnManagedAdjustmentAdjustmentRenderTypes,

    CASE ZUNMANAGEDADJUSTMENT.ZADJUSTMENTFORMATVERSION
        WHEN 1.0 THEN 'Markup'
        WHEN 1.1 THEN 'Slow-Mo'
        WHEN 1.2 THEN 'StillTesting'
        WHEN 1.3 THEN 'StillTesting'
        WHEN 1.4 THEN 'Filter'
        WHEN 1.5 THEN 'Adjust'
        WHEN 1.6 THEN 'VideoTrim'
        WHEN 1.7 THEN 'StillTesting'
        WHEN 1.8 THEN 'StillTesting'
        WHEN 1.9 THEN 'StillTesting'
        WHEN 2.0 THEN 'ScreenshotServices'
        ELSE 'Type: [' || ZUNMANAGEDADJUSTMENT.ZADJUSTMENTFORMATVERSION || ']'
    END AS UnManagedAdjustmentAdjustmentFormatVersion,

    ZUNMANAGEDADJUSTMENT.ZADJUSTMENTBASEIMAGEFORMAT AS UnManagedAdjustmentAdjustmentBaseImageFormat,

    CASE ZASSET.ZFAVORITE
        WHEN 0 THEN 'NotFavorite'
        WHEN 1 THEN 'Favorite'
        ELSE 'Type: [' || ZASSET.ZFAVORITE || ']'
    END AS AssetFavorite,

    CASE ZASSET.ZHIDDEN
        WHEN 0 THEN 'NotHidden'
        WHEN 1 THEN 'Hidden'
        ELSE 'Type: [' || ZASSET.ZHIDDEN || ']'
    END AS AssetHidden,

    CASE ZASSET.ZTRASHEDSTATE
        WHEN 0 THEN 'NotInTrash'
        WHEN 1 THEN 'InTrash'
        ELSE 'Type: [' || ZASSET.ZTRASHEDSTATE || ']'
    END AS AssetTrashedState,

    strftime ( '%F_%H:%M:%f', ZASSET.ZTRASHEDDATE + 978307200, 'unixepoch' ) AS AssetTrashedDateUtc,

    CASE ZASSET.ZDELETEREASON
        WHEN NULL THEN NULL
        WHEN 1 THEN 'StillTesting'
        WHEN 2 THEN 'StillTesting'
        WHEN 3 THEN 'StillTesting'
        ELSE 'Type: [' || ZASSET.ZDELETEREASON || ']'
    END AS AssetDeletedReason,

    CASE ZASSET.ZTRASHEDBYPARTICIPANT
        WHEN NULL THEN NULL
        WHEN 0 THEN 'NotTrashedByParticipant'
        WHEN 1 THEN 'TrashedByParticipant'
        ELSE 'Type: [' || ZASSET.ZTRASHEDBYPARTICIPANT || ']'
    END AS AssetTrashedByParticipant,

    CASE ZINTERNALRESOURCE.ZTRASHEDSTATE
        WHEN 0 THEN 'NotInTrash'
        WHEN 1 THEN 'InTrash'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZTRASHEDSTATE || ']'
    END AS InternalResourceTrashedState,

    strftime ( '%F_%H:%M:%f', ZINTERNALRESOURCE.ZTRASHEDDATE + 978307200, 'unixepoch' ) AS InternalResourceTrashedDateUtc,

    CASE ZASSET.ZCLOUDDELETESTATE
        WHEN 0 THEN 'CloudAssetNotDeleted'
        WHEN 1 THEN 'CloudAssetDeleted'
        ELSE 'Type: [' || ZASSET.ZCLOUDDELETESTATE || ']'
    END AS AssetCloudDeleteState,

    CASE ZINTERNALRESOURCE.ZCLOUDDELETESTATE
        WHEN 0 THEN 'CloudIntResouNotDeleted'
        WHEN 1 THEN 'CloudIntResouDeleted'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZCLOUDDELETESTATE || ']'
    END AS InternalResourceCloudDeleteState,

    CASE ZADDASSETATTR.ZPTPTRASHEDSTATE
        WHEN 0 THEN 'PtpNotInTrash'
        WHEN 1 THEN 'PtpInTrash'
        ELSE 'Type: [' || ZADDASSETATTR.ZPTPTRASHEDSTATE || ']'
    END AS AddAssetAttrPtpTrashedState,

    CASE ZINTERNALRESOURCE.ZPTPTRASHEDSTATE
        WHEN 0 THEN 'PtpIntResouNotInTrash'
        WHEN 1 THEN 'PtpIntResouInTrash'
        ELSE 'Type: [' || ZINTERNALRESOURCE.ZPTPTRASHEDSTATE || ']'
    END AS InternalResourcePtpTrashedState,

    ZINTERNALRESOURCE.ZCLOUDDELETEASSETUUIDWITHRESOURCETYPE AS InternalResourceCloudDeleteAssetUuidWithResourceType,

    strftime ( '%F_%H:%M:%f', zMedAnlyAstAttr.ZMEDIAANALYSISTIMESTAMP + 978307200, 'unixepoch' ) AS MedAnlyAstAttrMediaAnalysisTimestampUtc,

    ZADDASSETATTR.ZPENDINGVIEWCOUNT AS AddAssetAttrPendingViewCount,
    ZADDASSETATTR.ZVIEWCOUNT AS AddAssetAttrViewCount,
    ZADDASSETATTR.ZPENDINGPLAYCOUNT AS AddAssetAttrPendingPlayCount,
    ZADDASSETATTR.ZPLAYCOUNT AS AddAssetAttrPlayCount,
    ZADDASSETATTR.ZPENDINGSHARECOUNT AS AddAssetAttrPendingShareCount,
    ZADDASSETATTR.ZSHARECOUNT AS AddAssetAttrShareCount,

    strftime ( '%F_%H:%M:%f', ZASSET.ZLASTSHAREDDATE + 978307200, 'unixepoch' ) AS AssetLastSharedDateUtc,

    ZADDASSETATTR.ZSHAREORIGINATOR AS AddAssetAttrShareOriginator,

    CASE ZADDASSETATTR.ZALLOWEDFORANALYSIS
        WHEN 0 THEN 'AssetNotAllowedForAnalysis'
        WHEN 1 THEN 'AssetAllowedForAnalysis'
        ELSE 'Type: [' || ZADDASSETATTR.ZALLOWEDFORANALYSIS || ']'
    END AS AddAssetAttrAllowedForAnalysis,

    ZADDASSETATTR.ZSCENEANALYSISVERSION AS AddAssetAttrSceneAnalysisVersion,

    CASE ZADDASSETATTR.ZSCENEANALYSISISFROMPREVIEW
        WHEN 0 THEN 'No'
        ELSE 'Type: [' || ZADDASSETATTR.ZSCENEANALYSISISFROMPREVIEW || ']'
    END AS AddAssetAttrSceneAnalysisIsFromPreview,

    strftime ( '%F_%H:%M:%f', ZADDASSETATTR.ZSCENEANALYSISTIMESTAMP + 978307200, 'unixepoch' ) AS AddAssetAttrSceneAnalysisTimestampUtc,

    CASE ZASSET.ZDUPLICATEASSETVISIBILITYSTATE
        WHEN 0 THEN 'NoDuplicates'
        WHEN 1 THEN 'HasDuplicate'
        WHEN 2 THEN 'IsADuplicate'
        ELSE 'Type: [' || ZASSET.ZDUPLICATEASSETVISIBILITYSTATE || ']'
    END AS AssetDuplicateAssetVisibilityState,

    CASE ZADDASSETATTR.ZDESTINATIONASSETCOPYSTATE
        WHEN 0 THEN 'NoCopy'
        WHEN 1 THEN 'HasACopy'
        WHEN 2 THEN 'HasACopy'
        ELSE 'Type: [' || ZADDASSETATTR.ZDESTINATIONASSETCOPYSTATE || ']'
    END AS AddAssetAttrDestinationAssetCopyState,

    -- hex ( ZSCENEPRINT.ZDATA ) AS ScenePrintDataHexNSKeyedPlist,
    -- hex ( ZSCENEPRINT.ZDUPLICATEMATCHINGDATA ) AS ScenePrintDuplicateMatchingDataHexNSKeyedPlist,
    -- hex ( ZSCENEPRINT.ZDUPLICATEMATCHINGALTERNATEDATA ) AS ScenePrintDuplicateMatchingAlternateDataHexNSKeyedPlist,

    ZADDASSETATTR.ZSOURCEASSETFORDUPLICATIONSCOPEIDENTIFIER AS AddAssetAttrSourceAssetForDuplicationScopeIdentifier,
    ZCLOUDMASTER.ZSOURCEMASTERFORDUPLICATIONSCOPEIDENTIFIER AS CloudMasterSourceMasterForDuplicationScopeIdentifier,
    ZADDASSETATTR.ZSOURCEASSETFORDUPLICATIONIDENTIFIER AS AddAssetAttrSourceAssetForDuplicationIdentifier,
    ZCLOUDMASTER.ZSOURCEMASTERFORDUPLICATIONIDENTIFIER AS CloudMasterSourceMasterForDuplicationIdentifier,

    /* Source for each line of data */
    'private/var/mobile/Library/Photos/Libraries/Syndication.photoslibrary/database/Photos.sqlite; ZASSET(Z_PK:' || ZASSET.Z_PK || ')' AS DataSource


FROM ZASSET
    LEFT JOIN ZADDITIONALASSETATTRIBUTES ZADDASSETATTR ON ZADDASSETATTR.Z_PK = ZASSET.ZADDITIONALATTRIBUTES
    LEFT JOIN ZEXTENDEDATTRIBUTES ZEXTATTR ON ZEXTATTR.Z_PK = ZASSET.ZEXTENDEDATTRIBUTES
    LEFT JOIN ZINTERNALRESOURCE ON ZINTERNALRESOURCE.ZASSET = ZASSET.Z_PK
    LEFT JOIN ZSCENEPRINT ON ZSCENEPRINT.Z_PK = ZADDASSETATTR.ZSCENEPRINT
    LEFT JOIN Z_28ASSETS ON Z_28ASSETS.Z_3ASSETS = ZASSET.Z_PK
    LEFT JOIN ZGENERICALBUM zGenAlbum ON zGenAlbum.Z_PK = Z_28ASSETS.Z_28ALBUMS
    LEFT JOIN ZUNMANAGEDADJUSTMENT ON ZADDASSETATTR.ZUNMANAGEDADJUSTMENT = ZUNMANAGEDADJUSTMENT.Z_PK
    LEFT JOIN Z_27ALBUMLISTS ON Z_27ALBUMLISTS.Z_27ALBUMS = zGenAlbum.Z_PK
    LEFT JOIN ZALBUMLIST ON ZALBUMLIST.Z_PK = Z_27ALBUMLISTS.Z_2ALBUMLISTS
    LEFT JOIN ZGENERICALBUM ParentzGenAlbum ON ParentzGenAlbum.Z_PK = zGenAlbum.ZPARENTFOLDER
    LEFT JOIN ZCLOUDMASTER ON ZASSET.ZMASTER = ZCLOUDMASTER.Z_PK
    LEFT JOIN ZCLOUDMASTERMEDIAMETADATA AAAzCldMastMedData ON AAAzCldMastMedData.Z_PK = ZADDASSETATTR.ZMEDIAMETADATA
    LEFT JOIN ZCLOUDMASTERMEDIAMETADATA CMzCldMastMedData ON CMzCldMastMedData.Z_PK = ZCLOUDMASTER.ZMEDIAMETADATA
    LEFT JOIN ZMEDIAANALYSISASSETATTRIBUTES zMedAnlyAstAttr ON ZASSET.ZMEDIAANALYSISATTRIBUTES = zMedAnlyAstAttr.Z_PK
    LEFT JOIN ZSHARE ON ZSHARE.Z_PK = ZASSET.ZMOMENTSHARE


ORDER BY ZASSET.ZADDEDDATE
