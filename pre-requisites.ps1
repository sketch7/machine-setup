#Requires -RunAsAdministrator
Clear-Host

Write-Host ""
Write-Host "------------------------------------------" -ForegroundColor Cyan
Write-Host "         pre-requisites - started!" -ForegroundColor Cyan
Write-Host "------------------------------------------" -ForegroundColor Cyan

Write-Host ""
Write-Host "trying to set ExecutionPolicy to 'RemoteSigned'"
Set-ExecutionPolicy RemoteSigned

Write-Host "trying to install: PowerShellGet"
Install-Module -Name PowerShellGet -Force

Write-Host "trying to install: SSV-Core"
Install-Module -Name "SSV-Core" -Force

Write-Host ""
Write-Host "------------------------------------------" -ForegroundColor Cyan
Write-Host "         pre-requisites - complete!" -ForegroundColor Cyan
Write-Host "------------------------------------------" -ForegroundColor Cyan