# Install the Azure PowerShell module
# installs the Azure PowerShell modules using PowerShellGet.
# Azure PowerShell works with PowerShell 5.1 or higher on Windows, 
# or PowerShell 6 on any platform. 

# Check PowerShell version
$PSVersionTable.PSVersion

# Install modules at a global scope
Install-Module -Name Az -AllowClobber

# Answer Yes or Yes to All to continue with the installation.

# Connect to Azure with a browser sign in token
Connect-AzAccount

# Update
Update-Module -Name Az

Set-AzSqlServerActiveDirectoryAdministrator -ResourceGroupName "sqlgroup"
-ServerName "<your-server>" -DisplayName "DBA_Group"

