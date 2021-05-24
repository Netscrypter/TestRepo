Get-ADUser -Filter * -Properties * | where{$_.Enabled -eq "True"} | where{$_.CanonicalName -notmatch "Default SailPoint Users" -or $_.CanonicalName -notmatch "Elevated_Local_Admin" -or $_.CanonicalName -notmatch "Former Employees" -or $_.CanonicalName -notmatch "Ishbia" -or $_.CanonicalName -notmatch "MBAM" -or $_.CanonicalName -notmatch "TestingOU"} | Select -ExpandProperty DisplayName | Out-file C:\users\gbelton\Downloads\AllUWMUsers.txt








