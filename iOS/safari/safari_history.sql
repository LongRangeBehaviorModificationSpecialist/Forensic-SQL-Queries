/*
[DLU]
    03-Nov-2026
*/

SELECT

    ROW_NUMBER() OVER() AS 'RowNumber',
    history_visits.id AS 'history_visits.Id',
    history_items.id AS 'history_items.Id',

    datetime(history_visits.visit_time + 978307200, 'unixepoc') AS 'history_visits.VisitTimeUtc',

    CASE history_visits.load_successful
        WHEN 0 THEN 'No [0]'
        WHEN 1 THEN 'Yes [1]'
        ELSE history_visits.load_successful
    END AS 'history_visits.LoadSuccessful',

    CASE history_visits.origin
        WHEN 0 THEN 'ViewedOnThisDevice [0]'
        WHEN 1 THEN 'SyncedFromiCloudDevice [1]'
        ELSE history_visits.origin
    END AS 'history_visits.Origin',

    history_visits.title AS 'history_visits.Title',
    history_items.url AS 'history_items.Url',
    history_items.visit_count AS 'history_items.VisitCount',
    history_visits.redirect_source AS 'history_visits.RedirectSource',
    history_visits.redirect_destination AS 'history_visits.RedirectDestination',

    /* Source for each line of data */
    'History.db; Table: history_items(id:' ||  history_items.id || '), Table: history_visits(id:' || history_visits.id || ')' AS 'DataSource'


FROM history_visits
    JOIN history_items ON history_visits.history_item = history_items.id


WHERE
    history_items.url LIKE '%270357737392%'


ORDER BY
    history_visits.visit_time ASC