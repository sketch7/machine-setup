param($currentStep = "init", $currentProfileName = $null)

Push-Location $PSScriptRoot
$currentScriptPath = $PSCommandPath

Import-Module ".\modules\chocolatey" -Force
Import-Module ".\modules\node-js" -Force
Import-Module ".\modules\other-commands" -Force
Import-Module "SSV-Core" -Force

Grant-PowershellAsAdmin $currentScriptPath ($currentStep, $currentProfileName)

$step1 = "init"
$step2 = "choco-installations"
$step3 = "last-step"
$Script:selectedProfileName = $currentProfileName

Clear-Host
function Main {
    Write-Host "----------------------------------------------------------" -ForegroundColor Cyan
    Write-Host " Machine Setup -  Started!" -ForegroundColor Cyan
    Write-Host "----------------------------------------------------------" -ForegroundColor Cyan

    $config = Get-MergedConfig
    if (Resume-AndContinue $currentStep $step1) {
        Set-PSGalleryAsTrusted $config.setPSGalleryAsTrusted
        Install-Chocolatey $config.chocolatey
        Install-NodeJs $config.nodeJs
        Set-NodeJsGlobalSettings $config.nodeJs
        Invoke-PreCommands $config.otherCommands

        if ($config.restartRequired) {
            Wait-OrPressAnyKey "Press any key to restart or it will restart in {0} seconds"
            Restart-AndResume $currentScriptPath ($step2, $Script:selectedProfileName)
        }
    }

    if (Resume-AndContinue $currentStep $step2) {
        Install-ChocolateyPackages $config.chocolatey

        if ($config.chocolatey -and $config.chocolatey.restartRequired) {
            Wait-OrPressAnyKey "Press any key to restart or it will restart in {0} seconds"
            Restart-AndResume $currentScriptPath ($step3, $Script:selectedProfileName)
        }
    }

    if (Resume-AndContinue $currentStep $step3) {
        Install-NpmPackages $config.nodeJs
        Invoke-PostCommands $config.otherCommands
    }

    Write-Host "----------------------------------------------------------" -ForegroundColor Green
    Write-Host " Machine Setup -  Complete!" -ForegroundColor Green
    Write-Host "----------------------------------------------------------" -ForegroundColor Green
    Wait-OrPressAnyKey "Press any key to close script or it will be closed in {0} seconds"
}

function Set-PSGalleryAsTrusted([bool]$isInstallationRequired) {
    if ($isInstallationRequired) {
        Write-Warning "Powershell Gallery: is going to be set as 'trusted'"
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    }
    else {
        Write-Warning "Powershell Gallery: Skipped"
    }
}

function Get-MergedConfig() {
    $path = ".\"
    $baseConfig = "base"
    $configFileName = "config.{0}.json"
    if (!$Script:selectedProfileName) {
        $Script:selectedProfileName = Read-Host "Please input a config name. example: 'home' or 'work'. Default value is 'home'"
        if (!$Script:selectedProfileName) {
            $Script:selectedProfileName = "home"
        }
    }
    else { Write-Host "Retreiving profile: '${Script:selectedProfileName}'" }

    if ($Script:selectedProfileName.ToLower() -cmatch "test") {
        $path = ".\test\"
    }

    $config = Get-JsonFile ("${path}${configFileName}" -f $baseConfig)
    $userProfile = Get-JsonFile ("${path}${configFileName}" -f $Script:selectedProfileName) -ErrorAction SilentlyContinue

    if (!$config -or !$userProfile) {
        Throw "config not found: check both exists base: '${base}' and profile: '${selectedProfileName}'"
    }

    return Merge-Object $config $userProfile
}

Main