# script for restoring last checkpoint for VMs matching a pattern
$vmNamePattern = "test-host-*"

$matchingVMs = Get-VM | Where-Object { $_.Name -like $vmNamePattern }

if ($matchingVMs.Count -eq 0) {
    Write-Host "No VMs matching the pattern '$vmNamePattern' found."
} else {
    foreach ($vm in $matchingVMs) {
        $checkpoints = Get-VMSnapshot -VMName $vm.Name
        if ($checkpoints.Count -eq 0) {
            Write-Host "No checkpoints found for VM $($vm.Name)."
        } else {
            $lastCheckpoint = $checkpoints[-1]
            Write-Host "Reverting VM $($vm.Name) to the last checkpoint: $($lastCheckpoint.Name)..."
            Restore-VMSnapshot -Name $lastCheckpoint.Name -VMName $vm.Name
            Write-Host "Revert completed for VM $($vm.Name)."
        }
    }
}
