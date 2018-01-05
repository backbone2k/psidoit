$Ressources = @{
    SuccessCode = 200
    ErrorCode = 200
    login = @{
        SuccessMock = '{"jsonrpc":"2.0","result":{"result":true,"userid":"9","name":"i-doit","mail":"i-doit@acme-it.example","username":"admin","session-id":"sdjspcotlq37mekv3hv4pd0dt0","client-id":"1","client-name":"ACME IT Solutions"},"id":"1"}'
        ErrorMock = '{"jsonrpc":"2.0","error":{"code":"-32700","message":"Parse error"},"id":"1"}'
    }
}

$a= [PSCustomObject]@{
    Content = $Ressources.Login.SuccessMock
    StatusCode = $Ressources.SuccessCode
}
$a | get-member

(ConvertFrom-Json $a.Content).result.userid