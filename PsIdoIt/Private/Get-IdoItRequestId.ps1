Function Get-IdoItRequestId {
    $RequestId = [Guid]::NewGuid()
    Write-Verbose "Request id: $RequestId"
    Return $ReqeustId
}