Function Compare-IdoItRequestId {

    Param (
        [String]$RequestId,

        [String]$ResponseId
    )

    Write-Verbose "Comparing RequestId $RequestId with ResponseId $ResponseId"

    Return ($ResponseID -eq $RequestID)

}