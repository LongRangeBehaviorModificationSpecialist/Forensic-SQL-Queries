/*
[DLU]
    19-Nov-2026
[DATABASE PATH]
    \data\data\com.zhiliaoapp.musically\databases
[DATABASE FILE]
    downloader.db
*/

SELECT

    ROW_NUMBER() OVER ( ORDER BY downloader.downloadStartTimeStamp ) AS "RowNumber",

    downloader._id AS "DownloaderId",
    downloader.url AS "DownloaderUrl",
    downloader.savePath AS "DownloaderSavePath",
    downloader.name AS "DownloaderName",
    downloader.status AS "Status",
    downloader.curBytes AS "CurBytes",
    downloader.totalBytes AS "TotalBytes",
    downloader.force AS "Force",
    downloader.retryCount AS "RetryCount",
    downloader.mimeType AS "MimeType",
    downloader.isFirstDownload AS "IsFirstDownload",
    downloader.isFirstSuccess AS "IsFirstSuccess",
    downloader.downloadTime AS "DownloadTime",
    downloader.packageName AS "PackageName",
    downloader.md5 AS "Md5",
    downloader.backupUrlsStr AS "BackupUrlsStr",

    CAST ( downloader.realDownloadTime AS TEXT ) AS "RealDownloadTime",

    CASE
        WHEN json_valid ( downloader.auxiliaryJsonobjectString ) AND json_extract ( downloader.auxiliaryJsonobjectString, '$.dbjson_last_start_download_time' ) IS NOT NULL
            THEN strftime ( '%F_%H:%M:%f', ( json_extract ( downloader.auxiliaryJsonobjectString, '$.dbjson_last_start_download_time' ) ) / 1000.0, 'unixepoch' )
        ELSE NULL
    END AS "DbJsonLastStartDownloadTimeUtc",

    downloader.taskId AS "TaskId",

    strftime ( '%F_%H:%M:%f', downloader.downloadStartTimeStamp / 1000.0, 'unixepoch' ) AS "DownloadStartTimeStamp",
    strftime ( '%F_%H:%M:%f', downloader.downloadFinishTimeStamp / 1000.0, 'unixepoch' ) AS "DownloadFinishTimeStamp",

    /* Source for each line of data */
    'File: \data\data\com.zhiliaoapp.musically\databases\downloads.db; Table:downloader(_id: ' || downloader._id || ')' AS "DataSource"


FROM downloader


ORDER BY DownloadStartTimeStamp
