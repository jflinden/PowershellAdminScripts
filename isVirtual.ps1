<#This script parses the BIOS information and makes a best guess if the server is virtual or not

Username and password are passed as a PSCredential to isVirtual.ps1 using readCreds.ps1

e.g. .\readCreds <domain\username> <password> | .\isVirtual <computername>

#>
param (
       [string]$Computer_name
       )
#Set Isvirtual to false by default
$Isvirtual = "FALSE"

#Take pipe input
foreach($i in $input)

   {$CredPack=$i}



$Bios_info = Get-WmiObject Win32_BIOS -ComputerName $Computer_name -Credential $CredPack | Select Version

if($Bios_info.Version -like 'Xen*')
{ 
    
    $Isvirtual = "Virtual"
}
ElseIf($Bios_info.Version -like 'VM*')
{
    $Isvirtual = "Virtual"
}
Else
{
    $Isvirtual = "Physical"
}

return $Isvirtual