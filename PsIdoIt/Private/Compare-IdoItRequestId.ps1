Function Compare-IdoItRequestId {

    Param (
        [String]$RequestID,

        [String]$ResponseID
    )

    Return ($ResponseID -eq $RequestID)

}