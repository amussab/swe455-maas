$uri = "https://27k72a6m23.execute-api.us-east-1.amazonaws.com/estimate_pi"
$jobs = @()

1..50 | ForEach-Object {
    $jobs += Start-Job -ScriptBlock {
        param($u)

        $body = '{"total_points":10000000}'
        try {
            $response = Invoke-RestMethod -Uri $u -Method POST -ContentType "application/json" -Body $body
            [PSCustomObject]@{
                Status = "Success"
                JobId = $response.job_id
                Message = $response.message
                TotalPoints = $response.total_points
            }
        }
        catch {
            [PSCustomObject]@{
                Status = "Failed"
                JobId = ""
                Message = $_.Exception.Message
                TotalPoints = 10000000
            }
        }
    } -ArgumentList $uri
}

Write-Host "Waiting for 50 concurrent requests to finish..."
$results = $jobs | Wait-Job | Receive-Job
$results | Format-Table -AutoSize
$results | Export-Csv -Path ".\load_test_results.csv" -NoTypeInformation

Write-Host ""
Write-Host "Summary:"
Write-Host "Successful requests:" ($results | Where-Object { $_.Status -eq "Success" }).Count
Write-Host "Failed requests:" ($results | Where-Object { $_.Status -eq "Failed" }).Count
Write-Host "Results saved to load_test_results.csv"
