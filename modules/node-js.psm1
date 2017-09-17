$nodePath = "$env:ProgramFiles\nodejs"
$nodeModulesPath = "$nodePath\node_modules"

function Install-NodeJs([object]$options) {
    if (!$options -or $options.ignore -or !$options.install) {
        Write-Warning "NodeJs: installation Skipped"
        return
    }

    Write-Host "NodeJs: installing..."
    Invoke-SimpleCommand "choco install nodejs -y"
}

function Install-NpmPackages([object]$options) {
    Install-ConfigSection $options "NodeJs" "packages"
}

function Set-NodeJsGlobalSettings([object]$options) {
    if (!$options -or $options.ignore -or !$options.setGlobalSettings) {
        Write-Warning "NodeJs Global Settings: Skipped"
        return
    }
    Write-Host "----------------------------------------------------------" -ForegroundColor Cyan
    Write-Host " NodeJs: Setting global default configuration -  Started!" -ForegroundColor Cyan
    Write-Host "----------------------------------------------------------" -ForegroundColor Cyan

    Set-FolderStructure
    Set-EnvironmentVariables
    Set-NodeGlobalConfig

    Write-Host "----------------------------------------------------------" -ForegroundColor Green
    Write-Host " NodeJs: Setting global default configuration -  Complete!" -ForegroundColor Green
    Write-Host "----------------------------------------------------------" -ForegroundColor Green
}

function Set-FolderStructure() {
    $folderName = "$nodePath\npm-cache"
    New-Folder $folderName

    $folderName = "$nodePath\etc"
    New-Folder $folderName
}

function Set-EnvironmentVariables() {
    $regValueName = "NODE"
    $regValue = $nodePath
    Set-EnvironmentVar $regValueName $regValue

    #CLA: Check if this can be changed to 'NODE_MODULES_PATH'
    $regValueName = "NODE_PATH"
    $regValue = $nodeModulesPath
    Set-EnvironmentVar $regValueName $regValue
}

function Set-NodeGlobalConfig () {
    New-Item "$nodeModulesPath\npm\npmrc" -type file -force -value "prefix=$nodePath"
    New-Item "$nodePath\etc\npmrc" -type file -force -value "prefix=$nodePath `r`ncache=$nodePath\npm-cache"
}