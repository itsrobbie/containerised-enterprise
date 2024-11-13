# Variables for domain and credentials
$DomainName = "slurm.local"
$SafeModeAdminPassword = ConvertTo-SecureString "PA$$w0rd" -AsPlainText -Force
$DomainAdminPassword = ConvertTo-SecureString "PA$$w0rd" -AsPlainText -Force

# Promote the server to a Domain Controller
Install-ADDSForest -DomainName $DomainName -SafeModeAdministratorPassword $SafeModeAdminPassword -DomainNetbiosName "slurm" -InstallDNS -Force

# Wait for the DC to be up and running
Start-Sleep -Seconds 20

# Creating Organizational Units (OUs)
New-ADOrganizationalUnit -Name "Slurm Inc" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Departments" -Path "OU=Slurm Inc,DC=slurm,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Locations" -Path "OU=Slurm Inc,DC=slurm,DC=local" -ProtectedFromAccidentalDeletion $false

# Departments OUs
New-ADOrganizationalUnit -Name "CEO Office" -Path "OU=Departments,OU=Slurm Inc,DC=slurm,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Marketing" -Path "OU=Departments,OU=Slurm Inc,DC=slurm,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Operations" -Path "OU=Departments,OU=Slurm Inc,DC=slurm,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Sales" -Path "OU=Departments,OU=Slurm Inc,DC=slurm,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "HR" -Path "OU=Departments,OU=Slurm Inc,DC=slurm,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "IT" -Path "OU=Departments,OU=Slurm Inc,DC=slurm,DC=local" -ProtectedFromAccidentalDeletion $false

# Locations OUs
New-ADOrganizationalUnit -Name "USA Office" -Path "OU=Locations,OU=Slurm Inc,DC=slurm,DC=local" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "NZ Office" -Path "OU=Locations,OU=Slurm Inc,DC=slurm,DC=local" -ProtectedFromAccidentalDeletion $false

# Creating Users in each department
New-ADUser -Name "Fry Johnson" -GivenName "Fry" -Surname "Johnson" -SamAccountName "fry.johnson" -UserPrincipalName "fry.johnson@$DomainName" -Path "OU=CEO Office,OU=Departments,OU=Slurm Inc,DC=slurm,DC=local" -AccountPassword (ConvertTo-SecureString "UserPassword123!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Leela Turanga" -GivenName "Leela" -Surname "Turanga" -SamAccountName "leela.turanga" -UserPrincipalName "leela.turanga@$DomainName" -Path "OU=Marketing,OU=Departments,OU=Slurm Inc,DC=slurm,DC=local" -AccountPassword (ConvertTo-SecureString "UserPassword123!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Bender Rodriguez" -GivenName "Bender" -Surname "Rodriguez" -SamAccountName "bender.rodriguez" -UserPrincipalName "bender.rodriguez@$DomainName" -Path "OU=Operations,OU=Departments,OU=Slurm Inc,DC=slurm,DC=local" -AccountPassword (ConvertTo-SecureString "UserPassword123!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Hermes Conrad" -GivenName "Hermes" -Surname "Conrad" -SamAccountName "hermes.conrad" -UserPrincipalName "hermes.conrad@$DomainName" -Path "OU=HR,OU=Departments,OU=Slurm Inc,DC=slurm,DC=local" -AccountPassword (ConvertTo-SecureString "UserPassword123!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Amy Wong" -GivenName "Amy" -Surname "Wong" -SamAccountName "amy.wong" -UserPrincipalName "amy.wong@$DomainName" -Path "OU=IT,OU=Departments,OU=Slurm Inc,DC=slurm,DC=local" -AccountPassword (ConvertTo-SecureString "UserPassword123!" -AsPlainText -Force) -Enabled $true

# Create Security Groups
New-ADGroup -Name "Marketing Team" -GroupScope Global -GroupCategory Security -Path "OU=Marketing,OU=Departments,OU=Slurm Inc,DC=slurm,DC=local"
New-ADGroup -Name "Operations Team" -GroupScope Global -GroupCategory Security -Path "OU=Operations,OU=Departments,OU=Slurm Inc,DC=slurm,DC=local"
New-ADGroup -Name "HR Team" -GroupScope Global -GroupCategory Security -Path "OU=HR,OU=Departments,OU=Slurm Inc,DC=slurm,DC=local"
New-ADGroup -Name "IT Admins" -GroupScope Global -GroupCategory Security -Path "OU=IT,OU=Departments,OU=Slurm Inc,DC=slurm,DC=local"

# Create Distribution Lists
New-ADGroup -Name "Company-Wide Announcements" -GroupScope Universal -GroupCategory Distribution -Path "OU=Departments,OU=Slurm Inc,DC=slurm,DC=local"

# Adding Users to Groups
Add-ADGroupMember -Identity "Marketing Team" -Members "leela.turanga"
Add-ADGroupMember -Identity "Operations Team" -Members "bender.rodriguez"
Add-ADGroupMember -Identity "HR Team" -Members "hermes.conrad"
Add-ADGroupMember -Identity "IT Admins" -Members "amy.wong"

# Assigning Users to Company-Wide Announcements DL
Add-ADGroupMember -Identity "Company-Wide Announcements" -Members "fry.johnson","leela.turanga","bender.rodriguez","hermes.conrad","amy.wong"

# Output AD details to confirm setup
Write-Host "Slurm Inc AD setup complete with users, groups, OUs, and locations."
