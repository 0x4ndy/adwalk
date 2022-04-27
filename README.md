# Description
This scripts allows for a convinient search of Active Directory objects based on the specified filter.

# Usage
```
adwalk [-filter=] [-domain=] [-username=]
```

# Example

```powershell
PS> .\adwalk.ps1 -filter "(|(samaccountname=administrator) (samaccountname=developer))" -domain domain.com -username user
```

# Future Work
Configuration of predefined filters.

# Resources
[Active Directory: LDAP Syntax Filters](https://social.technet.microsoft.com/wiki/contents/articles/5392.active-directory-ldap-syntax-filters.aspx)

