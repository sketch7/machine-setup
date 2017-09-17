function Install-Chocolatey([object]$options) {
    if (!$options -or $options.ignore -or !$options.install) {
        Write-Warning "Chocolatey: 'options' not found or section is 'ignored'. Skipped"
        return
    }
    Write-Host "Chocolatey: installing..."
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

function Install-ChocolateyPackages([object]$options) {
    Install-ConfigSection $options "Chocolatey" "packages"
}