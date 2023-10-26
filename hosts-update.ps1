$hostsFilePath = "C:\Windows\System32\drivers\etc\hosts"

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

$vmNetworkAdapters = Get-VMNetworkAdapter -VMName *
$vmIPAddresses = $vmNetworkAdapters | Where-Object { $_.IPAddresses.Count -gt 0 } | Select-Object VMName, IPAddresses

function UpdateHostsFile($vmName, $ipv4) {
    $hostsContent = Get-Content $hostsFilePath -Raw
    $pattern = "\b$vmName\b"
    if ($hostsContent -match $pattern) {
        $hostsContent = $hostsContent -replace "(?ms)(\d+\.\d+\.\d+\.\d+)\s+$vmName.*", "$ipv4 $vmName"
    } else {
        $hostsContent += "$ipv4 $vmName`r`n"
    }
    Set-Content $hostsFilePath -Value $hostsContent
}

$vmIPAddresses | ForEach-Object {
    $vmName = $_.VMName
    $ipv4 = $_.IPAddresses | Where-Object { $_ -match '\d+\.\d+\.\d+\.\d+' } | Select-Object -First 1
    if ($ipv4) {
        UpdateHostsFile $vmName $ipv4
        Write-Host "Updated hosts file for $vmName with IP $ipv4"
    } else {
        Write-Host "No IPv4 address found for $vmName"
    }
}