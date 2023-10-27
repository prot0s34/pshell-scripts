# script for restoring last checkpoint for VMs matching a pattern
$vmNamePattern = "test-host-*"

$matchingVMs = Get-VM | Where-Object { $_.Name -like $vmNamePattern }

if ($matchingVMs.Count -eq 0) {
    Write-Host "No VMs matching the pattern '$vmNamePattern' found."
} else {
    $vmList = $matchingVMs | ForEach-Object { $_.Name }

    Write-Host "The following VMs will be reverted to the last checkpoint:"
    $vmList | ForEach-Object { Write-Host $_ }

    $confirmation = Read-Host "Revert all matching VMs to the last checkpoint? (Y/N)"

    if ($confirmation -eq "Y") {
        foreach ($vm in $matchingVMs) {
            $checkpoints = Get-VMSnapshot -VMName $vm.Name
            if ($checkpoints.Count -eq 0) {
                Write-Host "No checkpoints found for VM $($vm.Name)."
            } else {
                $lastCheckpoint = $checkpoints[-1]
                Write-Host "Reverting VM $($vm.Name) to the last checkpoint: $($lastCheckpoint.Name)..."
                Restore-VMSnapshot -Name $lastCheckpoint.Name -VMName $vm.Name -Confirm:$false
                Write-Host "Revert completed for VM $($vm.Name)."
            }
        }
    } else {
        Write-Host "Reverting VMs canceled."
    }
}
