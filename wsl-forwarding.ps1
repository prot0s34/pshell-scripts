$interfaceAliases = @('*WSL*', 'vEthernet (k8s-switch)', 'vEthernet (Default Switch)')

Get-NetIPInterface | where {$_.InterfaceAlias -like $interfaceAliases} | Set-NetIPInterface -Forwarding Enabled
