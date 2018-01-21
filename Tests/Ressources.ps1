$Data = @{
    SuccessCode = 200
    ErrorCode = 200
    login = @{
        SuccessMock = '{"jsonrpc":"2.0","result":{"result":true,"userid":"9","name":"i-doit","mail":"i-doit@acme-it.example","username":"admin","session-id":"sdjspcotlq37mekv3hv4pd0dt0","client-id":"1","client-name":"ACME IT Solutions"},"id":"1"}'
        ErrorMock = '{"jsonrpc":"2.0","error":{"code":"-32700","message":"Parse error"},"id":"1"}'
    }
    getobject = @{
        SuccessMock = '{"jsonrpc":"2.0","result":{"id":"3411","title":"web009","sysid":"SRV_000003411","objecttype":"5","type_title":"Server","type_icon":"images\/icons\/silk\/server.png","status":"2","cmdb_status":"6","cmdb_status_title":"in operation","created":"2017-03-06 17:01:37","updated":"2017-03-07 14:23:48","image":"https:\/\/demo.i-doit.com\/images\/objecttypes\/server.png"},"id":"1"}'

    }
    IdoitObject = [PSCustomObject]@{
        id                  = 1
        title               = 'Object'
        type_title          = 'TypeTitle'
        sysid               = 'SysId'
        objecttype          = 5
        type_icon           = 'images/icons/silk/server.png'
        status              = 2
        cmdb_status         = 6
        cmdb_status_title   = 'in operation'
        created             = '2017-03-06 17:01:37'
        updated             = '2017-03-07 14:23:48'
        image               = 'https://demo.i-doit.com/images/objecttypes/server.png'

    }
}
