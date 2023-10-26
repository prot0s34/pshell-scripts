$interfaceAliases = @('vEthernet (WSL)', 'vEthernet (k8s-switch)', 'vEthernet (Default Switch)')

Get-NetIPInterface | where {$_.InterfaceAlias -in $interfaceAliases} | Set-NetIPInterface -Forwarding Enabled
