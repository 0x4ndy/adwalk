# Author: 0x4ndy (Andy)
# E-mail: andy@andy.codes
# 
# This script allows for a convenient search of Active Directory objects based on the specified filter.
#
# Usage:
# adwalk [-filter=] [-domain=] [-username=]
#
# Example:
# PS> .\adwalk.ps1 -filter "(|(samaccountname=administrator) (samaccountname=developer))" -domain domain.com -username user

param(
    [string]$filter = "samAccountType=805306368", # SAM Account Type based on https://docs.microsoft.com/en-us/windows/win32/adschema/a-samaccounttype?redirectedfrom=MSDN
    [string]$domain = "",
    [string]$username = ""
)

$user = $null
$password = $null

if (($domain -ne "") -and ($username -ne ""))
{
    $user = $domain + "\" + $username
    $secpwd = Read-Host "Password" -AsSecureString
    $password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secpwd))
}

Write-Host $("[+] Searching for: " + $filter)

$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$pdc = ($domainObj.PdcRoleOwner).Name

$distinguishedName = "DC=$($domainObj.Name.Replace('.', ',DC='))"

$searchString = "LDAP://" + $pdc + "/" + $distinguishedName

$searcher = New-Object System.DirectoryServices.DirectorySearcher([ADSI]$searchString)
if ($user -and $password)
{
    Write-Host $("[+] Searching with credentials for " + $user)
    $objDomain = New-Object System.DirectoryServices.DirectoryEntry($searchString, $user, $password)
}
else
{
    Write-Host "[+] Searching without credentials"
    $objDomain = New-Object System.DirectoryServices.DirectoryEntry($searchString)
}

$searcher.SearchRoot = $objDomain
$searcher.Filter = $filter
$searchResults = $searcher.FindAll()

Write-Host "[+] Search resounts:" 
Write-Host "------------------" 

Foreach($item in $searchResults)
{
    Foreach($prop in $item.Properties)
    {
        $prop
    }

    Write-Host "------------------"
}

Write-Host "[+] Done"
