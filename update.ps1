$Searcher = New-Object -ComObject Microsoft.Update.Session
$Results = $Searcher.CreateUpdateSearcher().Search("IsInstalled=0").Updates
$Results | ForEach-Object {
    [PSCustomObject]@{
        Title = $_.Title
        KBs   = ($_.KBArticleIDs -join ", ")
        Size  = $_.MaxDownloadSize
    }
}
