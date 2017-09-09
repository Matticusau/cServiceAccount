# 
# An example of creating an SPN for a host of SQLNode2 using the short name and port 1433
# 

Configuration SetupSPNs
{
    [CmdLetBinding()]
    Param(
        [String]$DomainController
        ,
        [PSCredential]$DomainCredential
    )

    Import-DscResource –ModuleName 'cServiceAccount';
    
    node $AllNodes.NodeName
    {

        
        cSPN mySPN1
        {
            Ensure = 'Present'
            ServiceAccount = $node.ServiceAccount
            Service = 'MSSQLSvc'
            HostName = $node.SPNHostName
            Port = 1433
            DomainCredential = $DomainCredential
            DomainController = $DomainController
            PsDscRunAsCredential = $DomainCredential
        }

    }

    
} 



$MyData = @{
    AllNodes = 
    @(
        @{
            NodeName        = 'localhost'
            SPNHostName     = 'sqlnode2'
            ServiceAccount  = 'sql_sqlnode2'

            # only for lab
            PSDscAllowPlainTextPassword = $true

            # in Production makesure the mof is secured
            # Thumbprint      = ''
            # CertificateFile = ''
        }
    )

    NonNodeData = ""  
}



SetupSPNs -ConfigurationData $MyData -DomainController DC1 -DomainCredential (Get-Credential) -OutputPath . -Verbose

Start-DscConfiguration -Path .\SetupSPNs -Wait -Verbose -Force

