# Helper Functions for the cSPN DSC Resource within the cServiceAccount DSC Module

# Get-Spn
This helper function provides a method to retreive the SPNs currently configured for a supplied account.

## Parameters
### AccountName [String]
The SamAccountName used within the LDAPFilter to identify the account we will work with

### DomainController [String]
The Domain Controller to import the ActiveDirectory module from (Implicit Remoting). If this parameter is not supplied then the module needs to be installed locally on the machine you are running this function from.

### DomainCredential [PSCredential]
The credential to use to authenticate to the Domain Controller either when importing the Active Directory module (Implicit Remoting) or when running the *-ADUser and *-ADObject cmdlets. This user will need adequate permissions on the domain to either remote to the Domain Controller or to read and write to AD Objects.

## Example

```
$domainCred = Get-Credential FourthCoffee\mattl.admin
# Get the current SPN
Get-Spn -AccountName sql_SQLNODE2 -DomainController DC1 -DomainCredential $domainCred
```

# Add-Spn
This helper function provides a method to add a new SPNs to the supplied account. If the SPN already exists an error is returned.

## Parameters
### AccountName [String]
The SamAccountName used within the LDAPFilter to identify the account we will work with

### ServicePrincipalName [String]
This is the Service Principal Name (SPN) to add to the account. It should be in the format of '{service}/{host}:{port}' (e.g. 'MSSQLSvc/SQLNode2:1433')

### DomainController [String]
The Domain Controller to import the ActiveDirectory module from (Implicit Remoting). If this parameter is not supplied then the module needs to be installed locally on the machine you are running this function from.

### DomainCredential [PSCredential]
The credential to use to authenticate to the Domain Controller either when importing the Active Directory module (Implicit Remoting) or when running the *-ADUser and *-ADObject cmdlets. This user will need adequate permissions on the domain to either remote to the Domain Controller or to read and write to AD Objects.

## Example

```
$domainCred = Get-Credential FourthCoffee\mattl.admin
# Add a new SPN to an account
Add-Spn -AccountName sql_SQLNODE2 -ServicePrincipalName 'MSSQLSvc/SQLNode2:1433' -DomainController DC1 -DomainCredential $domainCred
# List all the SPNs now on the account
Get-Spn -AccountName sql_SQLNODE2 -DomainController DC1 -DomainCredential $domainCred
```


# Remove-Spn
This helper function provides a method to remove a SPNs from the supplied account. If the SPN does not exist an error is returned.

## Parameters
### AccountName [String]
The SamAccountName used within the LDAPFilter to identify the account we will work with

### ServicePrincipalName [String]
This is the Service Principal Name (SPN) to add to the account. It should be in the format of '{service}/{host}:{port}' (e.g. 'MSSQLSvc/SQLNode2:1433')

### DomainController [String]
The Domain Controller to import the ActiveDirectory module from (Implicit Remoting). If this parameter is not supplied then the module needs to be installed locally on the machine you are running this function from.

### DomainCredential [PSCredential]
The credential to use to authenticate to the Domain Controller either when importing the Active Directory module (Implicit Remoting) or when running the *-ADUser and *-ADObject cmdlets. This user will need adequate permissions on the domain to either remote to the Domain Controller or to read and write to AD Objects.

## Example

```
$domainCred = Get-Credential FourthCoffee\mattl.admin
# Delete a SPN from an account
Remove-Spn -AccountName sql_SQLNODE2 -ServicePrincipalName 'MSSQLSvc/SQLNode2:1433' -DomainController DC1 -DomainCredential $domainCred
# List all the SPNs now on the account
Get-Spn -AccountName sql_SQLNODE2 -DomainController DC1 -DomainCredential $domainCred
```
