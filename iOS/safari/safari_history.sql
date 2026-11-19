/*
[DLU]
    19-Nov-2026
*/

SELECT

    ROW_NUMBER() OVER ( ORDER BY history_visits.visit_time ) AS "RowNumber",

    history_visits.id AS "HistoryVisitsId",
    history_items.id AS "HistoryItemsId",

    strftime (
        '%F_%H:%M:%f',
        history_visits.visit_time + 978307200,
        'unixepoch'
    ) AS "HistoryVisitsVisitTimeUtc",

    CASE history_visits.load_successful
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Yes'
        ELSE history_visits.load_successful
    END AS "HistoryVisitsLoadSuccessful",

    CASE history_visits.origin
        WHEN 0 THEN 'ViewedOnThisDevice'
        WHEN 1 THEN 'SyncedFromiCloudDevice'
        ELSE history_visits.origin
    END AS "HistoryVisitsOrigin",

    history_visits.title AS "HistoryVisitsTitle",
    history_items.url AS "HistoryItemsUrl",
    history_items.visit_count AS "HistoryItemsVisitCount",
    history_visits.redirect_source AS "HistoryVisitsRedirectSource",
    history_visits.redirect_destination AS "HistoryVisitsRedirectDestination",

    /* Source for each line of data */
    'History.db; Table: history_items(id:' ||  history_items.id || '), Table: history_visits(id:' || history_visits.id || ')' AS "DataSource"


FROM history_visits
    JOIN history_items ON history_visits.history_item = history_items.id


WHERE
    history_items.url LIKE '%270357737392%'


ORDER BY
    history_visits.visit_time ASC
