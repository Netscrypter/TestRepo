

#$Duplicates = Get-ADComputer -Filter * | where{$_.SamAccountName -match "Duplicate"} | Select -ExpandProperty Name

FOREACH ($server in $Duplicates){

IF(Get-ADComputer -Filter {SAMAccountName -like "*$server*"} -ErrorAction SilentlyContinue){

    Get-ADComputer -Identity $server | Select Name, SAMAccountName
}
ELSE {
    Write-Warning "$Server is not present in AD"
    }
}