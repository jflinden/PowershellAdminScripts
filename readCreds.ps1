<# This script reads and returns a username and password as a PSCredential object
   Based on blog post by msdn user @koteshblog: http://blogs.msdn.com/b/koteshb/archive/2010/02/13/powershell-creating-a-pscredential-object.aspx

   username and passowrd are passed as arguments:

   ie.   readCreds <username> <password>
#>

param($username, $password);
$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential($username,$secpasswd)





return $mycreds