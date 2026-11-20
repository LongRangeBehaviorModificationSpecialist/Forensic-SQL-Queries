/*
[DLU]
    20-Nov-2026
[DATABASE]
    \data\data\com.zhiliaoapp.musically\databases\<TikTokUserIdNumber>_search_sdk.db
[NOTES]

*/


SELECT

    ROW_NUMBER() OVER( ORDER BY im_search_index_new_content.c4update_time ) AS RowNumber,

    im_search_index_new_content.docid AS DocId,
    im_search_index_new_content.c1business_id AS BusinessId,
    im_search_index_new_content.c3search_content AS SearchContent,

    strftime ( '%F_%H:%M:%f', im_search_index_new_content.c4update_time / 1000.0, 'unixepoch' ) AS UpdateTime,

    im_search_index_new_content.c6grouping_id AS GroupingId,
    im_search_index_new_content.c7filter AS Filter,
    im_search_index_new_content.c8ext AS Ext,

    /* Source for each line of data */
    'File: 7455782601761915946_search_sdk.db; Table:im_search_index_new_content(docid:' || docid || ')' AS DataSource


FROM im_search_index_new_content


ORDER BY DocId
