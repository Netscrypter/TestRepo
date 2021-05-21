<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Add-UWMAllUsersGroup
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false,
                   Position=0)]
        $Param1,

        # Param2 help description
        [int]
        $Param2
    )


BEGIN{
#$users = @("Adam Vida")
$users = Get-Content -Path 'C:\users\gbelton\Downloads\AddTOADNEW.txt'
$numberofusersfound = 0
$numberofusersNotFound = 0
$Error.Clear()
$groups = Get-ADGroup -Filter 'Name -eq "GRP-S-UWM All"' | select -ExpandProperty Name

}

PROCESS{

TRY{
    FOREACH ($User in $Users){
        
        Write-Output "[$(get-date -Format g)] Searching for user $User"
            IF(!(Get-ADUser -Filter {DisplayName -eq $User} -ErrorAction SilentlyContinue)){
                Write-Output "[$(get-date -Format g)] Warning! Can't locate user $User"

                # Start of Search for user by First and Last Name 
                Write-Output "[$(get-date -Format g)] Attempting to locate user $User by searching Name Property and Not DisplayName Property."
                   
                    # Block Not Needed
                    #$FirstName = $user.Split("")[0]
                    #$LastName  = $user.Split("")[1]
                    # Block Not Needed

                    IF(!(Get-ADUser -Filter {Name -eq $User} -ErrorAction SilentlyContinue)){
                    #IF(!(Get-ADUser -Filter * | where{$_.GivenName -match "$FirstName" -and $_.SurName -match "$LastName"})){
                        Write-Output "[$(get-date -Format g)] Attempt to locate user $User by searching Name Property Failed." 
                            $numberofusersNotFound++
                            $UsersNotFound+= "$user,"

                    } #IF(!(Get-ADUser -Filter * | where{$_.GivenName -match "$FirstName" -and $_.SurName -match "$LastName"})){
                    ELSE{
                        Write-Output "[$(get-date -Format g)] Successfully located user $User by searching Name Property." 
                        $numberofusersfound++

                        # Start of Remove Groups by Name Property

                            FOREACH ($group in $groups){
                            Write-Output "[$(get-date -Format g)] Adding user $user to the $group group."
                            Get-ADUser -Filter {Name -eq $User} | Add-ADPrincipalGroupMembership -MemberOf "$group" -Confirm:$false

	                        } # FOREACH ($group in $groups){
                        # End of Remove Groups by Name Property

                            # Start of check to see if group was readded
                            <#
                            FOREACH ($group in $groups){
                            IF(!(Get-ADUser -Filter {Name -eq $User} | Get-ADPrincipalGroupMembership | where{$_.Name -eq "$group"})){
                                Write-Output "[$(get-date -Format g)] Warning! Failed to add user $user back to $group group"
                                }
                                ELSE{
                                Write-Output "[$(get-date -Format g)] User $user successfully added back to $group group"
                                    }
                                }
                                #>
                            # End of check to see if group was readded

                      

                    } # ELSE
                # END of Search for user by First and Last Name 

                }
            ELSE{
                Write-Output "[$(get-date -Format g)] Found user $User"
                    $numberofusersfound++

                        # Start of Remove Groups by DisplayName Property

                            FOREACH ($group in $groups){
                            Write-Output "[$(get-date -Format g)] Adding user $user to the $group group."
                            Get-ADUser -Filter {DisplayName -eq $User} | Add-ADPrincipalGroupMembership -MemberOf "$group" -Confirm:$false

	                        } # FOREACH ($group in $groups){
                            # End of Remove Groups by DisplayName Property

                            <#
                            # Start of check to see if group was readded
                            FOREACH ($group in $groups){
                            IF(!(Get-ADUser -Filter {DisplayName -eq $User} | Get-ADPrincipalGroupMembership | where{$_.Name -eq "$group"})){
                                Write-Output "[$(get-date -Format g)] Warning! Failed to add user $user back to $group group"
                                }
                                ELSE{
                                Write-Output "[$(get-date -Format g)] User $user successfully added back to $group group"
                                    }
                                }
                            # End of check to see if group was readded
                            #>

                        

                    
                } # ELSE{
            } # FOREACH ($User in $Users){
 
        } # TRY{

 CATCH{
    Write-Warning "[$(get-date -Format g)] $Error[0].Exception.message"
    } # CATCH

} # PROCESS

END{
Write-Output "[$(get-date -Format g)] Total number of users ($($Users.count))"
Write-Output "[$(get-date -Format g)] Number of users found in AD ($numberofusersfound)"
Write-Output "[$(get-date -Format g)] Number of users not found in AD ($numberofusersNotFound)"
Write-Output "[$(get-date -Format g)] Any Errors that Occured during script execution will be listed below"
$Error.Exception.Message
#Write-Output "[$(get-date -Format g)] The Following users were not found in Active Directory"
#$UsersNotFound.Split(",")
    }

} # function Test-GBADUsers

Add-UWMAllUsersGroup


Read-Host "Press any button to exit."