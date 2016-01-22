
Function createLocalUser
{
param($User,$pw,$Description)

$computer = get-content env:computername
#Create new local user

$cn =[ADSI]"WinNT://$computer"
$user = $cn.Create("User",$User)
$user.SetPassword($pw)
$user.setinfo()
$user.description = "$Description"
$user.SetInfo()
}