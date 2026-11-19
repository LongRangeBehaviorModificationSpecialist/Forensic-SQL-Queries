/*
[DLU]
    15-Jul-2025

Query copied from https://github.com/ScottKjr3347/iOS_SWY_PL_Photos.sqlite_Queries/blob/main/iOS16/iOS16_SWY-PL_Phsql_Basic.txt
*/

SELECT
    ROW_NUMBER() OVER ( ORDER BY  ) AS "RowNumber",
    ZASSET.Z_PK AS 'ZASSET.ZPk ',
    -- ZASSET.ZSORTTOKEN AS 'ZASSET.ZSORTTOKEN',
    -- ZASSET.ZPROMOTIONSCORE AS 'ZASSET.ZPROMOTIONSCORE',

    CASE ZASSET.ZCOMPLETE
        WHEN 1 THEN 'Yes [1]'
        ELSE ZASSET.ZCOMPLETE
    END AS 'ZASSET.Complete',

    ZADDASSETATTR.Z_PK AS 'ZADDASSETATTR.ZPk',

    -- [ZCLOUDMASTER.Z_PK = ZASSET.ZMASTER]
    ZCLOUDMASTER.Z_PK AS 'ZCLOUDMASTER.ZPk',

    -- [ZASSET.ZMASTER = ZCLOUDMASTER.Z_PK]
    ZASSET.ZMASTER AS 'ZASSET.Master',

    -- [ZASSET.ZEXTENDEDATTRIBUTES = ZEXTATTR.Z_PK]
    ZASSET.ZEXTENDEDATTRIBUTES AS 'ZASSET.ExtendedAttributes',

    -- [ZEXTATTR.Z_PK = ZASSET.ZEXTENDEDATTRIBUTES]
    ZEXTATTR.Z_PK AS 'ZEXTATTR.ZPk',

    -- [CMzCldMastMedData-CldMast = ZCLOUDMASTER.Z_PK]
    CMzCldMastMedData.ZCLOUDMASTER AS 'CMzCldMastMedData.CloudMaster',

    -- [ZCLOUDMASTER.ZMEDIAMETADATA = zCldMastMedData.Z_PK]
    ZCLOUDMASTER.ZMEDIAMETADATA AS 'ZCLOUDMASTER.MediaMetadata',

    -- [CMzCldMastMedData.Z_PK=ZADDASSETATTR&ZCLOUDMASTER.ZMEDIAMETADATA]
    CMzCldMastMedData.Z_PK AS 'CMzCldMastMedData.ZPk',
    CMzCldMastMedData.Z_ENT AS 'CMzCldMastMedData.ZEnt',

    -- [ZASSET.UUID = store.cloudphotodb]
    ZASSET.ZUUID AS 'ZASSET.Uuid',
    ZASSET.ZDIRECTORY AS 'ZASSET.Directory',
    ZASSET.ZFILENAME AS 'ZASSET.Filename',
    CONCAT(ZASSET.ZDIRECTORY,'/',ZASSET.ZFILENAME) AS filepath,
    ZADDASSETATTR.ZORIGINALFILENAME AS 'ZADDASSETATTR.OriginalFileName',
    ZCLOUDMASTER.ZORIGINALFILENAME AS 'ZCLOUDMASTER.OriginalFileName ',

    /* The GUID value in this column matches the GUID of the message from the sms.db file */
    ZADDASSETATTR.ZSYNDICATIONIDENTIFIER AS 'ZADDASSETATTR.SyndicationIdentifier',

    -- [ZASSET.Cloud_Asset_GUID = store.cloudphotodb]
    ZASSET.ZCLOUDASSETGUID AS 'ZASSET.CloudAssetGuid',
    ZASSET.ZCLOUDCOLLECTIONGUID AS 'ZASSET.CloudCollectionGuid',

    -- [ZCLOUDMASTER.ZCLOUDMASTERGUID = store.cloudphotodb]
    ZCLOUDMASTER.ZCLOUDMASTERGUID AS 'ZCLOUDMASTER.CloudMasterGuid',

    -- [zGenAlbum.ZCLOUDGUID = store.cloudphotodb]
    zGenAlbum.ZCLOUDGUID AS 'ZGENERICALBUM.CloudGuid',

    -- [ZSHARE.ZSCOPEIDENTIFIER = store.cloudphotodb]
    ZSHARE.ZSCOPEIDENTIFIER AS 'ZSHARE.ScopeIdentifier',
    ZADDASSETATTR.ZORIGINALASSETSUUID AS 'ZADDASSETATTR.OriginalAssetsUuid',
    ZADDASSETATTR.ZPUBLICGLOBALUUID AS 'ZADDASSETATTR.PublicGlobalUuid',
    ZADDASSETATTR.ZMASTERFINGERPRINT AS 'ZADDASSETATTR.MasterFingerprint',
    ZADDASSETATTR.ZORIGINATINGASSETIDENTIFIER AS 'ZADDASSETATTR.OriginatingAssetIdentifier',
    ZCLOUDMASTER.ZORIGINATINGASSETIDENTIFIER AS 'ZCLOUDMASTER.OriginatingAssetIdentifier',
    ZINTERNALRESOURCE.ZFINGERPRINT AS 'ZINTERNALRESOURCE.Fingerprint',
    ZADDASSETATTR.ZADJUSTEDFINGERPRINT AS 'ZADDASSETATTR.AdjustedFingerprint',
    ZUNMANAGEDADJUSTMENT.ZOTHERADJUSTMENTSFINGERPRINT AS 'ZUNMANAGEDADJUSTMENT.OtherAdjustmentsFingerprint',
    ZUNMANAGEDADJUSTMENT.ZSIMILARTOORIGINALADJUSTMENTSFINGERPRINT AS 'ZUNMANAGEDADJUSTMENT.SimilarToOriginalAdjustmentsFingerprint',

    CASE
        WHEN ZASSET.ZADDEDDATE < 0 THEN 'Invalid Date/Time Value: [' || ZASSET.ZADDEDDATE || ']'
        ELSE datetime(ZASSET.ZADDEDDATE + 978307200, 'unixepoch')
    END AS 'ZASSET.AddedDateUtc',

    CASE
        WHEN ZASSET.ZDATECREATED < 0 THEN 'Invalid Date/Time Value: [' || ZASSET.ZDATECREATED || ']'
        ELSE datetime(ZASSET.ZDATECREATED + 978307200, 'unixepoch')
    END AS 'ZASSET.DateCreatedUtc',

    datetime(ZASSET.ZMODIFICATIONDATE + 978307200, 'unixepoch') AS 'ZASSET.ModificationDateUtc',

    CASE
        WHEN NULL THEN NULL
        ELSE datetime(ZASSET.ZANALYSISSTATEMODIFICATIONDATE + 978307200, 'unixepoch')
    END AS 'ZASSET.AnalysisStateModificationDateUtc',

    datetime(ZCLOUDMASTER.ZCREATIONDATE + 978307200, 'unixepoch') AS 'ZCLOUDMASTER.CreationDateUtc',
    datetime(ZINTERNALRESOURCE.ZCLOUDMASTERDATECREATED + 978307200, 'unixepoch') AS 'ZINTERNALRESOURCE.CloudMasterDateCreatedUtc',

    ZADDASSETATTR.ZIMPORTEDBYBUNDLEIDENTIFIER AS 'ZADDASSETATTR.ImportedByBundleIdentifier',
    ZADDASSETATTR.ZIMPORTEDBYDISPLAYNAME AS 'ZADDASSETATTR.ImportedByDisplayName',
    ZADDASSETATTR.ZORIGINALHEIGHT AS 'ZADDASSETATTR.OriginalHeight',
    ZADDASSETATTR.ZORIGINALWIDTH AS 'ZADDASSETATTR.OriginalWidth',
    ZADDASSETATTR.ZORIGINALORIENTATION AS 'ZADDASSETATTR.OriginalOrientation',
    printf("%,d", ZADDASSETATTR.ZORIGINALFILESIZE) AS 'ZADDASSETATTR.OriginalFileSize',
    ZCLOUDMASTER.ZIMPORTEDBYBUNDLEIDENTIFIER AS 'ZCLOUDMASTER.ImportedByBundleIdentifier',
    ZCLOUDMASTER.ZIMPORTEDBYDISPLAYNAME AS 'ZCLOUDMASTER.ImportedbyDisplayName',

    CASE ParentzGenAlbum.ZCLOUDLOCALSTATE
        WHEN 0 THEN 'iCloudPhotos ON=Asset In Shared/Other Album / iCloudPhotos OFF=Generic Album [0]'
        WHEN 1 THEN 'iCloudPhotos ON=Asset In Generic Album [1]'
        ELSE 'Unknown Value: ' || ParentzGenAlbum.ZCLOUDLOCALSTATE || ''
    END AS 'ParentzGenAlbum.CloudLocalState',

    ParentzGenAlbum.ZTITLE AS 'ParentzGenAlbum.Title',

    datetime(ParentzGenAlbum.ZCREATIONDATE + 978307200, 'unixepoch') AS 'ParentzGenAlbum.CreationDateUtc',
    datetime(zGenAlbum.ZCREATIONDATE + 978307200, 'unixepoch') AS 'zGenAlbum.CreationDateUtc',

    CASE zGenAlbum.ZCLOUDLOCALSTATE
        WHEN 0 THEN '0 [iCloudPhotos ON=Asset In Shared/Other Album / iCloudPhotos OFF=Generic Album]'
        WHEN 1 THEN '1 [iCloudPhotos ON=Asset In Generic Album]'
        ELSE 'Unknown Value: ' || zGenAlbum.ZCLOUDLOCALSTATE || ''
    END AS 'zGenAlbum.CloudLocalState',

    zGenAlbum.ZTITLE AS 'zGenAlbum.Title',

	CASE ZADDASSETATTR.ZIMPORTEDBY
        WHEN 0 THEN '0 [Cloud Other]'
        WHEN 1 THEN '1 [Native Back Camera]'
        WHEN 2 THEN '2 [Native Front Camera]'
        WHEN 3 THEN '3 [Third Party App]'
        WHEN 4 THEN '4 [Still Testing]'
        WHEN 5 THEN '5 [PhotoBooth PL Asset]'
        WHEN 6 THEN '6 [Third Party App]'
        WHEN 7 THEN '7 [iCloud Share Link CMMAsset]'
        WHEN 8 THEN '8 [System Package App]'
        WHEN 9 THEN '9 [Native App]'
        WHEN 10 THEN '10 [Still Testing]'
        WHEN 11 THEN '11 [Still Testing]'
        WHEN 12 THEN '12 [SWY Syndication PL]'
        ELSE 'Unknown Value: ' || ZADDASSETATTR.ZIMPORTEDBY || ''
    END AS 'ZADDASSETATTR.ImportedBy',

    datetime(ZCLOUDMASTER.ZIMPORTDATE + 978307200, 'unixepoch') AS 'ZCLOUDMASTER.ImportDateUtc',

	CASE ZCLOUDMASTER.ZIMPORTEDBY
        WHEN 0 THEN '0 [Cloud Other]'
        WHEN 1 THEN '1 [Native Back Camera]'
        WHEN 2 THEN '2 [Native Front Camera]'
        WHEN 3 THEN '3 [Third Party App]'
        WHEN 4 THEN '4 [Still Testing]'
        WHEN 5 THEN '5 [PhotoBooth PL Asset]'
        WHEN 6 THEN '6 [Third Party App]'
        WHEN 7 THEN '7 [iCloud Share Link CMMAsset]'
        WHEN 8 THEN '8 [System Package App]'
        WHEN 9 THEN '9 [Native App]'
        WHEN 10 THEN '10 [Still Testing]'
        WHEN 11 THEN '11 [Still Testing]'
        WHEN 12 THEN '12 [SWY Syndication PL]'
        ELSE 'Unknown Value: ' || ZCLOUDMASTER.ZIMPORTEDBY || ''
    END AS 'ZCLOUDMASTER.ImportedBy',

    -- hex(ZASSET.ZIMAGEREQUESTHINTS) AS 'ZASSET.ZIMAGEREQUESTHINTS(HEX)',

    CASE ZASSET.ZBUNDLESCOPE
        WHEN 0 THEN '0 [iCloudPhotos ON=Not In Shared Album iCloudPhotos OFF=On Local Device]'
        WHEN 1 THEN '1 [SWY Syndication CMMAsset]'
        WHEN 2 THEN '2 [iCloudPhotos ON=Asset In Cloud Shared Album]'
        WHEN 3 THEN '3 [iCloudPhotos ON=SWY Syndication Asset]'
        ELSE 'Unknown Value: ' || ZASSET.ZBUNDLESCOPE || ''
    END AS 'ZASSET.BundleScope',

    CASE ZASSET.ZCLOUDISMYASSET
        WHEN 0 THEN '0 [Not My Asset in Shared Album]'
        WHEN 1 THEN '1 [My Asset in Shared Album]'
        ELSE 'Unknown Value: ' || ZASSET.ZCLOUDISMYASSET || ''
    END AS 'ZASSET.CloudIsMyAsset',

    CASE ZASSET.ZCLOUDISDELETABLE
        WHEN 0 THEN '0 [No]'
        WHEN 1 THEN '1 [Yes]'
        ELSE 'Unknown Value: ' || ZASSET.ZCLOUDISDELETABLE || ''
    END AS 'ZASSET.CloudIsDeletable',

    CASE ZASSET.ZCLOUDLOCALSTATE
        WHEN 0 THEN '0 [iCloudPhotos ON=Asset In Shared Other Album/iCloudPhotos OFF=Not Synced]'
        WHEN 1 THEN '1 [iCloudPhotos ON=Asset Synced with iCloud]'
        ELSE 'Unknown Value: ' || ZASSET.ZCLOUDLOCALSTATE || ''
    END AS 'ZASSET.CloudLocalState',

    CASE ZASSET.ZVISIBILITYSTATE
        WHEN 0 THEN '0 [Visible Photo Library]'
        WHEN 2 THEN '2 [Not Visible Photo Library]'
        ELSE 'Unknown Value: ' || ZASSET.ZVISIBILITYSTATE || ''
    END AS 'ZASSET.visibilityState',

    ZEXTATTR.ZCAMERAMAKE AS 'ZEXTATTR.CameraMake',
    ZEXTATTR.ZCAMERAMODEL AS 'ZEXTATTR.CameraModel',
    ZEXTATTR.ZLENSMODEL AS 'ZEXTATTR.LensModel',

    CASE ZEXTATTR.ZFLASHFIRED
        WHEN 0 THEN '0 [No Flash]'
        WHEN 1 THEN '1 [Flash Fired]'
        ELSE 'Unknown Value: ' || ZEXTATTR.ZFLASHFIRED || ''
    END AS 'ZEXTATTR.FlashFired',

    ZEXTATTR.ZFOCALLENGTH AS 'ZEXTATTR.FocalLength',
    ZEXTATTR.ZFOCALLENGTHIN35MM AS 'ZEXTATTR.FocalLengthIn35mm',
    ZEXTATTR.ZDIGITALZOOMRATIO AS 'ZEXTATTR.DigitalZoomRatio',

    CASE ZASSET.ZDERIVEDCAMERACAPTUREDEVICE
        WHEN 0 THEN '0 [Back Camera/Other]'
        WHEN 1 THEN '1 [Front Camera]'
        ELSE 'Unknown Value: ' || ZASSET.ZDERIVEDCAMERACAPTUREDEVICE || ''
    END AS 'ZASSET.DerivedCameraCaptureDevice',

    CASE ZADDASSETATTR.ZCAMERACAPTUREDEVICE
        WHEN 0 THEN '0 [Back Camera/Other]'
        WHEN 1 THEN '1 [Front Camera]'
        ELSE 'Unknown Value: ' || ZADDASSETATTR.ZCAMERACAPTUREDEVICE || ''
    END AS 'ZADDASSETATTR.CameraCaptureDevice',

    CASE ZASSET.ZSAVEDASSETTYPE
        WHEN 0 THEN '0 [Saved Via Other Source]'
        WHEN 1 THEN '1 [Still Testing]'
        WHEN 2 THEN '2 [Still Testing]'
        WHEN 3 THEN '3 [SWY Syndicaion PL Asset Not In Local PL]'
        WHEN 4 THEN '4 [Photo Cloud Sharing Data Asset]'
        WHEN 5 THEN '5 [Still Testing]'
        WHEN 6 THEN '6 [Cloud Photo Library Asset]'
        WHEN 7 THEN '7 [Still Testing]'
        WHEN 8 THEN '8 [iCloud Link CloudMaster Moment Asset]'
        WHEN 12 THEN '12 [SWY Syndicaion PL Asset In Local PL]'
        ELSE 'Unknown Value: ' || ZASSET.ZSAVEDASSETTYPE || ''
    END AS 'ZASSET.SavedAssetType',

    CASE ZASSET.ZSAVEDASSETTYPE
        WHEN 0 THEN '0 [Saved Via Other Source]'
        WHEN 1 THEN '1 [Still Testing]'
        WHEN 2 THEN '2 [Still Testing]'
        WHEN 3 THEN '3 [Local Photo Library Asset]'
        WHEN 4 THEN '4 [Photo Cloud Sharing Data Asset]'
        WHEN 5 THEN '5 [PhotoBooth Photo Library Asset]'
        WHEN 6 THEN '6 [Cloud Photo Library Asset]'
        WHEN 7 THEN '7 [Still Testing]'
        WHEN 8 THEN '8 [iCloud Link CloudMaster Moment Asset]'
        WHEN 12 THEN '12 [SWY Syndication PL Asset/Auto Displayed in LPL]'
        ELSE 'Unknown Value: ' || ZASSET.ZSAVEDASSETTYPE || ''
    END AS 'ZASSET.SavedAssetType',

    CASE ZASSET.ZSYNDICATIONSTATE
        WHEN 0 THEN '0 [Received SWY Synd Asset]'
        WHEN 1 THEN '1 [Sent SWY Synd Asset]'
        WHEN 2 THEN '2 [Manually Saved SWY Synd Asset]'
        WHEN 8 THEN '8 [SWY Linked Asset was Visible On Device User Deleted Link]'
        WHEN 10 THEN '10 [Manually Saved SWY Synd Asset User Deleted From LPL]'
        ELSE 'Unknown Value: ' || ZASSET.ZSYNDICATIONSTATE || ''
    END AS 'ZASSET.SyndicationState',

    ZADDASSETATTR.ZSYNDICATIONHISTORY AS 'ZADDASSETATTR.SyndicationHistory',
    zMedAnlyAstAttr.ZSYNDICATIONPROCESSINGVERSION AS 'zMedAnlyAstAttr.SyndicationProcessingVersion',

    CASE zMedAnlyAstAttr.ZSYNDICATIONPROCESSINGVALUE
        WHEN 0 THEN '0 [N/A]'
        WHEN 1 THEN '1 [Still Testing Wide Camera JPG]'
        WHEN 2 THEN '2 [Still Testing Telephoto Camear Lens]'
        WHEN 4 THEN '4 [Still Testing SWY Asset OrigAssetImport SystemPackageApp]'
        WHEN 16 THEN '16 [Still Testing]'
        WHEN 1024 THEN '1024 [Still Testing SWY Asset OrigAssetImport Native Camera]'
        WHEN 2048 THEN '2048 [Still Testing]'
        WHEN 4096 THEN '4096 [Still Testing SWY Asset Manually Saved]'
        ELSE 'Unknown Value: ' || zMedAnlyAstAttr.ZSYNDICATIONPROCESSINGVALUE || ''
    END AS 'zMedAnlyAstAttr.SyndicationProcessingValue',

    CASE ZADDASSETATTR.ZDATECREATEDSOURCE
        WHEN 0 THEN '0 [Cloud Asset]'
        WHEN 1 THEN '1 [Local Asset EXIF]'
        WHEN 3 THEN '3 [Local Asset No EXIF]'
        ELSE 'Unknown Value: ' || ZADDASSETATTR.ZDATECREATEDSOURCE || ''
    END AS 'ZADDASSETATTR.DateCreatedSource',

    ZADDASSETATTR.ZTIMEZONENAME AS 'ZADDASSETATTR.TimeZoneName',
    ZADDASSETATTR.ZTIMEZONEOFFSET AS 'ZADDASSETATTR.TimeZoneOffset',
    ZADDASSETATTR.ZINFERREDTIMEZONEOFFSET AS 'ZADDASSETATTR.InferredTimeZoneOffset',
    ZADDASSETATTR.ZEXIFTIMESTAMPSTRING AS 'ZADDASSETATTR.ExifTimeStampString',

    CASE ZCLOUDMASTER.ZCLOUDLOCALSTATE
        WHEN 0 THEN '0 [Not Synced with Cloud]'
        WHEN 1 THEN '1 [Pending Upload]'
        WHEN 2 THEN '2 [Still Testing]'
        WHEN 3 THEN '3 [Synced with Cloud]'
        ELSE 'Unknown Value: ' || ZCLOUDMASTER.ZCLOUDLOCALSTATE || ''
    END AS 'ZCLOUDMASTER.CloudLocalState',

    ZASSET.ZIMPORTSESSION AS 'ZASSET.ImportSession',
    ZADDASSETATTR.ZIMPORTSESSIONID AS 'ZADDASSETATTR.ImportSessionId',

    datetime(ZADDASSETATTR.ZALTERNATEIMPORTIMAGEDATE + 978307200, 'unixepoch') AS 'ZADDASSETATTR.AlternateImportImageDateUtc',

    ZCLOUDMASTER.ZIMPORTSESSIONID AS 'ZCLOUDMASTER.zimportsessionid',

    datetime(ZASSET.ZCLOUDBATCHPUBLISHDATE + 978307200, 'unixepoch') AS 'ZASSET.CloudBatchPublishDateUtc',
    datetime(ZASSET.ZCLOUDSERVERPUBLISHDATE + 978307200, 'unixepoch') AS 'ZASSET.CloudServerPublishDateUtc',

    ZASSET.ZCLOUDDOWNLOADREQUESTS AS 'ZASSET.CloudDownloadRequests',
    ZASSET.ZCLOUDBATCHID AS 'ZASSET.CloudBatchId',

    datetime(ZADDASSETATTR.ZLASTUPLOADATTEMPTDATE + 978307200, 'unixepoch') AS 'ZADDASSETATTR.LastUploadAttemptDateUtc',

    ZADDASSETATTR.ZUPLOADATTEMPTS AS 'ZADDASSETATTR.UploadAttempts',

    CASE ZASSET.ZLATITUDE
        WHEN -180.0 THEN '[-180.0]'
        ELSE ZASSET.ZLATITUDE
    END AS 'ZASSET.Latitude',

    CASE ZASSET.ZLONGITUDE
        WHEN -180.0 THEN '[-180.0]'
        ELSE ZASSET.ZLONGITUDE
    END AS 'ZASSET.Longitude',

    ZEXTATTR.ZLATITUDE AS 'ZEXTATTR.Latitude',
    ZEXTATTR.ZLONGITUDE AS 'ZEXTATTR.Longitude',

    CASE ZADDASSETATTR.ZGPSHORIZONTALACCURACY
        WHEN -1.0 THEN '[-1.0]'
        ELSE ZADDASSETATTR.ZGPSHORIZONTALACCURACY
    END AS 'ZADDASSETATTR.GpsHorizontalAccuracy',

    -- hex(ZASSET.ZLOCATIONDATA) AS 'ZASSET.zlocationdata(HEX)',
    -- hex(ZADDASSETATTR.ZREVERSELOCATIONDATA) AS 'ZADDASSETATTR.zreverselocationdata(hex nskeyed .plist)',

    CASE ZADDASSETATTR.ZSHIFTEDLOCATIONISVALID
        WHEN 0 THEN '0 [Shifted Location Not Valid]'
        WHEN 1 THEN '1 [Shifted Location Valid]'
    END AS 'ZADDASSETATTR.ShiftedLocationIsValid',

    ZADDASSETATTR.ZSHIFTEDLOCATIONDATA AS 'ZADDASSETATTR.ShiftedLocationData',
    ZADDASSETATTR.ZLOCATIONHASH AS 'ZADDASSETATTR.LocationHash',

    CASE AAAzCldMastMedData.Z_OPT
        WHEN 1 THEN '1 [Still Testing Cloud]'
        WHEN 2 THEN '2 [Still Testing This Device]'
        WHEN 3 THEN '3 [Still Testing Muted]'
        WHEN 4 THEN '4 [Still Testing Unknown]'
        WHEN 5 THEN '5 [Still Testing Unknown]'
        ELSE 'Unknown Value: ' || AAAzCldMastMedData.Z_OPT || ''
    END AS 'AAAzCldMastMedData.Opt',

    ZADDASSETATTR.ZMEDIAMETADATATYPE AS 'ZADDASSETATTR.MediaMetadataType',
    -- hex(AAAzCldMastMedData.ZDATA) AS 'AAAzCldMastMedData.zdata(HEX)',

    CASE CMzCldMastMedData.z_opt
        WHEN 1 THEN '1 [Still Testing Has CldMastAsset]'
        WHEN 2 THEN '2 [Still Testing Local Asset]'
        WHEN 3 THEN '3 [Still Testing Muted]'
        WHEN 4 THEN '4 [Still Testing Unknown]'
        WHEN 5 THEN '5 [Still Testing Unknown]'
        ELSE 'Unknown Value: ' || CMzCldMastMedData.Z_OPT || ''
    END AS 'CMzCldMastMedData.ZOpt',

    ZCLOUDMASTER.ZMEDIAMETADATATYPE AS 'ZCLOUDMASTER.MediaMetadataType',
    -- hex(CMzCldMastMedData.ZDATA) AS 'CMzCldMastMedData.zdata(HEX)',

    CASE ZASSET.ZSEARCHINDEXREBUILDSTATE
        WHEN 0 THEN '0 [Still Testing]'
        ELSE 'Unknown Value: ' || ZASSET.ZSEARCHINDEXREBUILDSTATE || ''
    END AS 'ZASSET.SearchIndexRebuildState',

    CASE ZASSET.ZORIENTATION
        WHEN 1 THEN '1 [Video Default/Adjustment/Horizontal Camera (left)]'
        WHEN 2 THEN '2 [Horizontal Camera (right)]'
        WHEN 3 THEN '3 [Horizontal Camera (right)]'
        WHEN 4 THEN '4 [Horizontal Camera (left)]'
        WHEN 5 THEN '5 [Vertical Camera (top)]'
        WHEN 6 THEN '6 [Vertical Camera (top)]'
        WHEN 7 THEN '7 [Vertical Camera (bottom)]'
        WHEN 8 THEN '8 [Vertical Camera (bottom)]'
        ELSE 'Unknown Value: ' || ZASSET.ZORIENTATION || ''
    END AS 'ZASSET.Orientation',

    CASE ZADDASSETATTR.ZORIGINALORIENTATION
        WHEN 1 THEN '1 [Video Default/Adjustment/Horizontal Camera (left)]'
        WHEN 2 THEN '2 [Horizontal Camera (right)]'
        WHEN 3 THEN '3 [Horizontal Camera (right)]'
        WHEN 4 THEN '4 [Horizontal Camera (left)]'
        WHEN 5 THEN '5 [Vertical Camera (top)]'
        WHEN 6 THEN '6 [Vertical Camera (top)]'
        WHEN 7 THEN '7 [Vertical Camera (bottom)]'
        WHEN 8 THEN '8 [Vertical Camera (bottom)]'
        ELSE 'Unknown Value: ' || ZASSET.ZORIENTATION || ''
    END AS 'ZADDASSETATTR.OriginalOrientation',

    CASE ZINTERNALRESOURCE.ZORIENTATION
        WHEN 0 THEN '0 [N/A]'
        WHEN 1 THEN '1 [Video Default/Adjustment/Horizontal Camera (left)]'
        WHEN 2 THEN '2 [Horizontal Camera (right)]'
        WHEN 3 THEN '3 [Horizontal Camera (right)]'
        WHEN 4 THEN '4 [Horizontal Camera (left)]'
        WHEN 5 THEN '5 [Vertical Camera (top)]'
        WHEN 6 THEN '6 [Vertical Camera (top)]'
        WHEN 7 THEN '7 [Vertical Camera (bottom)]'
        WHEN 8 THEN '8 [Vertical Camera (bottom)]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZORIENTATION || ''
    END AS 'ZINTERNALRESOURCE.Orientation',

    CASE ZASSET.ZKIND
        WHEN 0 THEN '0 [Photo]'
        WHEN 1 THEN '1 [Video]'
    END AS 'ZASSET.Kind',

    CASE ZASSET.ZKINDSUBTYPE
        WHEN 0 THEN '0 [Still Photo]'
        WHEN 2 THEN '2 [Live Photo]'
        WHEN 10 THEN '10 [SpringBoard Screenshot]'
        WHEN 100 THEN '100 [Video]'
        WHEN 101 THEN '101 [Slow Mo Video]'
        WHEN 102 THEN '102 [Time lapse Video]'
        WHEN 103 THEN '103 [Replay Screen Recording]'
        ELSE 'Unknown Value: ' || ZASSET.ZKINDSUBTYPE || ''
    END AS 'ZASSET.KindSubType',

    CASE ZADDASSETATTR.ZCLOUDKINDSUBTYPE
        WHEN 0 THEN '0 [Still Photo]'
        WHEN 1 THEN '1 [Still Testing]'
        WHEN 2 THEN '2 [Live Photo]'
        WHEN 3 THEN '3 [Screenshot]'
        WHEN 10 THEN '10 [SpringBoard Screenshot]'
        WHEN 100 THEN '100 [Video]'
        WHEN 101 THEN '101 [Slow Mo Video]'
        WHEN 102 THEN '102 [Time lapse Video]'
        WHEN 103 THEN '103 [Replay Screen Recording]'
        ELSE 'Unknown Value: ' || ZADDASSETATTR.ZCLOUDKINDSUBTYPE || ''
    END AS 'ZADDASSETATTR.CloudKindSubType',

    CASE ZASSET.ZPLAYBACKSTYLE
        WHEN 1 THEN '1 [Image]'
        WHEN 2 THEN '2 [Image Animated]'
        WHEN 3 THEN '3 [Live Photo]'
        WHEN 4 THEN '4 [Video]'
        WHEN 5 THEN '5 [Video Looping]'
        ELSE 'Unknown Value: ' || ZASSET.ZPLAYBACKSTYLE || ''
    END AS 'ZASSET.PlaybackStyle',

    ZASSET.ZPLAYBACKVARIATION AS 'PlaybackVariation(ZASSET)',
    ZASSET.ZDURATION AS 'Duration(ZASSET)',
    ZEXTATTR.ZDURATION AS 'Duration(ZEXTATTR)',
    ZASSET.ZVIDEOCPDURATIONVALUE AS 'VideoCpDurationValue(ZASSET)',
    ZADDASSETATTR.ZVIDEOCPDURATIONTIMESCALE AS 'VideoCpDurationTimeScale(ZADDASSETATTR)',
    ZASSET.ZVIDEOCPVISIBILITYSTATE AS 'VideoCpVisibilityState(ZASSET)',
    ZADDASSETATTR.ZVIDEOCPDISPLAYVALUE AS 'VideoCpDisplayValue(ZADDASSETATTR)',
    ZADDASSETATTR.ZVIDEOCPDISPLAYTIMESCALE AS 'VideoCpDisplayTimeScale(ZADDASSETATTR)',

    -- [ZINTERNALRESOURCE.ZASSET = ZASSET.zPK]
    ZINTERNALRESOURCE.ZASSET AS 'ZINTERNALRESOURCE.zasset',
    ZINTERNALRESOURCE.Z_PK AS 'ZINTERNALRESOURCE.z_pk',
    ZINTERNALRESOURCE.Z_ENT AS 'ZINTERNALRESOURCE.z_ent',
    ZINTERNALRESOURCE.Z_OPT AS 'ZINTERNALRESOURCE.z_opt',
    ZINTERNALRESOURCE.ZQUALITYSORTVALUE AS 'ZINTERNALRESOURCE.zqualitysortvalue',

    CASE ZINTERNALRESOURCE.ZDATASTORECLASSID
        WHEN 0 THEN '0 [LPL Asset CPL Asset]'
        WHEN 1 THEN '1 [Still Testing]'
        WHEN 2 THEN '2 [Photo Cloud Sharing Asset]'
        WHEN 3 THEN '3 [SWY Syndication Asset]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZDATASTORECLASSID || ''
    END AS 'ZINTERNALRESOURCE.zdatastoreclassid',

    CASE ZASSET.ZCLOUDPLACEHOLDERKIND
        WHEN 0 THEN '0 [Local&CloudMaster Asset]'
        WHEN 1 THEN '1 [Still Testing]'
        WHEN 2 THEN '2 [Still Testing]'
        WHEN 3 THEN '3 [JPG Asset Only PhotoData/Thumb/V2]'
        WHEN 4 THEN '4 [LPL JPG Asset CPL Asset HEIC JPG JPEG MOV PNG]'
        WHEN 5 THEN '5 [Asset synced via iCloud Photos 2 Device]'
        WHEN 6 THEN '6 [Still Testing]'
        WHEN 7 THEN '7 [LPL poster JPG Asset CPL Asset MP4]'
        WHEN 8 THEN '8 [LPL JPG Asset CPL Asset LivePhoto MOV]'
        WHEN 9 THEN '9 [CPL MP4 Asset Saved 2 LPL]'
        ELSE 'Unknown Value: ' || ZASSET.ZCLOUDPLACEHOLDERKIND || ''
    END AS 'ZASSET.zcloudplaceholderkind',

    CASE ZINTERNALRESOURCE.ZLOCALAVAILABILITY
        WHEN -1 THEN '(-1) [IR Asset Not Available Local Device]'
        WHEN 1 THEN '1 [IR Asset Available Local Device]'
        WHEN -32768 THEN '(-32768) [IR Asset SWY Linked Asset]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZLOCALAVAILABILITY || ''
    END AS 'ZINTERNALRESOURCE.zlocalavailability',

    CASE ZINTERNALRESOURCE.ZLOCALAVAILABILITYTARGET
        WHEN 0 THEN '0 [Still Testing]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZLOCALAVAILABILITYTARGET || ''
    END AS 'ZINTERNALRESOURCE.zlocalavailabilitytarget',

    CASE ZINTERNALRESOURCE.ZCLOUDLOCALSTATE
        WHEN 0 THEN '0 [IR Asset Not Synced No IR CldMast Date Created]'
        WHEN 1 THEN '1 [IR Asset Pening Upload]'
        WHEN 2 THEN '2 [IR Asset Photo Cloud Share Asset On Local Device]'
        WHEN 3 THEN '3 [IR Asset Synced iCloud]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZCLOUDLOCALSTATE || ''
    END AS 'ZINTERNALRESOURCE.zcloudlocalstate',

    CASE ZINTERNALRESOURCE.ZREMOTEAVAILABILITY
        WHEN 0 THEN '0 [IR Asset Not Available Remotely]'
        WHEN 1 THEN '1 [IR Asset Available Remotely]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZREMOTEAVAILABILITY || ''
    END AS 'ZINTERNALRESOURCE.zremoteavailability',

    CASE ZINTERNALRESOURCE.ZREMOTEAVAILABILITYTARGET
        WHEN 0 THEN '0 [Still Testing]'
        WHEN 1 THEN '1 [Still Testing]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZREMOTEAVAILABILITYTARGET || ''
    END AS 'ZINTERNALRESOURCE.zremoteavailabilitytarget',

    ZINTERNALRESOURCE.ZTRANSIENTCLOUDMASTER AS 'ZINTERNALRESOURCE.ztransientcloudmaster',
    ZINTERNALRESOURCE.ZSIDECARINDEX AS 'ZINTERNALRESOURCE.zsidecarindex',
    ZINTERNALRESOURCE.ZFILEID AS 'ZINTERNALRESOURCE.zfileid',

    CASE ZINTERNALRESOURCE.ZVERSION
        WHEN 0 THEN '0 [IR Asset Standard]'
        WHEN 1 THEN '1 [Still Testing]'
        WHEN 2 THEN '2 [IR Asset Adjustments Mutation]'
        WHEN 3 THEN '3 [IR Asset No IR CldMastDateCreated]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZVERSION || ''
    END AS 'ZINTERNALRESOURCE.zversion',

    ZADDASSETATTR.ZORIGINALFILESIZE AS 'ZADDASSETATTR.zoriginalfilesize',

    CASE ZINTERNALRESOURCE.ZRESOURCETYPE
        WHEN 0 THEN '0 [Photo]'
        WHEN 1 THEN '1 [Video]'
        WHEN 3 THEN '3 [Live Photo]'
        WHEN 5 THEN '5 [Adjustement Data]'
        WHEN 6 THEN '6 [Screenshot]'
        WHEN 9 THEN '9 [Alternate Photo 3rd PartyApp - Still Testing]'
        WHEN 13 THEN '13 [Movie]'
        WHEN 14 THEN '14 [Wallpaper]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZRESOURCETYPE || ''
    END AS 'ZINTERNALRESOURCE.zresourcetype',

    -- hex(ZINTERNALRESOURCE.ZDATASTOREKEYDATA) AS 'ZINTERNALRESOURCE.zdatastorekeydata',

    CASE ZINTERNALRESOURCE.ZDATASTORESUBTYPE
        WHEN 0 THEN '0 [No Cloud Inter Resource]'
        WHEN 1 THEN '1 [Main Asset Orig Size]'
        WHEN 2 THEN '2 [Photo with Adjustments]'
        WHEN 3 THEN '3 [JPG Large Thumb]'
        WHEN 4 THEN '4 [JPG Med Thumb]'
        WHEN 5 THEN '5 [JPG Small Thumb]'
        WHEN 6 THEN '6 [Video Med Data]'
        WHEN 7 THEN '7 [Video Small Data]'
        WHEN 8 THEN '8 [MP4 Cloud Share]'
        WHEN 9 THEN '9 [Still Testing]'
        WHEN 10 THEN '10 [3rd PartyApp thumb - Still Testing]'
        WHEN 11 THEN '11 [Still Test]'
        WHEN 12 THEN '12 [Still Test]'
        WHEN 13 THEN '13 [PNG Optimized CPLAsset]'
        WHEN 14 THEN '14 [Wallpaper]'
        WHEN 15 THEN '15 [Has Markup and Adjustments]'
        WHEN 16 THEN '16 [Video with Adjustments]'
        WHEN 17 THEN '17 [RAW Photo]'
        WHEN 18 THEN '18 [Live Photo Video Optimized CPLAsset]'
        WHEN 19 THEN '19 [Live Photo with Adjustments]'
        WHEN 20 THEN '20 [Still Test]'
        WHEN 21 THEN '21 [Still Test]'
        WHEN 22 THEN '22 [Adjust Mutation AAE Asset]'
        WHEN 23 THEN '23 [Still Test]'
        WHEN 24 THEN '24 [Still Test]'
        WHEN 25 THEN '25 [Still Test]'
        WHEN 26 THEN '26 [MOV Optimized CPLAsset]'
        WHEN 27 THEN '27 [Still Test]'
        WHEN 28 THEN '28 [MOV Med hdr Data]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZDATASTORESUBTYPE || ''
    END AS 'ZINTERNALRESOURCE.zdatastoresubtype',

    CASE ZINTERNALRESOURCE.ZCLOUDSOURCETYPE
        WHEN 0 THEN '0 [N/A]'
        WHEN 1 THEN '1 [Main Asset Orig Size]'
        WHEN 2 THEN '2 [Photo with Adjustments]'
        WHEN 3 THEN '3 [JPG Large Thumb]'
        WHEN 4 THEN '4 [JPG Med Thumb]'
        WHEN 5 THEN '5 [JPG Small Thumb]'
        WHEN 6 THEN '6 [Video Med Data]'
        WHEN 7 THEN '7 [Video Small Data]'
        WHEN 8 THEN '8 [MP4 Cloud Share]'
        WHEN 9 THEN '9 [Still Testing]'
        WHEN 10 THEN '10 [3rd PartyApp thumb - Still Testing]'
        WHEN 11 THEN '11 [Still Test]'
        WHEN 12 THEN '12 [Still Test]'
        WHEN 13 THEN '13 [PNG Optimized CPLAsset]'
        WHEN 14 THEN '14 [Wallpaper]'
        WHEN 15 THEN '15 [Has Markup and Adjustments]'
        WHEN 16 THEN '16 [Video with Adjustments]'
        WHEN 17 THEN '17 [RAW Photo]'
        WHEN 18 THEN '18 [Live Photo Video Optimized CPLAsset]'
        WHEN 19 THEN '19 [Live Photo with Adjustments]'
        WHEN 20 THEN '20 [Still Testing]'
        WHEN 21 THEN '21 [Still Testing]'
        WHEN 22 THEN '22 [Adjust Mutation AAE Asset]'
        WHEN 23 THEN '23 [Still Testing]'
        WHEN 24 THEN '24 [Still Testing]'
        WHEN 25 THEN '25 [Still Testing]'
        WHEN 26 THEN '26 [MOV Optimized CPLAsset]'
        WHEN 27 THEN '27 [Still Testing]'
        WHEN 28 THEN '28 [MOV Med hdr Data]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZCLOUDSOURCETYPE || ''
    END AS 'ZINTERNALRESOURCE.zcloudsourcetype',

    ZINTERNALRESOURCE.ZDATALENGTH AS 'ZINTERNALRESOURCE.zdatalength',

    CASE ZINTERNALRESOURCE.ZRECIPEID
        WHEN 0 THEN '0 [Orig File Size Match Data Length or Optimized]'
        WHEN 65739 THEN '65739 [JPG Large Thumb]'
        WHEN 65741 THEN '65741 [Various Asset Types or Thumbs]'
        WHEN 65743 THEN '65743 [ResouType Photo 5003 or 5005 JPG Thumb]'
        WHEN 65749 THEN '65749 [LocalVideoKeyFrame JPG Thumb]'
        WHEN 65938 THEN '65938 [FullSizeRender Photo or plist]'
        WHEN 131072 THEN '131072 [FullSizeRender Video or plist]'
        WHEN 131079 THEN '131079 [Medium MP4 Adj Mutation Asset]'
        WHEN 131081 THEN '131081 [ResouType Video 5003 or 5005 JPG Thumb]'
        WHEN 131272 THEN '131272 [FullSizeRender Video LivePhoto Adj Mutation]'
        WHEN 131275 THEN '131275 [Medium MOV LivePhoto]'
        WHEN 131277 THEN '131277 [No IR Asset LivePhoto iCloud Sync Asset]'
        WHEN 131475 THEN '131475 [Medium hdr MOV]'
        WHEN 327683 THEN '327683 [JPG Thumb for 3rdParty Still Testing]'
        WHEN 327687 THEN '627687 [Wallpaper Compute Resource]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZRECIPEID || ''
    END AS 'ZINTERNALRESOURCE.zrecipeid',

    CASE ZINTERNALRESOURCE.ZCLOUDLASTPREFETCHDATE
        WHEN 0 THEN 'N/A [0]'
        ELSE datetime(ZINTERNALRESOURCE.ZCLOUDLASTPREFETCHDATE + 978307200, 'unixepoch')
    END AS 'ZINTERNALRESOURCE.zcloudlastprefetchdateUtc',

    ZINTERNALRESOURCE.ZCLOUDPREFETCHCOUNT AS 'ZINTERNALRESOURCE.zcloudprefetchcount',

    datetime(ZINTERNALRESOURCE.ZCLOUDLASTONDEMANDDOWNLOADDATE + 978307200, 'unixepoch') AS 'ZINTERNALRESOURCE.zcloudlastondemanddownloaddateUtc',

    CASE ZINTERNALRESOURCE.ZUTICONFORMANCEHINT
        WHEN 0 THEN '0 [N/A / Does not Conform]'
        WHEN 1 THEN '1 [UT Type Image]'
        WHEN 2 THEN '2 [Still Testing]'
        WHEN 3 THEN '3 [UT Type Movie]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZUTICONFORMANCEHINT || ''
    END AS 'ZINTERNALRESOURCE.zuticonformancehint',

    CASE ZINTERNALRESOURCE.ZCOMPACTUTI
        WHEN 1 THEN 'jpeg/thm [1]'
        WHEN 3 THEN 'heic [3]'
        WHEN 6 THEN 'png [6]'
        WHEN 7 THEN 'Still Testing [7]'
        WHEN 23 THEN 'jpeg/heic/quicktime mov [23]'
        WHEN 24 THEN 'mpeg4 [24]'
        WHEN 36 THEN 'Wallpaper [36]'
        WHEN 37 THEN 'Adj/Mutation Data [37]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZCOMPACTUTI || ''
    END AS 'ZINTERNALRESOURCE.zcompactuti',

    ZASSET.ZUNIFORMTYPEIDENTIFIER AS 'ZASSET.zuniformtypeidentifier',
    ZASSET.ZORIGINALCOLORSPACE AS 'ZASSET.zoriginalcolorspace',
    ZCLOUDMASTER.ZUNIFORMTYPEIDENTIFIER AS 'ZCLOUDMASTER.zuniformtypeidentifier',

    CASE ZCLOUDMASTER.ZFULLSIZEJPEGSOURCE
        WHEN 0 THEN 'CldMast JPEG Source Video [0]'
        WHEN 1 THEN 'CldMast JPEG Source Other [1]'
        ELSE 'Unknown Value: ' || ZCLOUDMASTER.ZFULLSIZEJPEGSOURCE || ''
    END AS 'ZCLOUDMASTER.zfullsizejpegsource',

    ZASSET.ZHDRGAIN AS 'ZASSET.zhdrgain',

    CASE ZASSET.ZHDRTYPE
        WHEN 0 THEN 'No HDR [0]'
        WHEN 3 THEN 'HDR Photo [3]'
        WHEN 4 THEN 'Non-HDR Version [4]'
        WHEN 5 THEN 'HEVC Movie [5]'
        WHEN 6 THEN 'Panorama [6]'
        WHEN 10 THEN 'HDR Gain [10]'
        ELSE 'Unknown Value: ' || ZASSET.ZHDRTYPE || ''
    END AS 'ZASSET.HdrType',

    ZEXTATTR.ZCODEC AS 'ZEXTATTR.Codec',
    ZINTERNALRESOURCE.ZCODECFOURCHARCODENAME AS 'ZINTERNALRESOURCE.CodecFourCharCodeName',
    ZCLOUDMASTER.ZCODECNAME AS 'ZCLOUDMASTER.CodecName',
    ZCLOUDMASTER.ZVIDEOFRAMERATE AS 'ZCLOUDMASTER.VideoFrameRate',
    ZCLOUDMASTER.ZPLACEHOLDERSTATE AS 'ZCLOUDMASTER.PlaceHolderState',

    CASE ZASSET.ZDEPTHTYPE
        WHEN 0 THEN 'NoPortrait [0]'
        ELSE 'Portrait: ' || ZASSET.ZDEPTHTYPE || ''
    END AS 'ZASSET.DepthType',

    ZASSET.ZAVALANCHEUUID AS 'ZASSET.zavalancheuuid',

    CASE ZASSET.ZMONOSKITYPE
        WHEN 0 THEN 'StillTestingNoMonoski [0]'
        ELSE 'Unknown Value: ' || ZASSET.ZMONOSKITYPE || ''
    END AS 'ZASSET.MonoSkiType',

    CASE ZASSET.ZAVALANCHEPICKTYPE
        WHEN 0 THEN 'N/A-SingleAssetBurstUUID [0]'
        WHEN 2 THEN 'BurstAssetNotSelected [2]'
        WHEN 4 THEN 'BurstAssetPhotosAppPickedKeyImage [4]'
        WHEN 8 THEN 'BurstAssetSelectedForLPL [8]'
        WHEN 16 THEN 'TopBurstAssetInStackKeyImage [16]'
        WHEN 32 THEN 'StillTesting [32]'
        WHEN 52 THEN 'BurstAssetVisibleLPL [52]'
        ELSE 'Unknown Value: ' || ZASSET.ZAVALANCHEPICKTYPE || ''
    END AS 'ZASSET.AvalanchePickType',

    CASE ZADDASSETATTR.ZCLOUDAVALANCHEPICKTYPE
        WHEN 0 THEN 'N/A-SingleAssetBurstUUID [0]'
        WHEN 2 THEN 'BurstAssetNotSelected [2]'
        WHEN 4 THEN 'BurstAssetPhotosAppPickedKeyImage [4]'
        WHEN 8 THEN 'BurstAssetSelectedforLPL [8]'
        WHEN 16 THEN 'TopBurstAssetInStackKeyImage [16]'
        WHEN 32 THEN 'StillTesting [32]'
        WHEN 52 THEN 'BurstAssetVisibleLPL [52]'
        ELSE 'Unknown Value: ' || ZADDASSETATTR.ZCLOUDAVALANCHEPICKTYPE || ''
    END AS 'ZADDASSETATTR.CloudAvalanchePickType',

    CASE ZADDASSETATTR.ZCLOUDRECOVERYSTATE
        WHEN 0 THEN 'StillTesting [0]'
        WHEN 1 THEN 'StillTesting [1]'
        ELSE 'Unknown Value: ' || ZADDASSETATTR.ZCLOUDRECOVERYSTATE || ''
    END AS 'ZADDASSETATTR.CloudRecoveryState',

    ZADDASSETATTR.ZCLOUDSTATERECOVERYATTEMPTSCOUNT AS 'ZADDASSETATTR.CloudStateRecoveryAttemptsCount',
    ZASSET.ZDEFERREDPROCESSINGNEEDED AS 'ZASSET.DeferredProcessingNeeded',
    ZASSET.ZVIDEODEFERREDPROCESSINGNEEDED AS 'ZASSET.VideoDeferredProcessingNeeded',
    ZADDASSETATTR.ZDEFERREDPHOTOIDENTIFIER AS 'ZADDASSETATTR.DeferredPhotoIdentifier',
    ZADDASSETATTR.ZDEFERREDPROCESSINGCANDIDATEOPTIONS AS 'ZADDASSETATTR.DeferredProcessingCandidateOptions',

    CASE ZASSET.ZHASADJUSTMENTS
        WHEN 0 THEN 'No [0]'
        WHEN 1 THEN 'Yes [1]'
        ELSE 'Unknown Value: ' || ZASSET.ZHASADJUSTMENTS || ''
    END AS 'ZASSET.HasAdjustments',

    --[ZUNMANAGEDADJUSTMENT.ZASSETATTRIBUTES = ZADDASSETATTR.Z_PK]
    ZUNMANAGEDADJUSTMENT.ZASSETATTRIBUTES AS 'ZUNMANAGEDADJUSTMENT.AssetAttributes',

    --[ZADDASSETATTR.ZUNMANAGEDADJUSTMENT = ZUNMANAGEDADJUSTMENT.Z_PK]
    ZADDASSETATTR.ZUNMANAGEDADJUSTMENT AS 'ZADDASSETATTR.UnmanagedAdjustment',

    --[ZUNMANAGEDADJUSTMENT.Z_PK = ZADDASSETATTR.ZUnmanAdj]
    ZUNMANAGEDADJUSTMENT.Z_PK AS 'ZUNMANAGEDADJUSTMENT.ZPk',

    ZUNMANAGEDADJUSTMENT.ZUUID AS 'ZUNMANAGEDADJUSTMENT.Uuid',

    datetime(ZASSET.ZADJUSTMENTTIMESTAMP + 978307200, 'unixepoch') AS 'ZASSET.AdjustmentTimestampUtc',
    datetime(ZUNMANAGEDADJUSTMENT.ZADJUSTMENTTIMESTAMP + 978307200, 'unixepoch') AS 'ZUNMANAGEDADJUSTMENT.AdjustmentTimestampUtc',

    ZADDASSETATTR.ZEDITORBUNDLEID AS 'ZADDASSETATTR.EditorBundleId',
    ZUNMANAGEDADJUSTMENT.ZEDITORLOCALIZEDNAME AS 'ZUNMANAGEDADJUSTMENT.EditorLocalizedName',
    ZUNMANAGEDADJUSTMENT.ZADJUSTMENTFORMATIDENTIFIER AS 'ZUNMANAGEDADJUSTMENT.AdjustmentFormatIdentifier',
    ZADDASSETATTR.ZMONTAGE AS 'ZADDASSETATTR.Montage',

    CASE ZUNMANAGEDADJUSTMENT.ZADJUSTMENTRENDERTYPES
        WHEN 0 THEN 'StandardOrPortraitWithErros [0]'
        WHEN 1 THEN 'StillTesting [1]'
        WHEN 2 THEN 'Portrait [2]'
        WHEN 3 THEN 'StillTesting [3]'
        WHEN 4 THEN 'StillTesting [4]'
        ELSE 'Unknown Value: ' || ZUNMANAGEDADJUSTMENT.ZADJUSTMENTRENDERTYPES || ''
    END AS 'ZUNMANAGEDADJUSTMENT.AdjustmentRenderTypes',

    CASE ZUNMANAGEDADJUSTMENT.ZADJUSTMENTFORMATVERSION
        WHEN 1.0 THEN 'Markup [1.0]'
        WHEN 1.1 THEN 'Slow-Mo [1.1]'
        WHEN 1.2 THEN 'StillTesting [1.2]'
        WHEN 1.3 THEN 'StillTesting [1.3]'
        WHEN 1.4 THEN 'Filter [1.4]'
        WHEN 1.5 THEN 'Adjust [1.5]'
        WHEN 1.6 THEN 'VideoTrim [1.6]'
        WHEN 1.7 THEN 'StillTesting [1.7]'
        WHEN 1.8 THEN 'StillTesting [1.8]'
        WHEN 1.9 THEN 'StillTesting [1.9]'
        WHEN 2.0 THEN 'ScreenshotServices [2.0]'
        ELSE 'Unknown Value: ' || ZUNMANAGEDADJUSTMENT.ZADJUSTMENTFORMATVERSION || ''
    END AS 'ZUNMANAGEDADJUSTMENT.AdjustmentFormatVersion',

    ZUNMANAGEDADJUSTMENT.ZADJUSTMENTBASEIMAGEFORMAT AS 'ZUNMANAGEDADJUSTMENT.AdjustmentBaseImageFormat',

    CASE ZASSET.ZFAVORITE
        WHEN 0 THEN 'NotFavorite [0]'
        WHEN 1 THEN 'Favorite [1]'
        ELSE 'Unknown Value: ' || ZASSET.ZFAVORITE || ''
    END AS 'ZASSET.Favorite',

    CASE ZASSET.ZHIDDEN
        WHEN 0 THEN 'NotHidden [0]'
        WHEN 1 THEN 'Hidden [1]'
        ELSE 'Unknown Value: ' || ZASSET.ZHIDDEN || ''
    END AS 'ZASSET.Hidden',

    CASE ZASSET.ZTRASHEDSTATE
        WHEN 0 THEN 'NotInTrash [0]'
        WHEN 1 THEN 'InTrash [1]'
        ELSE 'Unknown Value: ' || ZASSET.ZTRASHEDSTATE || ''
    END AS 'ZASSET.TrashedState',

    datetime(ZASSET.ZTRASHEDDATE + 978307200, 'unixepoch') AS 'ZASSET.TrashedDateUtc',

    CASE ZASSET.ZDELETEREASON
        WHEN NULL THEN NULL
        WHEN 1 THEN 'StillTesting [1]'
        WHEN 2 THEN 'StillTesting [2]'
        WHEN 3 THEN 'StillTesting [3]'
        ELSE 'Unknown Value: ' || ZASSET.ZDELETEREASON || ''
    END AS 'ZASSET.DeletedReason',

    CASE ZASSET.ZTRASHEDBYPARTICIPANT
        WHEN NULL THEN NULL
        WHEN 0 THEN 'NotTrashedByParticipant [0]'
        WHEN 1 THEN 'TrashedByParticipant [1]'
        ELSE 'Unknown Value: ' || ZASSET.ZTRASHEDBYPARTICIPANT || ''
    END AS 'ZASSET.TrashedByParticipant',

    CASE ZINTERNALRESOURCE.ZTRASHEDSTATE
        WHEN 0 THEN 'NotInTrash [0]'
        WHEN 1 THEN 'InTrash [1]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZTRASHEDSTATE || ''
    END AS 'ZINTERNALRESOURCE.TrashedState',

    datetime(ZINTERNALRESOURCE.ZTRASHEDDATE + 978307200, 'unixepoch') AS 'ZINTERNALRESOURCE.TrashedDateUtc',

    CASE ZASSET.ZCLOUDDELETESTATE
        WHEN 0 THEN 'CloudAssetNotDeleted [0]'
        WHEN 1 THEN 'CloudAssetDeleted [1]'
        ELSE 'Unknown Value: ' || ZASSET.ZCLOUDDELETESTATE || ''
    END AS 'ZASSET.CloudDeleteState',

    CASE ZINTERNALRESOURCE.ZCLOUDDELETESTATE
        WHEN 0 THEN 'CloudIntResouNotDeleted [0]'
        WHEN 1 THEN 'CloudIntResouDeleted [1]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZCLOUDDELETESTATE || ''
    END AS 'ZINTERNALRESOURCE.CloudDeleteState',

    CASE ZADDASSETATTR.ZPTPTRASHEDSTATE
        WHEN 0 THEN 'PtpNotInTrash [0]'
        WHEN 1 THEN 'PtpInTrash [1]'
        ELSE 'Unknown Value: ' || ZADDASSETATTR.ZPTPTRASHEDSTATE || ''
    END AS 'ZADDASSETATTR.PtpTrashedState',

    CASE ZINTERNALRESOURCE.ZPTPTRASHEDSTATE
        WHEN 0 THEN 'PtpIntResouNotInTrash [0]'
        WHEN 1 THEN 'PtpIntResouInTrash [1]'
        ELSE 'Unknown Value: ' || ZINTERNALRESOURCE.ZPTPTRASHEDSTATE || ''
    END AS 'ZINTERNALRESOURCE.PtpTrashedState',

    ZINTERNALRESOURCE.ZCLOUDDELETEASSETUUIDWITHRESOURCETYPE AS 'ZINTERNALRESOURCE.CloudDeleteAssetUuidWithResourceType',

    datetime(zMedAnlyAstAttr.ZMEDIAANALYSISTIMESTAMP + 978307200, 'unixepoch') AS 'zMedAnlyAstAttr.MediaAnalysisTimestampUtc',

    ZADDASSETATTR.ZPENDINGVIEWCOUNT AS 'ZADDASSETATTR.PendingViewCount',
    ZADDASSETATTR.ZVIEWCOUNT AS 'ZADDASSETATTR.ViewCount',
    ZADDASSETATTR.ZPENDINGPLAYCOUNT AS 'ZADDASSETATTR.PendingPlayCount',
    ZADDASSETATTR.ZPLAYCOUNT AS 'ZADDASSETATTR.PlayCount',
    ZADDASSETATTR.ZPENDINGSHARECOUNT AS 'ZADDASSETATTR.PendingShareCount',
    ZADDASSETATTR.ZSHARECOUNT AS 'ZADDASSETATTR.ShareCount',

    datetime(ZASSET.ZLASTSHAREDDATE + 978307200, 'unixepoch') AS 'ZASSET.LastSharedDateUtc',

    ZADDASSETATTR.ZSHAREORIGINATOR AS 'ZADDASSETATTR.ShareOriginator',

    CASE ZADDASSETATTR.ZALLOWEDFORANALYSIS
        WHEN 0 THEN 'AssetNotAllowedForAnalysis [0]'
        WHEN 1 THEN 'AssetAllowedForAnalysis [1]'
        ELSE 'Unknown Value: ' || ZADDASSETATTR.ZALLOWEDFORANALYSIS || ''
    END AS 'ZADDASSETATTR.AllowedForAnalysis',

    ZADDASSETATTR.ZSCENEANALYSISVERSION AS 'ZADDASSETATTR.SceneAnalysisVersion',

    CASE ZADDASSETATTR.ZSCENEANALYSISISFROMPREVIEW
        WHEN 0 THEN 'No [0]'
        ELSE 'Unknown Value: ' || ZADDASSETATTR.ZSCENEANALYSISISFROMPREVIEW || ''
    END AS 'ZADDASSETATTR.SceneAnalysisIsFromPreview',

    datetime(ZADDASSETATTR.ZSCENEANALYSISTIMESTAMP + 978307200, 'unixepoch') AS 'ZADDASSETATTR.SceneAnalysisTimestampUtc',

    CASE ZASSET.ZDUPLICATEASSETVISIBILITYSTATE
        WHEN 0 THEN 'NoDuplicates [0]'
        WHEN 1 THEN 'HasDuplicate [1]'
        WHEN 2 THEN 'IsADuplicate [2]'
        ELSE 'Unknown Value: ' || ZASSET.ZDUPLICATEASSETVISIBILITYSTATE || ''
    END AS 'ZASSET.DuplicateAssetVisibilityState',

    CASE ZADDASSETATTR.ZDESTINATIONASSETCOPYSTATE
        WHEN 0 THEN 'NoCopy [0]'
        WHEN 1 THEN 'HasACopy [1]'
        WHEN 2 THEN 'HasACopy [2]'
        ELSE 'Unknown Value: ' || ZADDASSETATTR.ZDESTINATIONASSETCOPYSTATE || ''
    END AS 'ZADDASSETATTR.DestinationAssetCopyState',

    -- hex(ZSCENEPRINT.ZDATA) AS 'ZSCENEPRINT.zdata(hex nskeyed .plist)',
    -- hex(ZSCENEPRINT.ZDUPLICATEMATCHINGDATA) AS 'ZSCENEPRINT.zduplicatematchingdata(hex nskeyed .plist)',
    -- hex(ZSCENEPRINT.ZDUPLICATEMATCHINGALTERNATEDATA) AS 'ZSCENEPRINT.zduplicatematchingalternatedata(hex nskeyed .plist)',
    ZADDASSETATTR.ZSOURCEASSETFORDUPLICATIONSCOPEIDENTIFIER AS 'ZADDASSETATTR.SourceAssetForDuplicationScopeIdentifier',
    ZCLOUDMASTER.ZSOURCEMASTERFORDUPLICATIONSCOPEIDENTIFIER AS 'ZCLOUDMASTER.SourceMasterForDuplicationScopeIdentifier',
    ZADDASSETATTR.ZSOURCEASSETFORDUPLICATIONIDENTIFIER AS 'ZADDASSETATTR.SourceAssetForDuplicationIdentifier',
    ZCLOUDMASTER.ZSOURCEMASTERFORDUPLICATIONIDENTIFIER AS 'ZCLOUDMASTER.SourceMasterForDuplicationIdentifier',

    /* Source for each line of data */
    'private/var/mobile/Library/Photos/Libraries/Syndication.photoslibrary/database/Photos.sqlite; ZASSET(Z_PK:' || ZASSET.Z_PK || ')' AS "DataSource"


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
