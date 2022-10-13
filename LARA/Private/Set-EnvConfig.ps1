
New-Variable -Name "LARAConfiguration" -Value $(ConvertFrom-Json $(Get-Content -raw -Path ".\Globalconfig.json")) -Visibility Private -Force