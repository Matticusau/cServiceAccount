# cServiceAccount
A PowerShell DSC Resource for managing Service Accounts (initially only includes SPN functionality)

## System Requirements

* WMF (PowerShell) 5.0 (5.1 is required if you use Composite resources)

## Required PowerShell Modules
The following PowerShell modules.
* ActiveDirectory (for cSPN, otherwise a Domain Controller to implicitly remote to)

## Example
See the .\Examples folder

## Versions
This project uses [SemVer](http://semver.org/) for versioning. While the following is an overview of the offical releases, for the detailed versions available, see the [tags on this repository](https://github.com/matticusau/cServiceAccount/tags). 

### Unreleased

* None

### 1.0.0.0

* Initial push 

## I found a bug
Create an issue through GitHub and lets work on solving it together :)
	
## Contributing
If you are interested in contributing please check out common DSC Resources [contributing guidelines](https://github.com/PowerShell/DscResource.Kit/blob/master/CONTRIBUTING.md). These are the standards I try and adopt for ALL of my work as well.

### Dev Tools
The following development tools have been used when authoring this project.
* VSCode
* PowerShell 5.1
* Git

### Setting up your Dev environment
The following actions need to be taken if you wish to contribute
1. Install VSCode
2. Install PowerShell 5.0
3. Install the VSCode Extensions - C#, mssql, PowerShell, vscode-icons
4. Configure the extensions, for example set your icons (File > Preferences) to vscode-icons
6. Clone this repository
7. Create a branch for your work

## License
This project is released under the [MIT License](https://github.com/Matticusau/cServiceAccount/blob/master/LICENSE)

## Contributors

* Matticusau [GitHub](https://github.com/Matticusau) | [twitter](https://twitter.com/matticusau)