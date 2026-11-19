/*
[DLU]
    19-Nov-2026
[DATABASE PATH]
    \data\data\com.zhiliaoapp.musically\databases
[DATABASE FILE]
    7455782601761915946_search_sdk.db
*/

SELECT

    ROW_NUMBER() OVER( ORDER BY c4update_time ) AS "RowNumber",

    docid AS "DocId",
    c1business_id AS "BusinessId",
    c3search_content AS "SearchContent",

    strftime ( '%F_%H:%M:%f', c4update_time / 1000.0, 'unixepoch' ) AS "UpdateTime",

    c6grouping_id AS "GroupingId",
    c7filter AS "Filter",
    c8ext AS "Ext",

    /* Source for each line of data */
    'File: \data\data\com.zhiliaoapp.musically\databases\7455782601761915946_search_sdk.db; Table:im_search_index_new_content(docid: ' || docid || ')' AS "DataSource"


FROM im_search_index_new_content


ORDER BY DocId
