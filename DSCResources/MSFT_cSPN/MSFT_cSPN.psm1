# 
# Author:  Matt Lavery
# Date:    04/09/2017
# 
# NOTE: This resource needs to be run under specific priviledges if the LCM is running under Local System (Default)
# https://docs.microsoft.com/en-us/powershell/dsc/runasuser
# 

# Import the helper function
Import-Module -Name (Join-Path -Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) -ChildPath '\Modules\cSPNHelper\cSPNHelper.psm1') -Force


function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $ServiceAccount,

        [parameter(Mandatory = $true)]
        [System.String]
        $Service,

        [parameter(Mandatory = $true)]
        [System.String]
        $HostName,

        [parameter(Mandatory = $true)]
        [System.UInt32]
        $Port,

        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."

    $currentSPN = Get-SPN -AccountName $ServiceAccount -ServicePrincipalName "$($Service)/$($HostName):$($Port)" -DomainController $DomainController -DomainCredential $DomainCredential;
    
    $returnValue = @{
        ServiceAccount = $currentSPN.ServiceAccount
        Service = $currentSPN.Service
        HostName = $currentSPN.HostName
        Port = $currentSPN.Port
        DomainController = [System.String]
        DomainCredential = [System.Management.Automation.PSCredential]
    }

    $returnValue
    
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $ServiceAccount,

        [parameter(Mandatory = $true)]
        [System.String]
        $Service,

        [parameter(Mandatory = $true)]
        [System.String]
        $HostName,

        [parameter(Mandatory = $true)]
        [System.UInt32]
        $Port,

        [System.String]
        $DomainController,

        [System.Management.Automation.PSCredential]
        $DomainCredential,

        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."

    #Include this line if the resource requires a system reboot.
    #$global:DSCMachineStatus = 1

    if ($Ensure)
    {
        Add-SPN -AccountName $ServiceAccount -ServicePrincipalName "$($Service)/$($HostName):$($Port)" -DomainController $DomainController -DomainCredential $DomainCredential;
    }
    else
    {
        Remove-SPN -AccountName $ServiceAccount -ServicePrincipalName "$($Service)/$($HostName):$($Port)" -DomainController $DomainController -DomainCredential $DomainCredential;
    }

}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $ServiceAccount,

        [parameter(Mandatory = $true)]
        [System.String]
        $Service,

        [parameter(Mandatory = $true)]
        [System.String]
        $HostName,

        [parameter(Mandatory = $true)]
        [System.UInt32]
        $Port,

        [System.String]
        $DomainController,

        [System.Management.Automation.PSCredential]
        $DomainCredential,

        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."

    $currentSPN = Get-SPN -AccountName $ServiceAccount -ServicePrincipalName "$($Service)/$($HostName):$($Port)" -DomainController $DomainController -DomainCredential $DomainCredential;
    
    $result = [System.Boolean]($null -ne $currentSPN)
    
    $result
    
}


Export-ModuleMember -Function *-TargetResource

