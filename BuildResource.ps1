#Set-Location 'C:\Users\matt_\Documents\Customer Engagements\Communities.DSC\DSCConfigs\RequiredModules\';

# New-xDscResource -Name MSFT_cSPN -FriendlyName cSPN -ModuleName cServiceAccount -Path . -Force -Property @(
#     New-xDscResourceProperty -Name ServiceAccount        -Type String           -Attribute Key
#     New-xDscResourceProperty -Name Service               -Type String           -Attribute Required
#     New-xDscResourceProperty -Name HostName              -Type String           -Attribute Required
#     New-xDscResourceProperty -Name Port                  -Type Uint32           -Attribute Required
#     New-xDscResourceProperty -Name DomainController      -Type String           -Attribute Write
#     New-xDscResourceProperty -Name DomainCredential      -Type PSCredential     -Attribute Write
# )


Update-xDscResource -Name MSFT_cSPN -FriendlyName cSPN -Force -Property @(
    New-xDscResourceProperty -Name ServiceAccount        -Type String           -Attribute Key
    New-xDscResourceProperty -Name Service               -Type String           -Attribute Required
    New-xDscResourceProperty -Name HostName              -Type String           -Attribute Required
    New-xDscResourceProperty -Name Port                  -Type Uint32           -Attribute Required
    New-xDscResourceProperty -Name DomainController      -Type String           -Attribute Write
    New-xDscResourceProperty -Name DomainCredential      -Type PSCredential     -Attribute Write
    New-xDscResourceProperty -Name Ensure                -Type String           -Attribute Required -ValueMap 'Present','Absent' -Values 'Present','Absent'
)