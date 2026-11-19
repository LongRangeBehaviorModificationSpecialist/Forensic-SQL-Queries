/*
[DLU]
    03-Nov-2026
[DATABASE PATH]
    /private/var/mobile/Library/Accounts/Accounts3.sqlite
*/

SELECT

    ROW_NUMBER() OVER() AS 'RowNumber',

    datetime('2001-01-01', zaccount.zdate || ' seconds') AS 'AccountDateUtc',

    datetime('2001-01-01', zaccount.ZLASTCREDENTIALRENEWALREJECTIONDATE || ' seconds') AS 'LastCredentialRenewalRejectionDateUtc',

    ZACCOUNTTYPE.ZACCOUNTTYPEDESCRIPTION AS 'AccountTypeDescription',
    ZACCOUNTTYPE.ZIDENTIFIER AS 'AccountIdentifier',
    zaccount.ZUSERNAME AS 'Username',
    zaccount.ZACCOUNTDESCRIPTION AS 'AccountDescription',

    CASE zaccount.ZACTIVE
        WHEN 0 THEN 'No [0]'
        WHEN 1 THEN 'Yes [1]'
    END AS 'AccountActive',

    CASE zaccount.ZAUTHENTICATED
        WHEN 0 THEN 'No [0]'
        WHEN 1 THEN 'Yes [1]'
    END AS 'AccountAuthenticated',

    CASE zaccount.ZSUPPORTSAUTHENTICATION
        WHEN 0 THEN 'No [0]'
        WHEN 1 THEN 'Yes [1]'
    END AS 'AccountSupportsAuth',

    zaccount.ZAUTHENTICATIONTYPE AS 'AuthenticationType',
    ZACCOUNTTYPE.ZCREDENTIALTYPE AS 'CredentialType',
    ZACCOUNTPROPERTY.ZKEY AS 'Key',

    CASE zaccount.ZVISIBLE
        WHEN 0 THEN 'No [0]'
        WHEN 1 THEN 'Yes [1]'
    END AS 'AccountVisible',

    zaccount.ZIDENTIFIER AS 'Identifier',
    zaccount.ZOWNINGBUNDLEID AS 'OwningBundleId'

    /* Source for each line of data */
    --TODO -> confirm primary keys for the zaccount and zaccounttype tables and enter values below
    'Accounts3.sqlite; Table:zaccount(Z_PK:' || ZLIVEUSAGE.Z_PK || '), ' || 'Table: ZACCOUNTTYPE(Z_PK:' || ZPROCESS.Z_PK || ')' AS 'DataSource'


FROM zaccount
    JOIN ZACCOUNTTYPE ON ZACCOUNTTYPE.Z_PK = zaccount.ZACCOUNTTYPE
    JOIN ZACCOUNTPROPERTY ON ZACCOUNTPROPERTY.Z_PK = zaccount.Z_OPT


ORDER BY zaccount.zdate DESC