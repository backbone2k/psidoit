Function New-IdoItRequestId {
    #A small function to return a guid
    #Version
    #0.1.5   05.01.2018  CB  initial release and bug fixed a typo in the return parameter

    $RequestId = [Guid]::NewGuid()
    Write-Verbose "Request id: $RequestId"

    Return $RequestId
}