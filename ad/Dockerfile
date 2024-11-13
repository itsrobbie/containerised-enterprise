# Use a Windows Server Core image if available, or adapt for your choice
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Install Active Directory Domain Services
RUN Install-WindowsFeature AD-Domain-Services

# Configure AD with PowerShell script
COPY setup-ad.ps1 /setup-ad.ps1
RUN powershell.exe -ExecutionPolicy Bypass -File C:\setup-ad.ps1
