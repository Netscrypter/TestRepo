
$CitrixLeaders = Import-Excel C:\users\gbelton\Downloads\Citrix_List_with_leaders.xlsx
$EmployeesOnly = $CitrixLeaders | select -ExpandProperty Employee
$AddEmail = FOREACH ($Employee in $EmployeesOnly){

Get-ADUser -Filter {Name -eq $Employee} -Properties * | select Name, EmailAddress,@{Name="Manager";Expression={$CitrixLeaders | Where{$_.Employee -match $Employee} | Select -ExpandProperty Manager}},
@{Name="NextManager";Expression={$CitrixLeaders | Where{$_.Employee -match $Employee} | Select -ExpandProperty NextManager}},
@{Name="Organization";Expression={$CitrixLeaders | Where{$_.Employee -match $Employee} | Select -ExpandProperty Organization}}

}

