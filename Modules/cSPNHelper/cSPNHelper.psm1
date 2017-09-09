# 
# Author:  Matt Lavery
# Date:    04/09/2017
# 
# NOTE: This resource needs to be run under specific priviledges if the LCM is running under Local System (Default)
# https://docs.microsoft.com/en-us/powershell/dsc/runasuser
# 


# 
# Helper Functions based on https://gallery.technet.microsoft.com/scriptcenter/Service-Principal-Name-d44db998
# 

Function Get-SPN
{ 
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param(
        [Parameter(Mandatory=$true,HelpMessage='The SAM Account Name (Service Account) to retreive SPNs for')]
        [Alias('SAM')]
        [String]$AccountName
        ,
        [Parameter(Mandatory=$false,HelpMessage='The specific Service Principal Name (SPN) to retreive')]
        [Alias('SPN')]
        [String]$ServicePrincipalName
        ,
        [Parameter(Mandatory=$false,HelpMessage='The server name / domain controller where the Active Directory module will be imported from')]
        [String]$DomainController
        ,
        [Parameter(Mandatory=$false,HelpMessage='The credentials to use to access Active Directory either directly or via implicit module loading')]
        [PSCredential]$DomainCredential
    )

    [PSCustomObject]$resultObj = @();
    $spnObj = [PSCustomObject]@{
        ServiceAccount = [System.String]
        Service = [System.String]
        HostName = [System.String]
        Port = [System.UInt32]
    }

    # load the ActiveDirectory module
    if ($null -ne $DomainController)
    {
        # use an implicitly loaded module
        if ($null -ne $DomainCredential)
        {
            $ps = New-PSSession -ComputerName $DomainController -Credential $DomainCredential;
        }
        else
        {
            $ps = New-PSSession -ComputerName $DomainController -Credential $DomainCredential;
        }
        Import-Module -Name ActiveDirectory -PSSession $ps -Scope Local;
    }
    else
    {
        # load the module locally
        Import-Module -Name ActiveDirectory -Scope Local;
        $ps = $null;
    }

    # use an implicitly loaded module
    if ($null -ne $DomainCredential -and $null -eq $DomainController)
    {
        $adUserObj = Get-ADUser -LDAPFilter "(SamAccountname=$AccountName)" -Properties name, serviceprincipalname -Credential $DomainCredential -ErrorAction Stop;
    }
    else
    {
        $adUserObj = Get-ADUser -LDAPFilter "(SamAccountname=$AccountName)" -Properties name, serviceprincipalname -ErrorAction Stop;
    }

    $spnCol = $adUserObj |  
        Select-Object @{Label = "Service Principal Names";Expression = {$_.serviceprincipalname}} |  
        Select-Object -ExpandProperty "Service Principal Names" 
    
    # filter the list if needed
    If ($ServicePrincipalName)
    {
        $spnCol = $spnCol | Where {$PSitem -eq $ServicePrincipalName}
    }


    If ($spnCol)
    { 
        Write-Verbose "Processing the Service Principal Names found in $AccountName";

        foreach ($spn in $spnCol)
        {
            Write-Verbose "SPN: $($spn)";
            $components = ($spn -split '/') -split ':'
            $resultObj += [PSCustomObject]@{
                ServiceAccount = $AccountName
                Service = $components[0]
                HostName = $components[1]
                Port = $components[2]
            }
        }
    }
    Else  
    { 
        Write-Verbose "No Service Principal Names found in $AccountName";
    } 

    # remove the module from memory
    Remove-Module -Name ActiveDirectory;

    # clean up the implicit session
    if ($null -ne $ps)
    {
        Remove-PSSession -Session $ps;
    }
    
    # return our result
    return $resultObj
}






Function Add-SPN
{
    [CmdletBinding()]
    [OutputType([Bool])]
    Param(
        [Parameter(Mandatory=$true,HelpMessage='The SAM Account Name (Service Account) to retreive SPNs for')]
        [Alias('SAM')]
        [String]$AccountName
        ,
        [Parameter(Mandatory=$true,HelpMessage='The specific Service Principal Name (SPN) to retreive')]
        [Alias('SPN')]
        [String]$ServicePrincipalName
        ,
        [Parameter(Mandatory=$false,HelpMessage='The server name / domain controller where the Active Directory module will be imported from')]
        [String]$DomainController
        ,
        [Parameter(Mandatory=$false,HelpMessage='The credentials to use to access Active Directory either directly or via implicit module loading')]
        [PSCredential]$DomainCredential
    )

    # the status we will return
    [bool]$result = $false;


    # load the ActiveDirectory module
    if ($null -ne $DomainController)
    {
        # use an implicitly loaded module
        if ($null -ne $DomainCredential)
        {
            $ps = New-PSSession -ComputerName $DomainController -Credential $DomainCredential;
        }
        else
        {
            $ps = New-PSSession -ComputerName $DomainController -Credential $DomainCredential;
        }
        Import-Module -Name ActiveDirectory -PSSession $ps -Scope Local;
    }
    else
    {
        # load the module locally
        Import-Module -Name ActiveDirectory -Scope Local;
        $ps = $null;
    }

    # use an implicitly loaded module
    if ($null -ne $DomainCredential -and $null -eq $DomainController)
    {
        $adUserObj = Get-ADUser -LDAPFilter "(SamAccountname=$AccountName)" -Properties name, serviceprincipalname -Credential $DomainCredential -ErrorAction Stop;
    }
    else
    {
        $adUserObj = Get-ADUser -LDAPFilter "(SamAccountname=$AccountName)" -Properties name, serviceprincipalname -ErrorAction Stop;
    }

    
    # check for an existing SPN
    $existingSPN = $adUserObj | Where-Object {$_.serviceprincipalname -eq $ServicePrincipalName } |  Select-Object serviceprincipalname;
    If ($existingSPN) 
    {
        Write-Error "SPN $($ServicePrincipalName) already exists on $AccountName"
        break    
    }

    Write-Verbose "Adding $ServicePrincipalName to $AccountName.";
    Try
    {
        if ($null -ne $DomainCredential -and $null -eq $DomainController)
        {
            Set-ADObject -Identity $adUserObj.ObjectGUID -add @{serviceprincipalname=$ServicePrincipalName} -Credential $DomainCredential -ErrorVariable SPNerror -ErrorAction SilentlyContinue;
        }
        else
        {
            Set-ADObject -Identity $adUserObj.ObjectGUID -add @{serviceprincipalname=$ServicePrincipalName} -ErrorVariable SPNerror -ErrorAction SilentlyContinue;
        }
    }
    Catch [exception] 
    {
        Write-Error "An error occured while modifying $AccountName. Error details: $($_.Exception.Message)";
    }
    If ($SPNerror.Count -eq '0')
    {
        Write-Verbose "$ServicePrincipalName added successfully to $AccountName";
        $result = $true;
    }

    # remove the module from memory
    Remove-Module -Name ActiveDirectory;
    
    # clean up the implicit session
    if ($null -ne $ps)
    {
        Remove-PSSession -Session $ps;
    }

    return $result;
}





Function Remove-SPN 
{ 
    [CmdletBinding()]
    [OutputType([Bool])]
    Param(
        [Parameter(Mandatory=$true,HelpMessage='The SAM Account Name (Service Account) to retreive SPNs for')]
        [Alias('SAM')]
        [String]$AccountName
        ,
        [Parameter(Mandatory=$true,HelpMessage='The specific Service Principal Name (SPN) to retreive')]
        [Alias('SPN')]
        [String]$ServicePrincipalName
        ,
        [Parameter(Mandatory=$false,HelpMessage='The server name / domain controller where the Active Directory module will be imported from')]
        [String]$DomainController
        ,
        [Parameter(Mandatory=$false,HelpMessage='The credentials to use to access Active Directory either directly or via implicit module loading')]
        [PSCredential]$DomainCredential
    )

    # the status we will return
    [bool]$result = $false;


    # load the ActiveDirectory module
    if ($null -ne $DomainController)
    {
        # use an implicitly loaded module
        if ($null -ne $DomainCredential)
        {
            $ps = New-PSSession -ComputerName $DomainController -Credential $DomainCredential;
        }
        else
        {
            $ps = New-PSSession -ComputerName $DomainController -Credential $DomainCredential;
        }
        Import-Module -Name ActiveDirectory -PSSession $ps -Scope Local;
    }
    else
    {
        # load the module locally
        Import-Module -Name ActiveDirectory -Scope Local;
        $ps = $null;
    }

    # use an implicitly loaded module
    if ($null -ne $DomainCredential -and $null -eq $DomainController)
    {
        $adUserObj = Get-ADUser -LDAPFilter "(SamAccountname=$AccountName)" -Properties name, serviceprincipalname -Credential $DomainCredential -ErrorAction Stop;
    }
    else
    {
        $adUserObj = Get-ADUser -LDAPFilter "(SamAccountname=$AccountName)" -Properties name, serviceprincipalname -ErrorAction Stop;
    }

    # check for an existing SPN
    $existingSPN = $adUserObj | Where-Object {$_.serviceprincipalname -eq $ServicePrincipalName } |  Select-Object serviceprincipalname;
    If ($existingSPN)
    {
        Write-Verbose "Removing $SPN from $ServiceAccountName.";
        
        Try
        {
            if ($null -ne $DomainCredential -and $null -eq $DomainController)
            {
                Set-ADObject -Identity $adUserObj.ObjectGUID -remove @{serviceprincipalname=$ServicePrincipalName} -Credential $DomainCredential -ErrorVariable SPNerror -ErrorAction SilentlyContinue;
            }
            else
            {
                Set-ADObject -Identity $adUserObj.ObjectGUID -remove @{serviceprincipalname=$ServicePrincipalName} -ErrorVariable SPNerror -ErrorAction SilentlyContinue;
            }
        }
        Catch [exception] 
        {
            Write-Error "An error occured while modifying $AccountName. Error details: $($_.Exception.Message)";
        }
        If ($SPNerror.Count -eq '0')
        {
            Write-Verbose "$ServicePrincipalName removed successfully from $AccountName";
            $result = $true;
        }

    }

    # remove the module from memory
    Remove-Module -Name ActiveDirectory;
    
    # clean up the implicit session
    if ($null -ne $ps)
    {
        Remove-PSSession -Session $ps;
    }
    
    return $result;
    

}


